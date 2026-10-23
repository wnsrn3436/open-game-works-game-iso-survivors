import type { ItemLedgerContent } from '../core/item-ledger/index.ts';
import type { ApplyHook, PlaySessionRecord, PrepareHook, VerifyHook } from '../core/play-session/index.ts';
import type { RequestCtx, StorageContent } from '../core/storage/index.ts';
import * as CoreContract from '../generated/contract/core_contract.ts';
import * as GameContract from '../generated/contract/game_contract.ts';
import { MS_PER_MINUTE } from '../common/constants.ts';
import { run_gold, type IntegerOps } from '../common/run_reward.ts';

/**
 * `prepare_play_session`: one run. `level_id` must be 0. The loadout holds the simulation seed and the level of each
 * permanent upgrade the user has bought, in `upgrade` table order.
 */
export function prepare_run(storage: StorageContent, items: ItemLedgerContent): PrepareHook {
  return (ctx: RequestCtx, _mode_id: number, level_id: number) => {
    if (level_id !== 0) return GameContract.GameError.GAME_ERROR_LEVEL_NOT_FOUND;
    const loadout = new GameContract.PlaySessionLoadout();
    loadout.seed = BigInt(storage.random_u32(ctx));
    for (const row of ctx.data.UpgradeTable.all_rows()) {
      const level = items.get_balance(ctx, row.id);
      if (level <= 0n) continue;
      loadout.upgrade_ids.push(row.id);
      loadout.upgrade_levels.push(Number(level));
    }
    return loadout.encode();
  };
}

/**
 * `verify_play_session`: the result fits the run. The survived time is at most `[run_duration]` and at most the play
 * session time plus `[run_time_slack]`; dawn is reported exactly when the survived time is `[run_duration]`; kills are at
 * most `[max_kills_per_minute]` per minute survived; the level is at most `[max_level]`. The run is not simulated again.
 */
export function verify_run(ops: IntegerOps): VerifyHook {
  return (ctx: RequestCtx, record: PlaySessionRecord, result: Uint8Array) => {
    const decoded = GameContract.PlaySessionResult.decode(result);
    if (decoded === null || record.level_id !== 0) return 'reject';
    return time_fits(ctx, record, decoded) && counts_fit(ops, ctx, decoded) ? 'pass' : 'reject';
  };
}

/** The survived time fits the run, the play session time with the slack, and the dawn flag. */
function time_fits(ctx: RequestCtx, record: PlaySessionRecord, decoded: GameContract.PlaySessionResult): boolean {
  const setting = ctx.data.GameSetting;
  const duration = setting.run_duration();
  if (decoded.survived_ms > duration) return false;
  if (decoded.survived_ms > record.finished_at - record.started_at + setting.run_time_slack()) return false;
  return decoded.dawn === (decoded.survived_ms === duration);
}

/** The kills fit the per-minute bound of the survived time and the level fits its bound. */
function counts_fit(ops: IntegerOps, ctx: RequestCtx, decoded: GameContract.PlaySessionResult): boolean {
  const setting = ctx.data.GameSetting;
  const kill_limit = ops.floor_div(decoded.survived_ms * BigInt(setting.max_kills_per_minute()), MS_PER_MINUTE);
  return BigInt(decoded.kills) <= kill_limit && decoded.level <= setting.max_level();
}

function record_of(storage: StorageContent, ctx: RequestCtx): GameContract.RunRecordUserState | null {
  return storage.get_state(ctx, GameContract.RunRecordUserState, 0n) as GameContract.RunRecordUserState | null;
}

/**
 * `apply_play_session`: grants the run gold of `run.gold_reward` with the greed bonus of the loadout and counts the run in
 * `RunRecordUserState`. `FinishPlaySession` runs this once per play session.
 */
export function apply_run(storage: StorageContent, items: ItemLedgerContent, ops: IntegerOps): ApplyHook {
  return (ctx: RequestCtx, record: PlaySessionRecord, result: Uint8Array) => {
    const decoded = GameContract.PlaySessionResult.decode(result);
    const loadout = GameContract.PlaySessionLoadout.decode(record.loadout);
    if (decoded === null || loadout === null) return GameContract.GameError.GAME_ERROR_UNSPECIFIED;
    if (!grant_gold(items, ctx, run_gold(ops, ctx, loadout, decoded))) return GameContract.GameError.GAME_ERROR_UNSPECIFIED;
    storage.put_state(ctx, next_record(record_of(storage, ctx), decoded));
    return 'pass';
  };
}

/** Adds `gold` run gold; `true` when there is none to add or the ledger added it. */
function grant_gold(items: ItemLedgerContent, ctx: RequestCtx, gold: bigint): boolean {
  if (gold <= 0n) return true;
  const amount = new CoreContract.ItemAmount();
  amount.item_id = ctx.data.ReservedId.gold();
  amount.amount = gold;
  return items.add_items(ctx, [amount]) === 'OK';
}

/** The run record with the finished run `decoded` counted. */
function next_record(stored: GameContract.RunRecordUserState | null, decoded: GameContract.PlaySessionResult): GameContract.RunRecordUserState {
  const next = new GameContract.RunRecordUserState();
  next.runs = (stored?.runs ?? 0) + 1;
  next.dawns = (stored?.dawns ?? 0) + (decoded.dawn ? 1 : 0);
  const best_survived = stored?.best_survived_ms ?? 0n;
  next.best_survived_ms = decoded.survived_ms > best_survived ? decoded.survived_ms : best_survived;
  next.best_kills = Math.max(stored?.best_kills ?? 0, decoded.kills);
  next.total_kills = (stored?.total_kills ?? 0n) + BigInt(decoded.kills);
  return next;
}
