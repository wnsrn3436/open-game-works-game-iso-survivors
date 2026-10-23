class_name RunGold
extends RefCounted
## The gold of a run: the same formula the server grants with in `apply_play_session`. The HUD shows the gold of the
## run so far with it; the result panel shows the gold the server granted.


## Gold of one run: `per_interval` per full `interval_ms` survived, plus kills × `per_kill_permille` ÷ 1000, plus
## `dawn_bonus` at dawn, the sum raised by `greed_permille`. Every division rounds down.
# ogw:shared run.gold_reward
static func gold_reward(survived_ms: int, kills: int, dawn: bool, greed_permille: int, interval_ms: int,
		per_interval: int, per_kill_permille: int, dawn_bonus: int) -> int:
	var time_gold: int = UtilCore.floor_div(survived_ms, interval_ms) * per_interval
	var kill_gold: int = UtilCore.floor_div(kills * per_kill_permille, RunConstants.PERMILLE)
	var base: int = time_gold + kill_gold + (dawn_bonus if dawn else 0)
	return UtilCore.floor_div(base * (RunConstants.PERMILLE + greed_permille), RunConstants.PERMILLE)


## Gold of a run with the `game_setting` coefficients.
static func of_run(survived_ms: int, kills: int, dawn: bool, greed_permille: int) -> int:
	return RunGold.gold_reward(survived_ms, kills, dawn, greed_permille, GameSetting.gold_interval(),
		GameSetting.gold_per_interval(), GameSetting.gold_per_kill_permille(), GameSetting.dawn_bonus())
