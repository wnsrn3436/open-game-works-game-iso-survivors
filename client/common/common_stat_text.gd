class_name CommonStatText
extends RefCounted
## The value a `RunStat` effect text shows for a `per_level` value: percent for the permille stats, flat for health.


static func shown_value(stat: GameData.RunStat, per_level: int) -> int:
	if stat == GameData.RunStat.VITALITY:
		return per_level
	return UtilCore.floor_div(per_level, CommonConstants.PERMILLE_PER_PERCENT)
