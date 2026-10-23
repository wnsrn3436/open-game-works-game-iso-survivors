class_name CommonUpgrades
extends RefCounted
## The permanent upgrades of the lantern shrine read from the `UserStateCore` cache: the gold balance, the level of
## each upgrade and the next step to buy. The shrine checks a purchase with these before it sends it, by the same
## rule the server checks (`validate_shop_purchase`).


static func gold() -> int:
	return UserStateCore.get_item_balance(ReservedId.gold())


static func level(upgrade_id: int) -> int:
	return UserStateCore.get_item_balance(upgrade_id)


static func max_level(upgrade_id: int) -> int:
	return GameData.ItemTable.get_row(upgrade_id).max_amount


## The upgrades in `upgrade.order`.
static func upgrades() -> Array[GameData.UpgradeRow]:
	var rows: Array[GameData.UpgradeRow] = []
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		rows.append(row)
	rows.sort_custom(func(a: GameData.UpgradeRow, b: GameData.UpgradeRow) -> bool: return a.order < b.order)
	return rows


## The `upgrade_step` row that buys the next level of `upgrade_id`; the empty row when the upgrade is at its top.
static func next_step(upgrade_id: int) -> GameData.UpgradeStepRow:
	var want: int = level(upgrade_id) + 1
	for row: GameData.UpgradeStepRow in GameData.UpgradeStepTable.all_rows():
		if row.upgrade == upgrade_id and row.level == want:
			return row
	return GameData.UpgradeStepTable.empty_row()


## Gold cost of the shop product `product_id`; 0 for a product without a gold cost.
static func cost(product_id: int) -> int:
	for item: CoreContract.ItemAmount in GameData.ShopProductTable.get_row(product_id).cost:
		if item.item_id == ReservedId.gold():
			return item.amount
	return 0


## Whether the step `step` can be bought now: it is the next level, it is not bought yet in its limit, and the gold
## covers it.
static func can_buy(step: GameData.UpgradeStepRow) -> bool:
	if step.id == 0 or level(step.upgrade) != step.level - 1:
		return false
	var product: GameData.ShopProductRow = GameData.ShopProductTable.get_row(step.id)
	if product.limit_count > 0 and UserStateCore.get_shop_purchase_count(step.id) >= product.limit_count:
		return false
	return gold() >= cost(step.id)


## Whether any upgrade has a next step the gold covers.
static func any_affordable() -> bool:
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		if can_buy(next_step(row.id)):
			return true
	return false


## The upgrade whose next level costs the least among those the gold covers; 0 when none.
static func cheapest_affordable() -> int:
	var best: int = 0
	var best_cost: int = -1
	for row: GameData.UpgradeRow in upgrades():
		var step: GameData.UpgradeStepRow = next_step(row.id)
		if not can_buy(step):
			continue
		var price: int = cost(step.id)
		if best_cost < 0 or price < best_cost:
			best_cost = price
			best = row.id
	return best


## The upgrade levels as a loadout-shaped pair, for the stats shown outside a run.
static func bonus(stat: GameData.RunStat) -> int:
	var total: int = 0
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		if row.stat == stat:
			total += row.per_level * level(row.id)
	return total
