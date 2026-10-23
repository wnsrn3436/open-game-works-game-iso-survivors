class_name RunHudPanel
extends UIPanel
## Root panel of the run: the health bar and its numbers, the XP bar and the level, the run timer, kills, the run gold
## so far, the icons and levels of the owned weapons and passives, the move hint, the start status and the warning
## banner. It draws `RunStateChangedEvent` and `RunBannerEvent`. A back input or the `pause` action asks the run scene
## to pause; the UI keeps running while the run world is stopped, so a `pause` press there is not lost.

const _PAUSE: StringName = &"pause"

@export var hp_fill: Control
@export var hp_label: Label
@export var xp_fill: Control
@export var level_label: Label
@export var timer_label: Label
@export var kills_label: Label
@export var gold_label: Label
@export var gold_icon: TextureRect
@export var kills_icon: TextureRect
@export var timer_icon: TextureRect
@export var weapon_icons: Array[TextureRect] = []
@export var weapon_levels: Array[Label] = []
@export var passive_icons: Array[TextureRect] = []
@export var passive_levels: Array[Label] = []
@export var hint_label: Label
@export var status_label: Label
@export var banner_label: Label

var _format_args: FormatArgs = FormatArgs.new()
var _level: int = -1
var _kills: int = -1
var _gold: int = -1
var _seconds: int = -1
var _hp: int = -1
var _max_hp: int = -1


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(hint_label, ReservedString.run_hint_move())
	LocalizationCore.bind_text(status_label, ReservedString.run_starting())
	level_label.pivot_offset = level_label.size * 0.5
	kills_label.pivot_offset = kills_label.size * 0.5
	banner_label.pivot_offset = banner_label.size * 0.5
	hp_fill.self_modulate = RunConstants.HEALTH_COLOR
	xp_fill.self_modulate = RunConstants.XP_COLOR
	gold_icon.texture = _texture(ResourceKey.ICON__GOLD)
	kills_icon.texture = _texture(ResourceKey.ICON__KILLS)
	timer_icon.texture = _texture(ResourceKey.ICON__TIMER)
	EventCore.subscribe(RunStateChangedEvent, _on_state_changed)
	EventCore.subscribe(RunBannerEvent, _on_banner)
	EventCore.subscribe(InputPromptChangedEvent, _on_input_prompt_changed)
	banner_label.visible = false
	status_label.visible = true
	hint_label.visible = false
	_draw_slots(PackedInt32Array(), PackedInt32Array(), weapon_icons, weapon_levels, true)
	_draw_slots(PackedInt32Array(), PackedInt32Array(), passive_icons, passive_levels, false)
	return true


func on_back() -> void:
	EventCore.publish(EventCore.acquire(RunPauseRequestedEvent))


func _exit_tree() -> void:
	EventCore.unsubscribe_all(self)


func _process(_delta: float) -> void:
	if InputCore.is_just_pressed(_PAUSE):
		EventCore.publish(EventCore.acquire(RunPauseRequestedEvent))


func _on_state_changed(event: RunStateChangedEvent) -> void:
	status_label.visible = event.starting
	hint_label.visible = event.show_hint and not event.starting
	if event.starting:
		return
	if event.hp != _hp or event.max_hp != _max_hp:
		_hp = event.hp
		_max_hp = event.max_hp
		hp_fill.anchor_right = clampf(float(event.hp) / float(maxi(event.max_hp, 1)), 0.0, 1.0)
		_format_args.clear()
		_format_args.set_int("hp", event.hp)
		_format_args.set_int("max", event.max_hp)
		hp_label.text = LocalizationCore.format(ReservedString.run_hp(), _format_args)
	xp_fill.anchor_right = clampf(float(event.xp) / float(maxi(event.xp_next, 1)), 0.0, 1.0)
	if event.level != _level:
		var up: bool = _level >= 0
		_level = event.level
		_format_args.clear()
		_format_args.set_int("level", event.level)
		level_label.text = LocalizationCore.format(ReservedString.run_level(), _format_args)
		if up:
			TweenCore.play_preset(ResourceKey.TWEEN__RUN__HUD_POP, scope, level_label)
	if event.kills != _kills:
		_kills = event.kills
		_format_args.clear()
		_format_args.set_int("kills", event.kills)
		kills_label.text = LocalizationCore.format(ReservedString.run_kills(), _format_args)
	if event.gold != _gold:
		_gold = event.gold
		_format_args.clear()
		_format_args.set_int("gold", event.gold)
		gold_label.text = LocalizationCore.format(ReservedString.run_gold(), _format_args)
	_write_timer(event.time_ms)
	_draw_slots(event.weapon_ids, event.weapon_levels, weapon_icons, weapon_levels, true)
	_draw_slots(event.passive_ids, event.passive_levels, passive_icons, passive_levels, false)


func _write_timer(time_ms: int) -> void:
	var seconds: int = UtilCore.floor_div(time_ms, RunConstants.MS_PER_SECOND)
	if seconds == _seconds:
		return
	_seconds = seconds
	var minutes: int = UtilCore.floor_div(seconds, RunConstants.SECONDS_PER_MINUTE)
	var rest: int = UtilCore.floor_mod(seconds, RunConstants.SECONDS_PER_MINUTE)
	_format_args.clear()
	_format_args.set_int("minutes", minutes)
	_format_args.set_int("tens", UtilCore.floor_div(rest, RunConstants.DECIMAL_BASE))
	_format_args.set_int("ones", UtilCore.floor_mod(rest, RunConstants.DECIMAL_BASE))
	timer_label.text = LocalizationCore.format(ReservedString.run_timer(), _format_args)


func _draw_slots(ids: PackedInt32Array, levels: PackedInt32Array, icons: Array[TextureRect], labels: Array[Label],
		weapons: bool) -> void:
	for i: int in icons.size():
		var owned: bool = i < ids.size()
		icons[i].visible = owned
		if not owned:
			continue
		var key: String = GameData.WeaponTable.get_row(ids[i]).icon if weapons else GameData.PassiveTable.get_row(ids[i]).icon
		icons[i].texture = _texture(key)
		if i < labels.size():
			_format_args.clear()
			_format_args.set_int("level", levels[i])
			labels[i].text = LocalizationCore.format(ReservedString.run_slot_level(), _format_args)


func _on_banner(event: RunBannerEvent) -> void:
	banner_label.text = LocalizationCore.get_text(event.text)
	banner_label.visible = true
	TweenCore.play_preset(ResourceKey.TWEEN__RUN__BANNER, scope, banner_label)


func _on_input_prompt_changed(_event: InputPromptChangedEvent) -> void:
	LocalizationCore.bind_text(hint_label, ReservedString.run_hint_move())


func _texture(key: String) -> Texture2D:
	if key.is_empty() or not ResourceCore.is_loaded(key, ResourceCore.BaseKind.TEXTURE_2D):
		return null
	return ResourceCore.get_loaded(key, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
