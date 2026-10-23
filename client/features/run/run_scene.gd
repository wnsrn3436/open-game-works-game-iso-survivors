class_name RunScene
extends SceneBase
## One run. It starts a play session on the server, builds a `RunWorld` from the loadout, runs it on fixed ticks of
## game time with the move input, draws it with `RunView`, plays the hit, level-up, hurt and dawn feedback, opens the
## level-up popup for each pending pick, and when the player falls or dawn breaks sends the result with
## `FinishPlaySession` and opens the result panel. The HUD is the root panel; it follows `RunStateChangedEvent`. The
## pause popup and the level-up popup hold game time with `TimeCore.set_paused` while they are open. The run state is
## saved with `CommonRunSave` every `[run_save_interval]` of run time, after each pick and when the scene exits; a run
## the app left resumes from it with the pause popup open.

enum Stage { STARTING, PLAYING, ENDING, SAVING, RESULT, LEAVING }

const _LEFT: StringName = &"move_left"
const _RIGHT: StringName = &"move_right"
const _UP: StringName = &"move_up"
const _DOWN: StringName = &"move_down"

@export var camera: Camera3D
@export var view: RunView

var _stage: Stage = Stage.STARTING
var _world: RunWorld = null
var _play_session_id: String = ""
var _started_at: int = 0
var _loadout_bytes: PackedByteArray = PackedByteArray()
var _next_save_ms: int = 0
var _acc_ms: int = 0
var _end_wait_ms: int = 0
var _move: Vector2 = Vector2.ZERO
var _input: Vector2 = Vector2.ZERO
var _paused: bool = false
var _picking: bool = false
var _moved: bool = false
var _gold_granted: int = 0
var _best_before: int = 0
var _send_finish: Callable = Callable()
var _shown_starting: bool = false
var _shown_moved: bool = false
var _shown_hp: int = -1
var _shown_max_hp: int = -1
var _shown_level: int = -1
var _shown_xp: int = -1
var _shown_kills: int = -1
var _shown_seconds: int = -1
var _flash_hurt: TweenDefinition = null
var _flash_level: TweenDefinition = null
var _flash_dawn: TweenDefinition = null
var _weapon_sounds: Dictionary[int, String] = {}


func on_preload(preload_request: PreloadRequest, prefill_items: Array[PrefillItem]) -> void:
	for key: String in RunView.model_keys():
		preload_request.add_item(key, ResourceCore.BaseKind.PACKED_SCENE)
	for key: String in RunScene.icon_keys():
		preload_request.add_item(key, ResourceCore.BaseKind.TEXTURE_2D)
	for key: String in RunScene.sound_keys():
		preload_request.add_item(key, ResourceCore.BaseKind.AUDIO_STREAM)
	var tween_kind: int = TweenCore.get_preset_kind()
	for key: String in RunScene.tween_keys():
		preload_request.add_item(key, tween_kind)
	for key: String in RunView.pooled_keys():
		var item: PrefillItem = PrefillItem.new()
		item.resource_key = key
		item.pool_scope = scope
		prefill_items.append(item)


func on_prepare() -> bool:
	camera.size = GameSetting.camera_size()
	view.setup(scope)
	for row: GameData.WeaponRow in GameData.WeaponTable.all_rows():
		_weapon_sounds[row.kind] = row.sound
	_send_finish = _finish_run
	if not CameraCore.attach_camera(camera):
		return false
	var follow: FollowOptions = FollowOptions.new()
	follow.offset = RunConstants.CAMERA_OFFSET
	follow.smooth_time_ms = GameSetting.camera_smooth()
	return CameraCore.follow(view.player, follow)


func on_start() -> void:
	SoundCore.play_bgm(ResourceKey.BGM__RUN, scope)
	var kind: int = TweenCore.get_preset_kind()
	_flash_hurt = ResourceCore.get_loaded(ResourceKey.TWEEN__RUN__HURT_FLASH, kind, scope) as TweenDefinition
	_flash_level = ResourceCore.get_loaded(ResourceKey.TWEEN__RUN__LEVEL_FLASH, kind, scope) as TweenDefinition
	_flash_dawn = ResourceCore.get_loaded(ResourceKey.TWEEN__RUN__DAWN_FLASH, kind, scope) as TweenDefinition
	EventCore.subscribe(RunPauseRequestedEvent, _on_pause_requested)
	EventCore.subscribe(ItemChangedEvent, _on_item_changed)
	if not _resume_run():
		_begin_run()


func on_exit() -> void:
	if _stage == Stage.PLAYING:
		save_run()
	EventCore.unsubscribe_all(self)
	_set_paused(false)
	GameUpdateCore.set_in_play(false)
	CameraCore.detach_camera()


## The simulation of the run on screen. `null` until the server starts the play session.
func get_world() -> RunWorld:
	return _world


## Whether the run plays: the server started its play session and the run has not ended.
func is_running() -> bool:
	return _stage == Stage.PLAYING


func is_paused() -> bool:
	return _paused


## Whether the level-up popup holds the run.
func is_picking() -> bool:
	return _picking


## Icon resource keys of the HUD and the level-up popup.
static func icon_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray([ResourceKey.ICON__HEAL_SOUP, ResourceKey.ICON__GOLD,
		ResourceKey.ICON__KILLS, ResourceKey.ICON__TIMER])
	for row: GameData.WeaponRow in GameData.WeaponTable.all_rows():
		keys.append(row.icon)
	for row: GameData.PassiveRow in GameData.PassiveTable.all_rows():
		keys.append(row.icon)
	return keys


static func sound_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray([
		ReservedSound.run_enemy_hit(), ReservedSound.run_enemy_die(), ReservedSound.run_gem(), ReservedSound.run_level_up(),
		ReservedSound.run_pick(), ReservedSound.run_player_hurt(), ReservedSound.run_chest(), ReservedSound.run_elite(),
		ReservedSound.run_heal(), ReservedSound.run_dawn(), ReservedSound.run_death()])
	for row: GameData.WeaponRow in GameData.WeaponTable.all_rows():
		keys.append(row.sound)
	return keys


static func tween_keys() -> PackedStringArray:
	return PackedStringArray([
		ResourceKey.TWEEN__RUN__DAMAGE_NUMBER, ResourceKey.TWEEN__RUN__HUD_POP, ResourceKey.TWEEN__RUN__CARD_IN,
		ResourceKey.TWEEN__RUN__HURT_FLASH, ResourceKey.TWEEN__RUN__LEVEL_FLASH, ResourceKey.TWEEN__RUN__DAWN_FLASH,
		ResourceKey.TWEEN__RUN__BANNER, ResourceKey.TWEEN__RUN__RESULT_IN, ResourceKey.TWEEN__RUN__EFFECT_LIFE,
		ResourceKey.TWEEN__RUN__STRIKE])


## Starts the play session of a new run. The run plays once the server answers.
func _begin_run() -> void:
	_stage = Stage.STARTING
	_publish_state(true)
	var request: CoreContract.StartPlaySessionRequest = CoreContract.StartPlaySessionRequest.new()
	request.mode_id = ReservedId.run_mode()
	request.level_id = 0
	NetworkCore.send(request, _on_started, _on_start_failed)


func _on_started(response: ContractMessage) -> void:
	var started: CoreContract.StartPlaySessionResponse = response as CoreContract.StartPlaySessionResponse
	if started == null or _stage != Stage.STARTING:
		return
	var loadout: GameContract.PlaySessionLoadout = GameContract.PlaySessionLoadout.new()
	if not loadout.decode(started.loadout):
		_leave_to_lobby()
		return
	_play_session_id = started.play_session_id
	_started_at = started.started_at
	_loadout_bytes = started.loadout
	_world = RunWorld.new(loadout)
	_acc_ms = 0
	GameUpdateCore.set_in_play(true)
	_stage = Stage.PLAYING
	save_run()
	_publish_state(true)
	EventCore.publish(EventCore.acquire(RunStartedEvent))


## Resumes the run of `CommonRunSave` with the pause popup open. `false` when there is no run to resume; a saved run
## that cannot resume is dropped.
func _resume_run() -> bool:
	if not CommonRunSave.is_resumable():
		CommonRunSave.clear()
		return false
	var loadout: GameContract.PlaySessionLoadout = GameContract.PlaySessionLoadout.new()
	var bytes: PackedByteArray = CommonRunSave.loadout()
	var data: RunSaveData = RunSaveData.new()
	data.ints = CommonRunSave.ints()
	data.floats = CommonRunSave.floats()
	if not loadout.decode(bytes):
		CommonRunSave.clear()
		return false
	var world: RunWorld = RunWorld.new(loadout)
	if not world.load_state(data, loadout.seed):
		CommonRunSave.clear()
		return false
	_world = world
	_play_session_id = CommonRunSave.session_id()
	_started_at = CommonRunSave.started_at()
	_loadout_bytes = bytes
	_moved = true
	_acc_ms = 0
	_next_save_ms = _world.time_ms + GameSetting.run_save_interval()
	GameUpdateCore.set_in_play(true)
	_stage = Stage.PLAYING
	_publish_state(true)
	view.draw(_world, 0.0, Vector2.ZERO, 0)
	EventCore.publish(EventCore.acquire(RunStartedEvent))
	_on_pause_requested(null)
	return true


## Saves the playing run with `CommonRunSave`.
func save_run() -> void:
	if _world == null or _stage != Stage.PLAYING:
		return
	var data: RunSaveData = _world.save_state()
	CommonRunSave.save(_play_session_id, _started_at, _loadout_bytes, data.ints, data.floats)
	_next_save_ms = _world.time_ms + GameSetting.run_save_interval()


func _on_start_failed(_failure: RequestFailure) -> bool:
	if _stage == Stage.STARTING:
		_leave_to_lobby()
	return false


func _process(_delta: float) -> void:
	if _world == null or (_stage != Stage.PLAYING and _stage != Stage.ENDING) or _paused:
		return
	var frame_ms: int = TimeCore.get_game_frame_ms()
	if _stage == Stage.PLAYING and not _picking:
		var held: Vector2 = _move
		var move: Vector2 = _read_move()
		if move != held:
			_settle_held_move(held)
		_acc_ms += frame_ms
		var ticks: int = 0
		while _acc_ms >= _world.tick_ms() and ticks < RunConstants.MAX_TICKS_PER_FRAME and not _world.is_waiting_pick():
			_world.step(move)
			_acc_ms -= _world.tick_ms()
			ticks += 1
		if _acc_ms >= _world.tick_ms():
			_acc_ms = 0
	_handle_events()
	var weight: float = clampf(float(_acc_ms) / float(_world.tick_ms()), 0.0, 1.0)
	view.draw(_world, weight, _move if _stage == Stage.PLAYING else Vector2.ZERO, frame_ms)
	_publish_state(false)
	if _stage == Stage.PLAYING:
		if _world.time_ms >= _next_save_ms and _world.phase == RunWorld.Phase.PLAYING:
			save_run()
		_check_end()
	elif _stage == Stage.ENDING:
		_end_wait_ms -= frame_ms
		if _end_wait_ms <= 0:
			_stage = Stage.SAVING
			_send_finish.call_deferred()


## The move direction on the ground of the held move actions. A change is the first visible answer to that input.
func _read_move() -> Vector2:
	var raw: Vector2 = InputCore.get_vector(_LEFT, _RIGHT, _UP, _DOWN)
	if raw != _input:
		_input = raw
		EventCore.publish(EventCore.acquire(RunRespondedEvent))
		if raw != Vector2.ZERO and not _moved:
			_moved = true
	var ground: Vector3 = RunConstants.ISO_RIGHT * raw.x - RunConstants.ISO_UP * raw.y
	_move = Vector2(ground.x, ground.z).limit_length(1.0)
	return _move


## When half a tick or more has passed since the last tick, one more tick runs with the move held before this frame,
## so the player stops within half a tick of where it was drawn (see `RunView.draw`).
func _settle_held_move(held: Vector2) -> void:
	if held == Vector2.ZERO or _acc_ms * 2 < _world.tick_ms() or _world.is_waiting_pick():
		return
	_world.step(held)
	_acc_ms -= _world.tick_ms()


func _check_end() -> void:
	if _world.is_waiting_pick() and not _picking:
		_open_pick()
		return
	if _world.phase == RunWorld.Phase.PLAYING:
		return
	_stage = Stage.ENDING
	_end_wait_ms = GameSetting.run_end_delay()


func _handle_events() -> void:
	var events: int = _world.events
	view.play_events(_world)
	_play_weapon_sounds(_world.fired_kinds)
	if events & RunWorld.EVENT_HIT:
		_play_sound(ReservedSound.run_enemy_hit())
	if events & RunWorld.EVENT_KILL:
		_play_sound(ReservedSound.run_enemy_die())
	if events & RunWorld.EVENT_GEM:
		_play_sound(ReservedSound.run_gem())
	if events & RunWorld.EVENT_HURT:
		_play_sound(ReservedSound.run_player_hurt())
		CameraCore.shake(GameSetting.shake_hurt())
		_flash(_flash_hurt)
	if events & RunWorld.EVENT_LEVEL_UP:
		_play_sound(ReservedSound.run_level_up())
		_flash(_flash_level)
	if events & RunWorld.EVENT_HEAL:
		_play_sound(ReservedSound.run_heal())
	if events & RunWorld.EVENT_CHEST:
		_play_sound(ReservedSound.run_chest())
	if events & RunWorld.EVENT_ELITE:
		_play_sound(ReservedSound.run_elite())
		CameraCore.shake(GameSetting.shake_elite())
		_banner(ReservedString.run_elite_warning())
	if events & RunWorld.EVENT_DAWN_NEAR:
		_banner(ReservedString.run_dawn_near())
	if _world.strike_count > 0:
		CameraCore.shake(GameSetting.shake_lightning())
	if events & RunWorld.EVENT_DEATH:
		_play_sound(ReservedSound.run_death())
		CameraCore.shake(GameSetting.shake_death())
		EventCore.publish(EventCore.acquire(RunFallenEvent))
	if events & RunWorld.EVENT_DAWN:
		_play_sound(ReservedSound.run_dawn())
		_flash(_flash_dawn)
	_world.clear_events()


func _play_weapon_sounds(fired: int) -> void:
	if fired == 0:
		return
	for kind: int in _weapon_sounds:
		if fired & (1 << kind):
			_play_sound(_weapon_sounds[kind])


func _play_sound(key: String) -> void:
	SoundCore.play(key, SoundCore.SoundBus.SFX, scope)


func _flash(definition: TweenDefinition) -> void:
	if definition != null:
		ScreenEffectCore.play_preset(ScreenEffectCore.ScreenEffectChannel.WORLD, self, definition)


func _banner(text: String) -> void:
	var event: RunBannerEvent = EventCore.acquire(RunBannerEvent) as RunBannerEvent
	event.text = text
	EventCore.publish(event)


## Publishes the HUD state when a value it shows changed since the last publish, or always when `always`.
func _publish_state(always: bool) -> void:
	var starting: bool = _world == null
	var seconds: int = 0 if starting else UtilCore.floor_div(_world.survived_ms(), RunConstants.MS_PER_SECOND)
	var changed: bool = always or starting != _shown_starting or _moved != _shown_moved
	if not starting:
		changed = changed or _world.hp != _shown_hp or _world.max_hp != _shown_max_hp or _world.level != _shown_level \
			or _world.xp != _shown_xp or _world.kills != _shown_kills or seconds != _shown_seconds
	if not changed:
		return
	_shown_starting = starting
	_shown_moved = _moved
	var event: RunStateChangedEvent = EventCore.acquire(RunStateChangedEvent) as RunStateChangedEvent
	event.starting = starting
	event.show_hint = not _moved
	if not starting:
		_shown_hp = _world.hp
		_shown_max_hp = _world.max_hp
		_shown_level = _world.level
		_shown_xp = _world.xp
		_shown_kills = _world.kills
		_shown_seconds = seconds
		event.hp = _world.hp
		event.max_hp = _world.max_hp
		event.level = _world.level
		event.xp = _world.xp
		event.xp_next = _world.xp_next
		event.kills = _world.kills
		event.time_ms = _world.survived_ms()
		event.duration_ms = _world.duration_ms()
		event.gold = RunGold.of_run(_world.survived_ms(), _world.kills, _world.phase == RunWorld.Phase.DAWN,
			_world.greed_permille())
		event.weapon_ids = _world.weapon_ids
		event.weapon_levels = _world.weapon_levels
		event.passive_ids = _world.passive_ids
		event.passive_levels = _world.passive_levels
	EventCore.publish(event)


## Opens the level-up popup for the next pending pick; a chest pick first.
func _open_pick() -> void:
	_picking = true
	_set_paused(true)
	var chest: bool = _world.pending_chests > 0
	var param: RunLevelupParam = RunLevelupParam.new()
	param.chest = chest
	param.choices = _world.roll_choices(GameSetting.chest_choices() if chest else GameSetting.levelup_choices())
	param.on_pick = _on_pick
	UICore.open_popup(ResourceKey.PREFAB__RUN__LEVELUP_POPUP, param, Callable())
	EventCore.publish(EventCore.acquire(RunChoicesShownEvent))


func _on_pick(choice: RunChoice) -> void:
	if _world == null or not _picking:
		return
	_world.apply_choice(choice)
	_play_sound(ReservedSound.run_pick())
	var picked: RunPickedEvent = EventCore.acquire(RunPickedEvent) as RunPickedEvent
	picked.id = choice.id
	EventCore.publish(picked)
	_picking = false
	_publish_state(true)
	save_run()
	if _world.is_waiting_pick() and _stage == Stage.PLAYING:
		_open_pick()
	elif not _picking:
		_set_paused(false)


## Sends the finished run. The result panel opens when the server answers, or with the run unsaved when it refuses it.
func _finish_run() -> void:
	if _stage != Stage.SAVING:
		return
	var result: GameContract.PlaySessionResult = GameContract.PlaySessionResult.new()
	result.survived_ms = _world.survived_ms()
	result.kills = _world.kills
	result.level = _world.level
	result.dawn = _world.phase == RunWorld.Phase.DAWN
	var request: CoreContract.FinishPlaySessionRequest = CoreContract.FinishPlaySessionRequest.new()
	request.play_session_id = _play_session_id
	request.result = result.encode()
	_best_before = CommonRunRecord.best_survived_ms()
	_gold_granted = 0
	NetworkCore.send(request, _on_finished, _on_finish_failed)


func _on_item_changed(event: ItemChangedEvent) -> void:
	if _stage != Stage.SAVING:
		return
	for change: CoreContract.ItemChange in event.changes:
		if change.item_id == ReservedId.gold() and change.source == CoreContract.ItemChangeSource.ITEM_CHANGE_SOURCE_PLAY_SESSION:
			_gold_granted += change.delta


func _on_finished(_response: ContractMessage) -> void:
	GameUpdateCore.set_in_play(false)
	CommonRunSave.clear()
	_show_result(true)


## A play session the server can no longer count (it expired, or the server does not know it) is answered here: the
## result panel says the run was not counted. Other failures keep the core error handling.
func _on_finish_failed(failure: RequestFailure) -> bool:
	GameUpdateCore.set_in_play(false)
	CommonRunSave.clear()
	_show_result(false)
	return RunScene.is_uncounted(failure)


static func is_uncounted(failure: RequestFailure) -> bool:
	if failure.kind != NetworkCore.FailureKind.SERVER_ERROR:
		return false
	return failure.error_code == CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_EXPIRED \
		or failure.error_code == CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_NOT_FOUND


func _show_result(saved: bool) -> void:
	if _stage != Stage.SAVING:
		return
	_stage = Stage.RESULT
	var dawn: bool = _world.phase == RunWorld.Phase.DAWN
	var param: RunResultParam = RunResultParam.new()
	param.dawn = dawn
	param.saved = saved
	param.survived_ms = _world.survived_ms()
	param.kills = _world.kills
	param.level = _world.level
	param.gold = _gold_granted if saved else 0
	param.new_best = saved and _best_before > 0 and _world.survived_ms() > _best_before
	param.on_again = _run_again
	param.on_lobby = _leave_to_lobby
	UICore.open_panel(ResourceKey.PREFAB__RUN__RESULT_PANEL, param, false)
	var finished: RunFinishedEvent = EventCore.acquire(RunFinishedEvent) as RunFinishedEvent
	finished.saved = saved
	finished.dawn = dawn
	EventCore.publish(finished)


## `event` is `null` when the run asks for itself (a resumed run starts paused).
func _on_pause_requested(_event: RunPauseRequestedEvent) -> void:
	if _stage != Stage.PLAYING or _paused or _picking:
		return
	_set_paused(true)
	var param: RunPauseParam = RunPauseParam.new()
	param.on_resume = _on_resume
	param.on_give_up = _on_give_up
	UICore.open_popup(ResourceKey.PREFAB__RUN__PAUSE_POPUP, param, Callable())


func _on_resume() -> void:
	_set_paused(false)


func _on_give_up() -> void:
	_set_paused(false)
	if _world != null and _stage == Stage.PLAYING:
		_world.give_up()


## Holds the run and game time while a popup is open.
func _set_paused(paused: bool) -> void:
	var hold: bool = paused or _picking
	if hold == _paused:
		return
	_paused = hold
	TimeCore.set_paused(hold)


func _run_again() -> void:
	if _stage == Stage.LEAVING:
		return
	_stage = Stage.LEAVING
	SceneCore.change_scene(ResourceKey.SCENE__RUN__RUN, null)


func _leave_to_lobby() -> void:
	if _stage == Stage.LEAVING:
		return
	_stage = Stage.LEAVING
	SceneCore.change_scene(ResourceKey.SCENE__LOBBY__LOBBY, null)
