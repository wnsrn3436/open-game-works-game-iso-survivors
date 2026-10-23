class_name RunResultPanel
extends UIPanel
## Result panel of a finished run: dawn, give-up or fall, the time survived, kills, the level reached, the gold the server
## granted (or that the run was not counted), a new best and the shrine hint. "Run again" has the first focus and starts
## the next run; "To camp" and a back input go to the camp. A second press of either button is ignored.

@export var title_label: Label
@export var time_label: Label
@export var kills_label: Label
@export var level_label: Label
@export var gold_label: Label
@export var best_label: Label
@export var hint_label: Label
@export var gold_icon: TextureRect
@export var again_button: Button
@export var lobby_button: Button
@export var again_click: UIButton
@export var lobby_click: UIButton

var _param: RunResultParam = null
var _format_args: FormatArgs = FormatArgs.new()
var _leaving: bool = false


func accepts_param(param: UIParam) -> bool:
	return param is RunResultParam


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	_param = panel_param as RunResultParam
	LocalizationCore.bind_text(title_label, RunResultPanel.title_key(_param))
	LocalizationCore.bind_text(again_button, ReservedString.result_again())
	LocalizationCore.bind_text(lobby_button, ReservedString.result_lobby())
	LocalizationCore.bind_text(best_label, ReservedString.result_new_best())
	LocalizationCore.bind_text(hint_label, ReservedString.result_upgrade_hint())
	again_click.set_on_click(_on_again)
	lobby_click.set_on_click(_on_lobby)
	if ResourceCore.is_loaded(ResourceKey.ICON__GOLD, ResourceCore.BaseKind.TEXTURE_2D):
		gold_icon.texture = ResourceCore.get_loaded(ResourceKey.ICON__GOLD, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	_format_args.clear()
	_format_args.set_int("time", _param.survived_ms)
	time_label.text = LocalizationCore.format(ReservedString.result_time(), _format_args)
	_format_args.clear()
	_format_args.set_int("kills", _param.kills)
	kills_label.text = LocalizationCore.format(ReservedString.result_kills(), _format_args)
	_format_args.clear()
	_format_args.set_int("level", _param.level)
	level_label.text = LocalizationCore.format(ReservedString.result_level(), _format_args)
	if _param.saved:
		_format_args.clear()
		_format_args.set_int("gold", _param.gold)
		gold_label.text = LocalizationCore.format(ReservedString.result_gold(), _format_args)
	else:
		gold_label.text = LocalizationCore.get_text(ReservedString.result_unsaved())
	gold_icon.visible = _param.saved
	best_label.visible = _param.new_best
	hint_label.visible = _param.saved and CommonUpgrades.any_affordable()
	return true


## Translation key of the title: dawn, a give-up or a fall.
static func title_key(param: RunResultParam) -> String:
	if param.dawn:
		return ReservedString.result_dawn()
	if param.gave_up:
		return ReservedString.result_gave_up()
	return ReservedString.result_fallen()


func on_opened(_reason: UICore.PanelOpenReason) -> void:
	title_label.pivot_offset = title_label.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__RUN__RESULT_IN, scope, title_label)


func on_back() -> void:
	_on_lobby()


func _on_again() -> void:
	if _leaving:
		return
	_leaving = true
	_param.on_again.call()


func _on_lobby() -> void:
	if _leaving:
		return
	_leaving = true
	_param.on_lobby.call()
