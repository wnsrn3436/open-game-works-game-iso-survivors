import { randomUUID } from 'node:crypto';
import * as Testing from '../core/testing/dev/index.ts';
import { floor_div } from '../core/validation/integer.ts';
import * as CoreContract from '../generated/contract/core_contract.ts';
import * as GameContract from '../generated/contract/game_contract.ts';
import * as CoreCheatContract from '../dev/generated/contract/core_cheat_contract.ts';
import { gold_reward } from '../common/run_reward.ts';

const LOADED = Testing.load_data();
const DATA = LOADED.data;
const SETTING = DATA.GameSetting;
const MODE = DATA.ReservedId.run_mode();
const GOLD = DATA.ReservedId.gold();
const DURATION = SETTING.run_duration();
const SLACK = SETTING.run_time_slack();
const MIGHT = LOADED.dev.find_id_value('[upgrade_might]');
const GREED = LOADED.dev.find_id_value('[upgrade_greed]');
const OPS = { floor_div };

function code(envelope: CoreContract.ResponseEnvelope): number {
  return envelope.error?.code ?? 0;
}

interface ResultInput {
  survived_ms: bigint;
  kills: number;
  level?: number;
  dawn?: boolean;
}

function result(input: ResultInput): Uint8Array {
  const out = new GameContract.PlaySessionResult();
  out.survived_ms = input.survived_ms;
  out.kills = input.kills;
  out.level = input.level ?? 5;
  out.dawn = input.dawn ?? false;
  return out.encode();
}

/** Gold of a run with the coefficients of the data, the expected value of `apply_play_session`. */
function expected_gold(survived_ms: bigint, kills: number, dawn: boolean, greed_permille: number): bigint {
  return gold_reward(OPS, {
    survived_ms,
    kills,
    dawn,
    greed_permille,
    interval_ms: SETTING.gold_interval(),
    per_interval: SETTING.gold_per_interval(),
    per_kill_permille: SETTING.gold_per_kill_permille(),
    dawn_bonus: SETTING.dawn_bonus(),
  });
}

function start(session: Testing.TestSession, level_id = 0): Promise<Testing.SendResult> {
  const request = new CoreContract.StartPlaySessionRequest();
  request.mode_id = MODE;
  request.level_id = level_id;
  return Testing.send(session, 'core/StartPlaySession', request);
}

function finish(session: Testing.TestSession, play_session_id: string, bytes: Uint8Array, request_id?: string): Promise<Testing.SendResult> {
  const request = new CoreContract.FinishPlaySessionRequest();
  request.play_session_id = play_session_id;
  request.result = bytes;
  return Testing.send(session, 'core/FinishPlaySession', request, request_id);
}

function loadout_of(sent: Testing.SendResult): GameContract.PlaySessionLoadout {
  const loadout = GameContract.PlaySessionLoadout.decode((sent.response as CoreContract.StartPlaySessionResponse).loadout);
  if (loadout === null) throw new Error('the loadout does not decode');
  return loadout;
}

async function set_balance(session: Testing.TestSession, item_id: number, balance: bigint): Promise<void> {
  const request = new CoreCheatContract.SetItemBalanceRequest();
  request.item_id = item_id;
  request.balance = balance;
  expect(code((await Testing.send_cheat(session, 'core/cheat/SetItemBalance', request)).envelope)).toBe(0);
}

async function balance(server: Testing.TestServer, user_id: bigint, item_id: number): Promise<bigint> {
  const item = (await Testing.read_user_state(server, user_id)).find((entry) => entry.kind === 'ItemBalanceUserState' && entry.item_id === BigInt(item_id));
  return item === undefined ? 0n : (item.value as CoreContract.ItemBalanceUserState).amount;
}

async function run_record(server: Testing.TestServer, user_id: bigint): Promise<GameContract.RunRecordUserState | null> {
  const item = (await Testing.read_user_state(server, user_id)).find((entry) => entry.kind === 'RunRecordUserState');
  return item === undefined ? null : (item.value as GameContract.RunRecordUserState);
}

describe('run gold shared formula', () => {
  it('matches every case of the shared fixture', () => {
    const fixture = JSON.parse(new TextDecoder().decode(Testing.read_shared_fixture('run.gold_reward'))) as {
      cases: {
        name: string;
        input: { survived_ms: number; kills: number; dawn: boolean; greed_permille: number; interval_ms: number; per_interval: number; per_kill_permille: number; dawn_bonus: number };
        expected: number;
      }[];
    };
    expect(fixture.cases.length).toBeGreaterThan(0);
    for (const entry of fixture.cases) {
      const input = entry.input;
      const gold = gold_reward(OPS, {
        survived_ms: BigInt(input.survived_ms),
        kills: input.kills,
        dawn: input.dawn,
        greed_permille: input.greed_permille,
        interval_ms: BigInt(input.interval_ms),
        per_interval: input.per_interval,
        per_kill_permille: input.per_kill_permille,
        dawn_bonus: input.dawn_bonus,
      });
      expect(gold).toBe(BigInt(entry.expected));
    }
  });
});

describe('run play session', () => {
  let server: Testing.TestServer;
  let accounts = 0;

  beforeEach(async () => {
    server = await Testing.start_test_server();
  });

  afterEach(async () => {
    await Testing.stop_test_server(server);
  });

  async function player(): Promise<Testing.TestSession> {
    accounts += 1;
    return Testing.login(server, `run_${String(accounts)}`);
  }

  /** Starts a run, lets `elapsed` pass on the server and finishes it with `bytes`. */
  async function played(session: Testing.TestSession, elapsed: bigint, bytes: Uint8Array, request_id?: string): Promise<Testing.SendResult> {
    const started = await start(session);
    expect(code(started.envelope)).toBe(0);
    Testing.advance_time(server, elapsed);
    return finish(session, (started.response as CoreContract.StartPlaySessionResponse).play_session_id, bytes, request_id);
  }

  it('starts a run of a new user with a seed and no upgrade', async () => {
    const session = await player();
    const sent = await start(session);
    expect(code(sent.envelope)).toBe(0);
    const loadout = loadout_of(sent);
    expect(loadout.upgrade_ids).toEqual([]);
    expect(loadout.upgrade_levels).toEqual([]);
    expect(await run_record(server, session.user_id)).toBeNull();
  });

  it('puts the bought upgrade levels in the loadout', async () => {
    const session = await player();
    await set_balance(session, MIGHT, 2n);
    await set_balance(session, GREED, 1n);
    const loadout = loadout_of(await start(session));
    const levels = new Map<number, number>();
    loadout.upgrade_ids.forEach((id, index) => levels.set(id, loadout.upgrade_levels[index] ?? 0));
    expect(levels.get(MIGHT)).toBe(2);
    expect(levels.get(GREED)).toBe(1);
    expect(loadout.upgrade_ids.length).toBe(2);
  });

  it('refuses a run with a level target', async () => {
    const session = await player();
    const sent = await start(session, 3);
    expect(code(sent.envelope)).toBe(GameContract.GameError.GAME_ERROR_LEVEL_NOT_FOUND);
    const finished = await finish(session, randomUUID(), result({ survived_ms: 0n, kills: 0 }));
    expect(code(finished.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_NOT_FOUND);
  });

  it('grants the run gold and counts the run', async () => {
    const session = await player();
    const survived = 180000n;
    const sent = await played(session, survived, result({ survived_ms: survived, kills: 207, level: 9 }));
    expect(code(sent.envelope)).toBe(0);
    const gold = expected_gold(survived, 207, false, 0);
    expect(gold).toBeGreaterThan(0n);
    expect(await balance(server, session.user_id, GOLD)).toBe(gold);
    const change = sent.envelope.item_changes.find((entry) => entry.item_id === GOLD);
    expect(change?.delta).toBe(gold);
    expect(change?.source).toBe(CoreContract.ItemChangeSource.ITEM_CHANGE_SOURCE_PLAY_SESSION);
    const record = await run_record(server, session.user_id);
    expect(record?.runs).toBe(1);
    expect(record?.dawns).toBe(0);
    expect(record?.best_survived_ms).toBe(survived);
    expect(record?.best_kills).toBe(207);
    expect(record?.total_kills).toBe(207n);
  });

  it('keeps the best values and adds the kills of later runs', async () => {
    const session = await player();
    await played(session, 200000n, result({ survived_ms: 200000n, kills: 300 }));
    await played(session, 100000n, result({ survived_ms: 100000n, kills: 120 }));
    const record = await run_record(server, session.user_id);
    expect(record?.runs).toBe(2);
    expect(record?.best_survived_ms).toBe(200000n);
    expect(record?.best_kills).toBe(300);
    expect(record?.total_kills).toBe(420n);
    expect(await balance(server, session.user_id, GOLD)).toBe(expected_gold(200000n, 300, false, 0) + expected_gold(100000n, 120, false, 0));
  });

  it('raises the gold with the greed upgrade of the loadout', async () => {
    const session = await player();
    await set_balance(session, GREED, 2n);
    const greed = DATA.UpgradeTable.get_row(GREED).per_level * 2;
    const survived = 300000n;
    expect(code((await played(session, survived, result({ survived_ms: survived, kills: 500 }))).envelope)).toBe(0);
    expect(await balance(server, session.user_id, GOLD)).toBe(expected_gold(survived, 500, false, greed));
    expect(expected_gold(survived, 500, false, greed)).toBeGreaterThan(expected_gold(survived, 500, false, 0));
  });

  it('counts a dawn run with the dawn bonus', async () => {
    const session = await player();
    const sent = await played(session, DURATION, result({ survived_ms: DURATION, kills: 3000, level: 40, dawn: true }));
    expect(code(sent.envelope)).toBe(0);
    expect(await balance(server, session.user_id, GOLD)).toBe(expected_gold(DURATION, 3000, true, 0));
    expect((await run_record(server, session.user_id))?.dawns).toBe(1);
  });

  it('applies a resent finish once', async () => {
    const session = await player();
    const request_id = randomUUID();
    const started = await start(session);
    Testing.advance_time(server, 60000n);
    const id = (started.response as CoreContract.StartPlaySessionResponse).play_session_id;
    const bytes = result({ survived_ms: 60000n, kills: 80 });
    expect(code((await finish(session, id, bytes, request_id)).envelope)).toBe(0);
    expect(code((await finish(session, id, bytes, request_id)).envelope)).toBe(0);
    expect(await balance(server, session.user_id, GOLD)).toBe(expected_gold(60000n, 80, false, 0));
    expect((await run_record(server, session.user_id))?.runs).toBe(1);
  });

  const rejected: [string, bigint, ResultInput][] = [
    ['a survived time longer than the play session and the slack', 60000n, { survived_ms: 60000n + SLACK + 1n, kills: 10 }],
    ['a survived time longer than the run', DURATION + SLACK, { survived_ms: DURATION + 1n, kills: 10 }],
    ['dawn before the run end', 600000n, { survived_ms: 600000n, kills: 10, dawn: true }],
    ['the run end without dawn', DURATION, { survived_ms: DURATION, kills: 10, dawn: false }],
    ['more kills than the per-minute bound', 60000n, { survived_ms: 60000n, kills: SETTING.max_kills_per_minute() + 1 }],
    ['a level above the bound', 60000n, { survived_ms: 60000n, kills: 10, level: SETTING.max_level() + 1 }],
  ];
  for (const [name, elapsed, input] of rejected) {
    it(`rejects ${name} and changes nothing`, async () => {
      const session = await player();
      const sent = await played(session, elapsed, result(input));
      expect(code(sent.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_REJECTED);
      expect(await balance(server, session.user_id, GOLD)).toBe(0n);
      expect(await run_record(server, session.user_id)).toBeNull();
    });
  }

  it('accepts a survived time within the slack of the play session time', async () => {
    const session = await player();
    const sent = await played(session, 60000n, result({ survived_ms: 60000n + SLACK, kills: 10 }));
    expect(code(sent.envelope)).toBe(0);
  });

  it('rejects a result that breaks the PlaySessionResult declaration without a change', async () => {
    const session = await player();
    const sent = await played(session, 60000n, result({ survived_ms: 60000n, kills: 10, level: 0 }));
    expect(code(sent.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_INVALID_REQUEST);
    expect(await run_record(server, session.user_id)).toBeNull();
  });
});
