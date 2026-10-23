class_name LobbyPanel
extends UIPanel
## Root panel of the camp: the game name, the gold, the run record, and the start, shrine and option buttons. The start
## button is the first focus, so one confirm input starts a run. When the gold covers a shrine upgrade, a line under
## the shrine button says so.

@export var title_label: Label
@export var gold_label: Label
@export var gold_icon: TextureRect
@export var record_label: Label
@export var detail_label: Label
@export var upgrade_ready_label: Label
@export var play_button: Button
@export var upgrade_button: Button
@export var option_button: Button
@export var play_click: UIButton
@export var upgrade_click: UIButton
@export var option_click: UIButton

var _format_args: FormatArgs = FormatArgs.new()
var _starting: bool = false


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(title_label, ReservedString.title_name())
	LocalizationCore.bind_text(play_button, ReservedString.lobby_play())
	LocalizationCore.bind_text(upgrade_button, ReservedString.lobby_upgrades())
	LocalizationCore.bind_text(option_button, ReservedString.lobby_options())
	LocalizationCore.bind_text(upgrade_ready_label, ReservedString.lobby_upgrade_ready())
	play_click.set_on_click(_on_play)
	upgrade_click.set_on_click(_on_upgrades)
	option_click.set_on_click(_on_option)
	if ResourceCore.is_loaded(ResourceKey.ICON__GOLD, ResourceCore.BaseKind.TEXTURE_2D):
		gold_icon.texture = ResourceCore.get_loaded(ResourceKey.ICON__GOLD, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	EventCore.subscribe(UserStateChangedEvent, _on_user_state_changed)
	_write()
	return true


func on_opened(_reason: UICore.PanelOpenReason) -> void:
	play_button.pivot_offset = play_button.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__LOBBY__PLAY_PULSE, scope, play_button)


func _exit_tree() -> void:
	EventCore.unsubscribe_all(self)


func _on_play() -> void:
	if _starting:
		return
	_starting = true
	SceneCore.change_scene(ResourceKey.SCENE__RUN__RUN, null)


func _on_upgrades() -> void:
	UICore.open_panel(ResourceKey.PREFAB__LOBBY__UPGRADE_PANEL, null, false)


func _on_option() -> void:
	UICore.open_panel(ResourceKey.PREFAB__LOBBY__OPTION_PANEL, null, false)


func _on_user_state_changed(_event: UserStateChangedEvent) -> void:
	_write()


func _write() -> void:
	_format_args.clear()
	_format_args.set_int("gold", CommonUpgrades.gold())
	gold_label.text = LocalizationCore.format(ReservedString.lobby_gold(), _format_args)
	upgrade_ready_label.visible = CommonUpgrades.any_affordable()
	var runs: int = CommonRunRecord.runs()
	detail_label.visible = runs > 0
	if runs == 0:
		record_label.text = LocalizationCore.get_text(ReservedString.lobby_no_record())
		return
	_format_args.clear()
	_format_args.set_int("time", CommonRunRecord.best_survived_ms())
	_format_args.set_int("kills", CommonRunRecord.best_kills())
	record_label.text = LocalizationCore.format(ReservedString.lobby_best(), _format_args)
	_format_args.clear()
	_format_args.set_int("runs", runs)
	_format_args.set_int("dawns", CommonRunRecord.dawns())
	detail_label.text = LocalizationCore.format(ReservedString.lobby_runs(), _format_args)
