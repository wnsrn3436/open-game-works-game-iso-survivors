class_name RunBot
extends RefCounted
## The bot player and the screen commands of the run feature. In the camp it buys a shrine upgrade the gold covers and
## starts a run; in a run it holds the move keys `RunBotPolicy` chooses and picks level-up cards; on the result panel it
## goes back to the camp; on the pause popup it continues. It releases held keys before it leaves the run play. The
## fast forward of the save fixtures runs the run simulation with the same policy faster than real time.

const _ANCHOR_PLAY: String = "lobby_play"
const _ANCHOR_UPGRADES: String = "lobby_upgrades"
const _ANCHOR_BUY: String = "upgrade_buy"
const _ANCHOR_CLOSE: String = "upgrade_close"
const _ANCHOR_CHOICE: String = "levelup_choice"
const _ANCHOR_RESUME: String = "pause_resume"
const _ANCHOR_LOBBY: String = "result_lobby"

## The keys the bot holds now.
var _held: PackedStringArray = PackedStringArray()
## A fall waits for the next run start to count as a restart.
var _restart_pending: bool = false


## `run.bot_next_input`: the next input command, or `null` while a transition runs or nothing changes.
func next_input(_args: PackedStringArray) -> RunCommandResult:
	if SceneCore.is_transitioning() or UICore.is_panel_transitioning() or UICore.is_system_popup_visible():
		return _release_or("", 0)
	var scene: String = SceneCore.current_scene_key()
	if scene == ResourceKey.SCENE__LOBBY__LOBBY:
		return _camp_input()
	if scene != ResourceKey.SCENE__RUN__RUN:
		return _release_or("", 0)
	if UICore.get_open_popups().has(ResourceKey.PREFAB__RUN__PAUSE_POPUP):
		return _release_or(_ANCHOR_RESUME, 0)
	if UICore.get_current_panel_key() == ResourceKey.PREFAB__RUN__RESULT_PANEL:
		return _release_or(_ANCHOR_LOBBY, 0)
	var run: RunScene = find_run_scene()
	if run == null or run.get_world() == null:
		return _release_or("", 0)
	if UICore.get_open_popups().has(ResourceKey.PREFAB__RUN__LEVELUP_POPUP):
		var popup: RunLevelupPopup = RunBot._find_popup((Engine.get_main_loop() as SceneTree).root)
		if popup == null or popup.get_choices().is_empty():
			return _release_or("", 0)
		var choice: RunChoice = popup.get_choices()[RunBotPolicy.pick(popup.get_choices(), run.get_world())]
		return _release_or(_ANCHOR_CHOICE, choice.id)
	if not run.is_running() or run.is_paused():
		return _release_or("", 0)
	return _steer(RunBotPolicy.keys(RunBotPolicy.direction(run.get_world())))


func _camp_input() -> RunCommandResult:
	var panel: String = UICore.get_current_panel_key()
	var target: int = CommonUpgrades.cheapest_affordable()
	if panel == ResourceKey.PREFAB__LOBBY__UPGRADE_PANEL:
		return _release_or(_ANCHOR_BUY if target != 0 else _ANCHOR_CLOSE, target)
	if panel != ResourceKey.PREFAB__LOBBY__LOBBY_PANEL:
		return _release_or("", 0)
	return _release_or(_ANCHOR_UPGRADES if target != 0 else _ANCHOR_PLAY, 0)


func on_fallen(_event: RunFallenEvent) -> void:
	_restart_pending = true
	QACore.mark(QACore.MarkKind.FAIL)


func on_started(_event: RunStartedEvent) -> void:
	if _restart_pending:
		_restart_pending = false
		QACore.mark(QACore.MarkKind.RESTART)


func on_finished(event: RunFinishedEvent) -> void:
	if event.saved:
		QACore.mark(QACore.MarkKind.GOAL)


func on_picked(event: RunPickedEvent) -> void:
	QACore.mark(QACore.MarkKind.REWARD, event.id)


func on_responded(_event: RunRespondedEvent) -> void:
	QACore.mark(QACore.MarkKind.RESPONSE)


## Health stays between 0 and the maximum, and the level is at least 1, in a run on screen.
func health_in_range() -> bool:
	var world: RunWorld = _world()
	return world == null or (world.hp >= 0 and world.hp <= world.max_hp and world.level >= 1)


## The live counts stay inside their buffers.
func counts_in_range() -> bool:
	var world: RunWorld = _world()
	return world == null or (world.enemy_count <= RunConstants.MAX_ENEMIES and world.gem_count <= RunConstants.MAX_GEMS
		and world.proj_count <= RunConstants.MAX_PROJECTILES)


## A run on screen is kept only while it plays with its HUD on top and no popup; otherwise the run scene opens again
## with a new run. Ends when the run plays.
func open_run(_args: PackedStringArray) -> RunCommandResult:
	var run: RunScene = find_run_scene()
	var keep: bool = SceneCore.current_scene_key() == ResourceKey.SCENE__RUN__RUN and run != null and run.is_running() \
		and UICore.get_open_popups().is_empty() and UICore.get_current_panel_key() == ResourceKey.PREFAB__RUN__HUD_PANEL
	if not keep:
		UICore.close_all_popups()
		if not await SceneCore.change_scene(ResourceKey.SCENE__RUN__RUN, null):
			return _result(false, "\"the run scene did not open\"")
	return await _wait_running()


func open_levelup(args: PackedStringArray) -> RunCommandResult:
	var opened: RunCommandResult = await open_run(args)
	if not opened.ok:
		return opened
	find_run_scene().get_world().pending_levelups += 1
	return await _wait_popup(ResourceKey.PREFAB__RUN__LEVELUP_POPUP)


func open_pause(args: PackedStringArray) -> RunCommandResult:
	var opened: RunCommandResult = await open_run(args)
	if not opened.ok:
		return opened
	EventCore.publish(EventCore.acquire(RunPauseRequestedEvent))
	return await _wait_popup(ResourceKey.PREFAB__RUN__PAUSE_POPUP)


## `run.pause`: opens the pause popup over the run on screen without starting a new one.
func pause(_args: PackedStringArray) -> RunCommandResult:
	var run: RunScene = find_run_scene()
	if run == null or not run.is_running():
		return _result(false, "\"no run plays\"")
	EventCore.publish(EventCore.acquire(RunPauseRequestedEvent))
	return await _wait_popup(ResourceKey.PREFAB__RUN__PAUSE_POPUP)


func open_result(args: PackedStringArray) -> RunCommandResult:
	return await _open_result_preview(args, true)


func open_result_unsaved(args: PackedStringArray) -> RunCommandResult:
	return await _open_result_preview(args, false)


func _open_result_preview(args: PackedStringArray, saved: bool) -> RunCommandResult:
	var opened: RunCommandResult = await open_run(args)
	if not opened.ok:
		return opened
	var param: RunResultParam = RunResultParam.new()
	param.dawn = saved
	param.saved = saved
	param.survived_ms = RunConstants.PREVIEW_SURVIVED_MS
	param.kills = RunConstants.PREVIEW_KILLS
	param.level = RunConstants.PREVIEW_LEVEL
	param.gold = RunConstants.PREVIEW_GOLD
	param.new_best = saved
	param.on_again = func() -> void: pass
	param.on_lobby = func() -> void: SceneCore.change_scene(ResourceKey.SCENE__LOBBY__LOBBY, null)
	var ok: bool = await UICore.open_panel(ResourceKey.PREFAB__RUN__RESULT_PANEL, param, false)
	return _result(ok, "" if ok else "\"the result did not open\"")


## `run.fast_forward`: runs the run on screen `ms` of run time faster than real time with the bot policy, picking every
## level-up card with it. Health is filled back each tick (a DEV cheat), so the run reaches that time. Game time is held
## meanwhile and the view sees none of the skipped events. The run is saved at the end, so a restart resumes it there.
func fast_forward(args: PackedStringArray) -> RunCommandResult:
	if args.size() != 1 or not args[0].is_valid_int() or args[0].to_int() <= 0:
		return _result(false, "\"the argument is a run time in ms above 0\"")
	var run: RunScene = find_run_scene()
	if run == null or not run.is_running() or run.is_paused():
		return _result(false, "\"no run plays\"")
	var world: RunWorld = run.get_world()
	var target: int = mini(world.time_ms + args[0].to_int(), world.duration_ms() - world.tick_ms())
	TimeCore.set_paused(true)
	while world.time_ms < target and world.phase == RunWorld.Phase.PLAYING:
		for i: int in RunConstants.FAST_FORWARD_TICKS_PER_FRAME:
			if world.time_ms >= target:
				break
			while world.is_waiting_pick():
				var choices: Array[RunChoice] = world.roll_choices(GameSetting.levelup_choices())
				world.apply_choice(choices[RunBotPolicy.pick(choices, world)])
			world.step(RunBotPolicy.direction(world))
			world.hp = world.max_hp
		world.clear_events()
		await (Engine.get_main_loop() as SceneTree).process_frame
	while world.is_waiting_pick():
		var rest: Array[RunChoice] = world.roll_choices(GameSetting.levelup_choices())
		world.apply_choice(rest[RunBotPolicy.pick(rest, world)])
	world.clear_events()
	TimeCore.set_paused(false)
	run.save_run()
	var playing: bool = world.phase == RunWorld.Phase.PLAYING
	return _result(playing, "" if playing else "\"the run ended during the fast forward\"")


## `run.fall`: the player of the run on screen falls now (a DEV cheat). Ends when the result panel opens.
func fall(_args: PackedStringArray) -> RunCommandResult:
	var run: RunScene = find_run_scene()
	if run == null or not run.is_running():
		return _result(false, "\"no run plays\"")
	run.get_world().give_up()
	for i: int in RunConstants.DEV_WAIT_FRAMES:
		if UICore.get_current_panel_key() == ResourceKey.PREFAB__RUN__RESULT_PANEL and not UICore.is_panel_transitioning():
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the result panel did not open\"")


## The run scene on screen, or `null`.
func find_run_scene() -> RunScene:
	return RunBot._find_run((Engine.get_main_loop() as SceneTree).root)


func _world() -> RunWorld:
	var run: RunScene = find_run_scene()
	return null if run == null else run.get_world()


func _wait_running() -> RunCommandResult:
	for i: int in RunConstants.DEV_WAIT_FRAMES:
		var run: RunScene = find_run_scene()
		if run != null and run.is_running() and not SceneCore.is_transitioning():
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the run did not start\"")


func _wait_popup(key: String) -> RunCommandResult:
	for i: int in RunConstants.DEV_WAIT_FRAMES:
		if UICore.get_open_popups().has(key):
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the popup did not open\"")


static func _find_run(node: Node) -> RunScene:
	if node is RunScene:
		return node as RunScene
	for child: Node in node.get_children():
		var found: RunScene = RunBot._find_run(child)
		if found != null:
			return found
	return null


static func _find_popup(node: Node) -> RunLevelupPopup:
	if node is RunLevelupPopup:
		return node as RunLevelupPopup
	for child: Node in node.get_children():
		var found: RunLevelupPopup = RunBot._find_popup(child)
		if found != null:
			return found
	return null


## Releases a held key that `want` does not hold, then holds a wanted key, or returns `null` when they match.
func _steer(want: PackedStringArray) -> RunCommandResult:
	for key: String in _held:
		if not want.has(key):
			_held.remove_at(_held.find(key))
			return _input("key_up", key, 0)
	for key: String in want:
		if not _held.has(key):
			_held.append(key)
			return _input("key_down", key, 0)
	return _result(true, "null")


## Releases a held key first; then taps `anchor` (with `key` when it is above 0), or returns `null` for no anchor.
func _release_or(anchor: String, key: int) -> RunCommandResult:
	if not _held.is_empty():
		var released: String = _held[_held.size() - 1]
		_held.remove_at(_held.size() - 1)
		return _input("key_up", released, 0)
	if anchor.is_empty():
		return _result(true, "null")
	return _input("tap_anchor", anchor, key)


func _input(command: String, arg: String, key: int) -> RunCommandResult:
	var args: PackedStringArray = PackedStringArray([arg])
	if key > 0:
		args.append(str(key))
	return _result(true, JSON.stringify({"command": command, "args": args}))


func _result(ok: bool, result: String) -> RunCommandResult:
	var out: RunCommandResult = RunCommandResult.new()
	out.ok = ok
	out.result = result
	return out
