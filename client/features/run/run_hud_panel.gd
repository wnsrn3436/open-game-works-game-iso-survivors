class_name RunHudPanel
extends UIPanel
## Root panel of the run: the health bar and its numbers, the XP bar and the level, the run timer, kills, the run gold
## so far, the icons and levels of the owned weapons and passives, the shrine upgrades the run started with under a
## title with the effect each gives, the move hint, the start status, the warning banner and the gold notice. A small
## health bar follows the player on screen; at low health both health bars pulse, the health text turns red and a
## warning line shows under the player. When the player falls, the fall title shows over the field and pops at each
## input until the result. It draws `RunStateChangedEvent`, `RunBannerEvent`, `RunPlayerDrawnEvent`, `RunFallenEvent`
## and `RunRespondedEvent`. A back input or the `pause` action asks the run scene to pause; the UI keeps running while
## the run world is stopped, so a `pause` press there is not lost.

const _PAUSE: StringName = &"pause"

enum SlotKind { WEAPON, PASSIVE, UPGRADE }

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
@export var notice_label: Label
@export var fall_label: Label
@export var hp_bar: Control
@export var player_bar: Control
@export var player_fill: Control
@export var low_health_label: Label
@export var blessing_plate: Control
@export var blessing_title: Label
@export var blessing_icons: Array[TextureRect] = []
@export var blessing_levels: Array[Label] = []

var _format_args: FormatArgs = FormatArgs.new()
var _level: int = -1
var _kills: int = -1
var _gold: int = -1
var _seconds: int = -1
var _hp: int = -1
var _max_hp: int = -1
var _low: bool = false
var _low_handles: PackedInt64Array = PackedInt64Array()
var _fallen: bool = false
var _weapon_ids: PackedInt32Array = PackedInt32Array([-1])
var _weapon_lv: PackedInt32Array = PackedInt32Array()
var _passive_ids: PackedInt32Array = PackedInt32Array([-1])
var _passive_lv: PackedInt32Array = PackedInt32Array()
var _upgrade_ids: PackedInt32Array = PackedInt32Array([-1])
var _upgrade_lv: PackedInt32Array = PackedInt32Array()


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(hint_label, ReservedString.run_hint_move())
	LocalizationCore.bind_text(status_label, ReservedString.run_starting())
	level_label.pivot_offset = level_label.size * 0.5
	kills_label.pivot_offset = kills_label.size * 0.5
	banner_label.pivot_offset = banner_label.size * 0.5
	notice_label.pivot_offset = notice_label.size * 0.5
	fall_label.pivot_offset = fall_label.size * 0.5
	hp_fill.self_modulate = RunConstants.HEALTH_COLOR
	player_fill.self_modulate = RunConstants.HEALTH_COLOR
	LocalizationCore.bind_text(low_health_label, ReservedString.run_low_health())
	LocalizationCore.bind_text(blessing_title, ReservedString.run_blessing_title())
	xp_fill.self_modulate = RunConstants.XP_COLOR
	gold_icon.texture = _texture(ResourceKey.ICON__GOLD)
	kills_icon.texture = _texture(ResourceKey.ICON__KILLS)
	timer_icon.texture = _texture(ResourceKey.ICON__TIMER)
	EventCore.subscribe(RunStateChangedEvent, _on_state_changed)
	EventCore.subscribe(RunBannerEvent, _on_banner)
	EventCore.subscribe(RunPlayerDrawnEvent, _on_player_drawn)
	EventCore.subscribe(RunFallenEvent, _on_fallen)
	EventCore.subscribe(RunRespondedEvent, _on_responded)
	EventCore.subscribe(InputPromptChangedEvent, _on_input_prompt_changed)
	banner_label.visible = false
	notice_label.visible = false
	fall_label.visible = false
	player_bar.visible = false
	low_health_label.visible = false
	status_label.visible = true
	hint_label.visible = false
	_draw_slots(PackedInt32Array(), PackedInt32Array(), weapon_icons, weapon_levels, SlotKind.WEAPON)
	_draw_slots(PackedInt32Array(), PackedInt32Array(), passive_icons, passive_levels, SlotKind.PASSIVE)
	_draw_slots(PackedInt32Array(), PackedInt32Array(), blessing_icons, blessing_levels, SlotKind.UPGRADE)
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
	hint_label.visible = event.show_hint and not event.starting and not _fallen
	if event.starting:
		return
	player_bar.visible = not _fallen
	if event.hp != _hp or event.max_hp != _max_hp:
		_hp = event.hp
		_max_hp = event.max_hp
		var ratio: float = clampf(float(event.hp) / float(maxi(event.max_hp, 1)), 0.0, 1.0)
		hp_fill.anchor_right = ratio
		player_fill.anchor_right = ratio
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
	_draw_low_health(event.low_health and not _fallen)
	if event.weapon_ids != _weapon_ids or event.weapon_levels != _weapon_lv:
		_weapon_ids = event.weapon_ids.duplicate()
		_weapon_lv = event.weapon_levels.duplicate()
		_draw_slots(event.weapon_ids, event.weapon_levels, weapon_icons, weapon_levels, SlotKind.WEAPON)
	if event.passive_ids != _passive_ids or event.passive_levels != _passive_lv:
		_passive_ids = event.passive_ids.duplicate()
		_passive_lv = event.passive_levels.duplicate()
		_draw_slots(event.passive_ids, event.passive_levels, passive_icons, passive_levels, SlotKind.PASSIVE)
	if event.upgrade_ids != _upgrade_ids or event.upgrade_levels != _upgrade_lv:
		_upgrade_ids = event.upgrade_ids.duplicate()
		_upgrade_lv = event.upgrade_levels.duplicate()
		_draw_slots(event.upgrade_ids, event.upgrade_levels, blessing_icons, blessing_levels, SlotKind.UPGRADE)
		blessing_plate.visible = not event.upgrade_ids.is_empty()


## Starts or stops the low health pulse of both health bars, the red health text and the warning under the player.
func _draw_low_health(low: bool) -> void:
	if low == _low:
		return
	_low = low
	low_health_label.visible = low
	var text_color: Color = RunConstants.LOW_HEALTH_TEXT_COLOR if low else RunConstants.HEALTH_TEXT_COLOR
	hp_label.add_theme_color_override(&"font_color", text_color)
	for handle: int in _low_handles:
		TweenCore.stop(handle)
	_low_handles.clear()
	hp_bar.modulate = Color.WHITE
	player_bar.modulate = Color.WHITE
	if low:
		_low_handles.append(TweenCore.play_preset(ResourceKey.TWEEN__RUN__LOW_HEALTH, scope, hp_bar))
		_low_handles.append(TweenCore.play_preset(ResourceKey.TWEEN__RUN__LOW_HEALTH, scope, player_bar))


func _on_player_drawn(event: RunPlayerDrawnEvent) -> void:
	player_bar.global_position = event.screen + Vector2(-player_bar.size.x * 0.5, RunConstants.PLAYER_BAR_GAP)


## The fall title over the field; the player bar, the hint and the low health warning go away.
func _on_fallen(event: RunFallenEvent) -> void:
	_fallen = true
	_draw_low_health(false)
	player_bar.visible = false
	hint_label.visible = false
	LocalizationCore.bind_text(fall_label, ReservedString.run_gave_up() if event.gave_up else ReservedString.run_fallen())
	fall_label.visible = true
	TweenCore.play_preset(ResourceKey.TWEEN__RUN__RESULT_IN, scope, fall_label)


## An input while the fall title shows: the title pops, the answer to that input until the result opens.
func _on_responded(_event: RunRespondedEvent) -> void:
	if _fallen:
		TweenCore.play_preset(ResourceKey.TWEEN__RUN__HUD_POP, scope, fall_label)


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
		kind: SlotKind) -> void:
	for i: int in icons.size():
		var owned: bool = i < ids.size()
		icons[i].visible = owned
		if kind == SlotKind.UPGRADE:
			(icons[i].get_parent() as Control).visible = owned
		if not owned:
			continue
		icons[i].texture = _texture(RunHudPanel._icon_of(kind, ids[i]))
		if i >= labels.size():
			continue
		_format_args.clear()
		if kind == SlotKind.UPGRADE:
			var upgrade: GameData.UpgradeRow = GameData.UpgradeTable.get_row(ids[i])
			_format_args.set_int("value", CommonStatText.shown_value(upgrade.stat, upgrade.per_level * levels[i]))
			labels[i].text = LocalizationCore.format(upgrade.bonus, _format_args)
		else:
			_format_args.set_int("level", levels[i])
			labels[i].text = LocalizationCore.format(ReservedString.run_slot_level(), _format_args)


static func _icon_of(kind: SlotKind, id: int) -> String:
	match kind:
		SlotKind.WEAPON:
			return GameData.WeaponTable.get_row(id).icon
		SlotKind.PASSIVE:
			return GameData.PassiveTable.get_row(id).icon
	return GameData.UpgradeTable.get_row(id).icon


func _on_banner(event: RunBannerEvent) -> void:
	var label: Label = notice_label if event.notice else banner_label
	label.text = LocalizationCore.get_text(event.text)
	label.visible = true
	TweenCore.play_preset(ResourceKey.TWEEN__RUN__BANNER, scope, label)


func _on_input_prompt_changed(_event: InputPromptChangedEvent) -> void:
	LocalizationCore.bind_text(hint_label, ReservedString.run_hint_move())


func _texture(key: String) -> Texture2D:
	if key.is_empty() or not ResourceCore.is_loaded(key, ResourceCore.BaseKind.TEXTURE_2D):
		return null
	return ResourceCore.get_loaded(key, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
