class_name LobbyPanel
extends UIPanel
## Root panel of the camp: the top band with the game name, the gold and the option button; the record card on the
## left; the hero by the fire; the shrine and start buttons with the run goal on the right. The start button is the
## first focus, so one confirm input starts a run. When the gold covers shrine upgrades, a badge on the shrine button
## holds their count and a line under it says so.

@export var title_label: Label
@export var gold_label: Label
@export var gold_icon: TextureRect
@export var record_title_label: Label
@export var no_record_label: Label
@export var stats_box: Control
## Record rows in the order best time, best kills, runs, dawns.
@export var stat_icons: Array[TextureRect] = []
@export var stat_names: Array[Label] = []
@export var stat_values: Array[Label] = []
@export var hero_rect: TextureRect
@export var emblem_rect: TextureRect
@export var record_card: Control
@export var actions: Control
@export var upgrade_ready_label: Label
@export var badge: Control
@export var badge_label: Label
@export var goal_label: Label
@export var option_label: Label
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
	LocalizationCore.bind_text(option_label, ReservedString.lobby_options())
	LocalizationCore.bind_text(upgrade_ready_label, ReservedString.lobby_upgrade_ready())
	LocalizationCore.bind_text(record_title_label, ReservedString.lobby_record_title())
	var names: PackedStringArray = PackedStringArray([ReservedString.lobby_stat_best_time(),
			ReservedString.lobby_stat_best_kills(), ReservedString.lobby_stat_runs(), ReservedString.lobby_stat_dawns()])
	var icons: PackedStringArray = PackedStringArray([ResourceKey.ICON__TIMER, ResourceKey.ICON__KILLS,
			ResourceKey.ICON__UI_RUNS, ResourceKey.ICON__UI_DAWN])
	for i: int in stat_names.size():
		LocalizationCore.bind_text(stat_names[i], names[i])
		stat_icons[i].texture = _texture(icons[i])
	_format_args.clear()
	_format_args.set_int("time", GameSetting.run_duration())
	goal_label.text = LocalizationCore.format(ReservedString.lobby_goal(), _format_args)
	play_click.set_on_click(_on_play)
	upgrade_click.set_on_click(_on_upgrades)
	option_click.set_on_click(_on_option)
	gold_icon.texture = _texture(ResourceKey.ICON__GOLD)
	upgrade_button.icon = _texture(ResourceKey.ICON__UI_SHRINE)
	option_button.icon = _texture(ResourceKey.ICON__UI_OPTIONS)
	hero_rect.texture = _texture(ResourceKey.IMAGE__LOBBY__HERO)
	emblem_rect.texture = _texture(ResourceKey.IMAGE__UI__LOGO_EMBLEM)
	EventCore.subscribe(UserStateChangedEvent, _on_user_state_changed)
	_write()
	return true


func on_opened(_reason: UICore.PanelOpenReason) -> void:
	play_button.pivot_offset = play_button.size * 0.5
	TweenCore.play_preset(ResourceKey.TWEEN__LOBBY__PLAY_PULSE, scope, play_button)
	for part: Control in [record_card, actions, hero_rect]:
		part.pivot_offset = part.size * 0.5
		TweenCore.play_preset(ResourceKey.TWEEN__LOBBY__PANEL_IN, scope, part)


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
	var affordable: int = CommonUpgrades.affordable_count()
	upgrade_ready_label.visible = affordable > 0
	badge.visible = affordable > 0
	_format_args.clear()
	_format_args.set_int("count", affordable)
	badge_label.text = LocalizationCore.format(ReservedString.lobby_badge(), _format_args)
	var runs: int = CommonRunRecord.runs()
	no_record_label.visible = runs == 0
	no_record_label.text = CommonWordWrap.keep_words(LocalizationCore.get_text(ReservedString.lobby_no_record()))
	stats_box.visible = runs > 0
	if runs == 0:
		return
	var formats: PackedStringArray = PackedStringArray([ReservedString.lobby_value_time(),
			ReservedString.lobby_value_count(), ReservedString.lobby_value_times(), ReservedString.lobby_value_times()])
	var args: PackedStringArray = PackedStringArray(["time", "count", "count", "count"])
	var values: PackedInt64Array = PackedInt64Array([CommonRunRecord.best_survived_ms(), CommonRunRecord.best_kills(), runs,
			CommonRunRecord.dawns()])
	for i: int in stat_values.size():
		_format_args.clear()
		_format_args.set_int(args[i], values[i])
		stat_values[i].text = LocalizationCore.format(formats[i], _format_args)


func _texture(key: String) -> Texture2D:
	if not ResourceCore.is_loaded(key, ResourceCore.BaseKind.TEXTURE_2D):
		return null
	return ResourceCore.get_loaded(key, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
