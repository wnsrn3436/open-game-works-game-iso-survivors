import { randomUUID } from 'node:crypto';
import * as Testing from '../core/testing/dev/index.ts';
import * as CoreContract from '../generated/contract/core_contract.ts';
import * as GameContract from '../generated/contract/game_contract.ts';
import * as CoreCheatContract from '../dev/generated/contract/core_cheat_contract.ts';

const LOADED = Testing.load_data();
const DATA = LOADED.data;
const GOLD = DATA.ReservedId.gold();
const MIGHT = LOADED.dev.find_id_value('[upgrade_might]');
const MIGHT_1 = LOADED.dev.find_id_value('[shop_might_1]');
const MIGHT_2 = LOADED.dev.find_id_value('[shop_might_2]');

function code(envelope: CoreContract.ResponseEnvelope): number {
  return envelope.error?.code ?? 0;
}

/** The gold cost of a shop product row. */
function cost(product_id: number): bigint {
  const entry = DATA.ShopProductTable.get_row(product_id).cost.find((item) => item.item_id === GOLD);
  if (entry === undefined) throw new Error(`product ${String(product_id)} has no gold cost`);
  return entry.amount;
}

function buy(session: Testing.TestSession, product_id: number, request_id?: string): Promise<Testing.SendResult> {
  const request = new CoreContract.BuyShopProductRequest();
  request.product_id = product_id;
  request.quantity = 1;
  request.accept_loss = false;
  return Testing.send(session, 'core/BuyShopProduct', request, request_id);
}

async function set_balance(session: Testing.TestSession, item_id: number, amount: bigint): Promise<void> {
  const request = new CoreCheatContract.SetItemBalanceRequest();
  request.item_id = item_id;
  request.balance = amount;
  expect(code((await Testing.send_cheat(session, 'core/cheat/SetItemBalance', request)).envelope)).toBe(0);
}

async function balance(server: Testing.TestServer, user_id: bigint, item_id: number): Promise<bigint> {
  const item = (await Testing.read_user_state(server, user_id)).find((entry) => entry.kind === 'ItemBalanceUserState' && entry.item_id === BigInt(item_id));
  return item === undefined ? 0n : (item.value as CoreContract.ItemBalanceUserState).amount;
}

describe('lantern shrine upgrades', () => {
  let server: Testing.TestServer;
  let accounts = 0;

  beforeEach(async () => {
    server = await Testing.start_test_server();
  });

  afterEach(async () => {
    await Testing.stop_test_server(server);
  });

  async function player(gold: bigint): Promise<Testing.TestSession> {
    accounts += 1;
    const session = await Testing.login(server, `shrine_${String(accounts)}`);
    await set_balance(session, GOLD, gold);
    return session;
  }

  it('every upgrade has one step per level with rising costs', () => {
    for (const upgrade of DATA.UpgradeTable.all_rows()) {
      const steps = DATA.UpgradeStepTable.all_rows().filter((step) => step.upgrade === upgrade.id).sort((a, b) => a.level - b.level);
      expect(steps.length).toBe(Number(DATA.ItemTable.get_row(upgrade.id).max_amount));
      steps.forEach((step, index) => {
        expect(step.level).toBe(index + 1);
        if (index > 0) expect(cost(step.id)).toBeGreaterThan(cost(steps[index - 1]?.id ?? 0));
      });
    }
  });

  it('buys the first step with gold', async () => {
    const start = cost(MIGHT_1) + 5n;
    const session = await player(start);
    const sent = await buy(session, MIGHT_1);
    expect(code(sent.envelope)).toBe(0);
    expect(await balance(server, session.user_id, MIGHT)).toBe(1n);
    expect(await balance(server, session.user_id, GOLD)).toBe(5n);
    const reward = sent.envelope.item_changes.find((entry) => entry.item_id === MIGHT);
    expect(reward?.delta).toBe(1n);
    expect(reward?.source).toBe(CoreContract.ItemChangeSource.ITEM_CHANGE_SOURCE_SHOP);
  });

  it('buys the second step after the first', async () => {
    const session = await player(cost(MIGHT_1) + cost(MIGHT_2));
    expect(code((await buy(session, MIGHT_1)).envelope)).toBe(0);
    expect(code((await buy(session, MIGHT_2)).envelope)).toBe(0);
    expect(await balance(server, session.user_id, MIGHT)).toBe(2n);
    expect(await balance(server, session.user_id, GOLD)).toBe(0n);
  });

  it('refuses a step before the earlier step and changes nothing', async () => {
    const gold = cost(MIGHT_2) * 2n;
    const session = await player(gold);
    const sent = await buy(session, MIGHT_2);
    expect(code(sent.envelope)).toBe(GameContract.GameError.GAME_ERROR_UPGRADE_ORDER);
    expect(await balance(server, session.user_id, MIGHT)).toBe(0n);
    expect(await balance(server, session.user_id, GOLD)).toBe(gold);
  });

  it('refuses a step the user already passed and changes nothing', async () => {
    const session = await player(cost(MIGHT_2) * 3n);
    await set_balance(session, MIGHT, 2n);
    const sent = await buy(session, MIGHT_2);
    expect(code(sent.envelope)).toBe(GameContract.GameError.GAME_ERROR_UPGRADE_ORDER);
    expect(await balance(server, session.user_id, MIGHT)).toBe(2n);
    expect(await balance(server, session.user_id, GOLD)).toBe(cost(MIGHT_2) * 3n);
  });

  it('refuses a step without enough gold and changes nothing', async () => {
    const gold = cost(MIGHT_1) - 1n;
    const session = await player(gold);
    const sent = await buy(session, MIGHT_1);
    expect(code(sent.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_ITEM_NOT_ENOUGH);
    expect(await balance(server, session.user_id, MIGHT)).toBe(0n);
    expect(await balance(server, session.user_id, GOLD)).toBe(gold);
  });

  it('refuses buying the same step twice', async () => {
    const session = await player(cost(MIGHT_1) * 2n);
    expect(code((await buy(session, MIGHT_1)).envelope)).toBe(0);
    const again = await buy(session, MIGHT_1);
    expect(code(again.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_SHOP_LIMIT_REACHED);
    expect(await balance(server, session.user_id, MIGHT)).toBe(1n);
    expect(await balance(server, session.user_id, GOLD)).toBe(cost(MIGHT_1));
  });

  it('applies a resent purchase once', async () => {
    const session = await player(cost(MIGHT_1) * 2n);
    const request_id = randomUUID();
    expect(code((await buy(session, MIGHT_1, request_id)).envelope)).toBe(0);
    expect(code((await buy(session, MIGHT_1, request_id)).envelope)).toBe(0);
    expect(await balance(server, session.user_id, MIGHT)).toBe(1n);
    expect(await balance(server, session.user_id, GOLD)).toBe(cost(MIGHT_1));
  });
});
