class_name LobbyUpgradeEntry
extends Control
## One row of the lantern shrine: the icon, name, level, effect and the cost of the next level with its buy button.

@export var icon_rect: TextureRect
@export var name_label: Label
@export var level_label: Label
@export var desc_label: Label
@export var cost_label: Label
@export var cost_icon: TextureRect
@export var short_label: Label
@export var buy_button: Button
@export var click: UIButton
@export var anchor: UIAnchor

## The `upgrade` ID value the row shows; 0 before `show_upgrade`.
var upgrade_id: int = 0
var _format_args: FormatArgs = FormatArgs.new()


## Draws `row` with the user's level. `texture` is its icon and `gold` the gold icon.
func show_upgrade(row: GameData.UpgradeRow, texture: Texture2D, gold: Texture2D) -> void:
	upgrade_id = row.id
	anchor.set_anchor_key(row.id)
	icon_rect.texture = texture
	cost_icon.texture = gold
	name_label.text = LocalizationCore.get_text(GameData.ItemTable.get_row(row.id).name)
	_format_args.clear()
	_format_args.set_int("value", CommonStatText.shown_value(row.stat, row.per_level))
	desc_label.text = LocalizationCore.format(row.desc, _format_args)
	refresh()


## Redraws the level, the cost and the buy button from the cache.
func refresh() -> void:
	var level: int = CommonUpgrades.level(upgrade_id)
	var top: int = CommonUpgrades.max_level(upgrade_id)
	_format_args.clear()
	_format_args.set_int("level", level)
	_format_args.set_int("max", top)
	level_label.text = LocalizationCore.format(ReservedString.upgrade_level(), _format_args)
	var step: GameData.UpgradeStepRow = CommonUpgrades.next_step(upgrade_id)
	var maxed: bool = step.id == 0
	cost_label.visible = not maxed
	cost_icon.visible = not maxed
	short_label.visible = false
	if maxed:
		LocalizationCore.bind_text(buy_button, ReservedString.upgrade_maxed())
		buy_button.disabled = true
		return
	LocalizationCore.bind_text(buy_button, ReservedString.upgrade_buy())
	buy_button.disabled = false
	_format_args.clear()
	_format_args.set_int("cost", CommonUpgrades.cost(step.id))
	cost_label.text = LocalizationCore.format(ReservedString.upgrade_cost(), _format_args)
	var affordable: bool = CommonUpgrades.can_buy(step)
	cost_label.modulate = LobbyConstants.AFFORDABLE_COLOR if affordable else LobbyConstants.SHORT_COLOR
	short_label.visible = not affordable
	LocalizationCore.bind_text(short_label, ReservedString.upgrade_not_enough())
