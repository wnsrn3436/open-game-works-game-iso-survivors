class_name LobbyUpgradeEntry
extends Control
## One row of the lantern shrine: the icon, name, level with one pip per level, effect, and the buy button that holds
## the gold icon and the cost of the next level. A button whose cost the gold does not cover is dimmed and the "not
## enough gold" line shows over it.

@export var icon_rect: TextureRect
@export var name_label: Label
@export var level_label: Label
@export var pips_box: HBoxContainer
@export var desc_label: Label
@export var short_label: Label
@export var buy_button: Button
@export var click: UIButton
@export var anchor: UIAnchor

## The `upgrade` ID value the row shows; 0 before `show_upgrade`.
var upgrade_id: int = 0
var _format_args: FormatArgs = FormatArgs.new()
var _gold: Texture2D = null
var _pip_on: Texture2D = null
var _pip_off: Texture2D = null
var _pips: Array[TextureRect] = []


## Draws `row` with the user's level. `texture` is its icon, `gold` the gold icon, `pip_on` and `pip_off` the filled and
## empty level pips.
func show_upgrade(row: GameData.UpgradeRow, texture: Texture2D, gold: Texture2D, pip_on: Texture2D,
		pip_off: Texture2D) -> void:
	upgrade_id = row.id
	anchor.set_anchor_key(row.id)
	icon_rect.texture = texture
	_gold = gold
	_pip_on = pip_on
	_pip_off = pip_off
	for i: int in CommonUpgrades.max_level(row.id) - _pips.size():
		var pip: TextureRect = TextureRect.new()
		pip.custom_minimum_size = LobbyConstants.PIP_SIZE
		pip.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pip.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pips_box.add_child(pip)
		_pips.append(pip)
	name_label.text = LocalizationCore.get_text(GameData.ItemTable.get_row(row.id).name)
	_format_args.clear()
	_format_args.set_int("value", CommonStatText.shown_value(row.stat, row.per_level))
	desc_label.text = CommonWordWrap.keep_words(LocalizationCore.format(row.desc, _format_args))
	refresh()


## Redraws the level, the cost and the buy button from the cache.
func refresh() -> void:
	var level: int = CommonUpgrades.level(upgrade_id)
	var top: int = CommonUpgrades.max_level(upgrade_id)
	_format_args.clear()
	_format_args.set_int("level", level)
	_format_args.set_int("max", top)
	level_label.text = LocalizationCore.format(ReservedString.upgrade_level(), _format_args)
	for i: int in _pips.size():
		_pips[i].texture = _pip_on if i < level else _pip_off
	var step: GameData.UpgradeStepRow = CommonUpgrades.next_step(upgrade_id)
	short_label.visible = false
	buy_button.modulate = Color.WHITE
	if step.id == 0:
		buy_button.icon = null
		LocalizationCore.bind_text(buy_button, ReservedString.upgrade_maxed())
		buy_button.disabled = true
		CommonButtonText.match_outline(buy_button)
		return
	buy_button.icon = _gold
	buy_button.disabled = false
	CommonButtonText.match_outline(buy_button)
	_format_args.clear()
	_format_args.set_int("cost", CommonUpgrades.cost(step.id))
	buy_button.text = LocalizationCore.format(ReservedString.upgrade_cost(), _format_args)
	var affordable: bool = CommonUpgrades.can_buy(step)
	buy_button.modulate = Color.WHITE if affordable else LobbyConstants.SHORT_TINT
	short_label.visible = not affordable
	LocalizationCore.bind_text(short_label, ReservedString.upgrade_not_enough())
