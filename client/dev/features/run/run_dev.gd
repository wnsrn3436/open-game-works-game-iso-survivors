class_name RunDev
extends RefCounted
## DEV registration of the run feature: the bot, the screen commands, the fast forward and fall of the save fixtures,
## the invariants, the content state and the telemetry marks. The lambdas hold the one `RunBot` of this boot until
## QACore releases them.


static func register() -> void:
	var bot: RunBot = RunBot.new()
	QACore.register_command("run.bot_next_input", "Returns the next input of the bot player: buy, start, move, pick, back to camp.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return bot.next_input(args))
	QACore.register_command("run.open_run", "Opens the run scene with its HUD; a new run starts and the command ends when it plays.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return await bot.open_run(args))
	QACore.register_command("run.open_levelup", "Opens the level-up popup over a playing run.", PackedStringArray(),
		func(args: PackedStringArray) -> RunCommandResult: return await bot.open_levelup(args))
	QACore.register_command("run.open_pause", "Opens the pause popup over a playing run.", PackedStringArray(),
		func(args: PackedStringArray) -> RunCommandResult: return await bot.open_pause(args))
	QACore.register_command("run.open_result", "Opens the result panel of a dawn run over the run scene.", PackedStringArray(),
		func(args: PackedStringArray) -> RunCommandResult: return await bot.open_result(args))
	QACore.register_command("run.open_result_unsaved", "Opens the result panel of a fallen run the server did not count.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return await bot.open_result_unsaved(args))
	QACore.register_command("run.pause", "Opens the pause popup over the run on screen without starting a new run.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return await bot.pause(args))
	QACore.register_command("run.fast_forward",
		"Runs the playing run the given ms of run time faster than real time with the bot moves and card picks; health is kept full.",
		PackedStringArray(["ms"]), func(args: PackedStringArray) -> RunCommandResult: return await bot.fast_forward(args))
	QACore.register_command("run.state",
		"Reads the run on screen: time, phase, health, level, XP, kills, live enemies, weapons, passives and shrine upgrades.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return bot.state(args))
	QACore.register_command("run.fall", "The player of the playing run falls now; ends when the result panel opens.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return await bot.fall(args))
	QACore.register_invariant("run.health_in_range", func() -> bool: return bot.health_in_range())
	QACore.register_invariant("run.counts_in_range", func() -> bool: return bot.counts_in_range())
	QACore.set_content_state(func() -> String: return RunDev.content_state())
	EventCore.subscribe(RunFallenEvent, bot.on_fallen)
	EventCore.subscribe(RunStartedEvent, bot.on_started)
	EventCore.subscribe(RunFinishedEvent, bot.on_finished)
	EventCore.subscribe(RunPickedEvent, bot.on_picked)
	EventCore.subscribe(RunRespondedEvent, bot.on_responded)


## The stored record, gold and upgrade levels: what a restart keeps.
static func content_state() -> String:
	var levels: int = 0
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		levels += CommonUpgrades.level(row.id)
	return JSON.stringify({
		"runs": CommonRunRecord.runs(),
		"dawns": CommonRunRecord.dawns(),
		"best_survived_ms": CommonRunRecord.best_survived_ms(),
		"best_kills": CommonRunRecord.best_kills(),
		"gold": CommonUpgrades.gold(),
		"upgrade_levels": levels,
	})
