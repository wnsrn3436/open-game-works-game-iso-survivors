import type { RequestCtx } from '../core/storage/index.ts';
import type * as GameContract from '../generated/contract/game_contract.ts';
import * as GameData from '../generated/data/game_data.ts';
import { PERMILLE } from './constants.ts';

/** The integer operations of `validation` the run formulas use. */
export interface IntegerOps {
  floor_div(a: bigint, b: bigint): bigint;
}

/** The inputs of the run gold formula: the run result, the greed bonus and the `game_setting` coefficients. */
export interface GoldRewardInput {
  readonly survived_ms: bigint;
  readonly kills: number;
  readonly dawn: boolean;
  readonly greed_permille: number;
  readonly interval_ms: bigint;
  readonly per_interval: number;
  readonly per_kill_permille: number;
  readonly dawn_bonus: number;
}

/**
 * Gold of one finished run: `[gold_per_interval]` per full `[gold_interval]` survived, plus kills ×
 * `[gold_per_kill_permille]` ÷ 1000, plus `[dawn_bonus]` at dawn, the sum raised by the greed permille. Every division
 * rounds down.
 */
// ogw:shared run.gold_reward
export function gold_reward(ops: IntegerOps, input: GoldRewardInput): bigint {
  const time_gold = ops.floor_div(input.survived_ms, input.interval_ms) * BigInt(input.per_interval);
  const kill_gold = ops.floor_div(BigInt(input.kills) * BigInt(input.per_kill_permille), PERMILLE);
  const base = time_gold + kill_gold + (input.dawn ? BigInt(input.dawn_bonus) : 0n);
  return ops.floor_div(base * (PERMILLE + BigInt(input.greed_permille)), PERMILLE);
}

/** The bonus of `stat` the loadout upgrades give: level × `per_level` summed over the upgrades of that stat. */
export function loadout_bonus(data: GameData.DataSet, loadout: GameContract.PlaySessionLoadout, stat: GameData.RunStat): number {
  let total = 0;
  const count = Math.min(loadout.upgrade_ids.length, loadout.upgrade_levels.length);
  for (let i = 0; i < count; i += 1) {
    const id = loadout.upgrade_ids[i] ?? 0;
    if (!data.UpgradeTable.has_row(id)) continue;
    const row = data.UpgradeTable.get_row(id);
    if (row.stat === stat) total += row.per_level * (loadout.upgrade_levels[i] ?? 0);
  }
  return total;
}

/** The gold of `result` for the run of `loadout`, with the coefficients of the server data. */
export function run_gold(ops: IntegerOps, ctx: RequestCtx, loadout: GameContract.PlaySessionLoadout, result: GameContract.PlaySessionResult): bigint {
  const setting = ctx.data.GameSetting;
  return gold_reward(ops, {
    survived_ms: result.survived_ms,
    kills: result.kills,
    dawn: result.dawn,
    greed_permille: loadout_bonus(ctx.data, loadout, GameData.RunStat.Greed),
    interval_ms: setting.gold_interval(),
    per_interval: setting.gold_per_interval(),
    per_kill_permille: setting.gold_per_kill_permille(),
    dawn_bonus: setting.dawn_bonus(),
  });
}
