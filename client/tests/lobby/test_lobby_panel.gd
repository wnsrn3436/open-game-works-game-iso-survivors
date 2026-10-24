extends UnitTestCase
## The camp root panel: a new user sees the first run line instead of the record rows; a returning user sees the four
## record rows; the shrine badge holds the number of upgrades whose next step the gold covers and is hidden at 0.

const _SERVER_TIME: int = 1710000000000
const _RESYNC: String = "core/Resync"


func after_each() -> void:
	super()
	BootstrapCoreDev.shutdown()


func open_panel() -> LobbyPanel:
	assert_true(LogCore.init(), "LogCore.init")
	assert_true(EventCore.init(), "EventCore.init")
	assert_true(TimeCore.init(), "TimeCore.init")
	assert_true(LocalDataCore.init(), "LocalDataCore.init")
	assert_true(LocalDataCore.load_device_file(), "LocalDataCore.load_device_file")
	assert_true(ResourceCore.init(), "ResourceCore.init")
	assert_true(PoolCore.init(), "PoolCore.init")
	assert_true(DataCore.init(), "DataCore.init")
	assert_true(UserStateCore.init(), "UserStateCore.init")
	assert_true(ResolutionCore.init(), "ResolutionCore.init")
	assert_true(SafeAreaCore.init(), "SafeAreaCore.init")
	assert_true(InputBlockCore.init(), "InputBlockCore.init")
	assert_true(InputCore.init(), "InputCore.init")
	assert_true(LocalizationCore.init(), "LocalizationCore.init")
	assert_true(SoundCore.init(), "SoundCore.init")
	assert_true(TweenCore.init(), "TweenCore.init")
	assert_true(UICore.init(), "UICore.init")
	assert_true(MessageCore.init(), "MessageCore.init")
	assert_true(NetworkCore.init(), "NetworkCore.init")
	assert_true(await DataCore.load(null), "DataCore.load")
	LocalizationCore.resolve_language()
	assert_true(await LocalizationCore.load_translation([]), "LocalizationCore.load_translation")
	assert_true(await UICore.prepare(), "UICore.prepare")
	assert_true(await MessageCore.prepare(), "MessageCore.prepare")
	assert_true(NetworkCore.set_server_info("http://127.0.0.1", "1.0.0", CoreBuildInfo.platform), "set_server_info")
	NetworkCore.set_session_provider(LobbyTestSessionProvider.new())
	LogCore.clear_sender()
	assert_true(await UICore.open_panel(ResourceKey.PREFAB__LOBBY__LOBBY_PANEL, null, false), "open the camp panel")
	await UnitTestCore.wait_frames(1)
	var panel: LobbyPanel = find_panel(UICore.get_layer(UICore.UILayer.PANEL))
	assert_not_null(panel, "the camp panel instance")
	return panel


func find_panel(node: Node) -> LobbyPanel:
	if node is LobbyPanel:
		return node as LobbyPanel
	for child: Node in node.get_children():
		var found: LobbyPanel = find_panel(child)
		if found != null:
			return found
	return null


## Receives a full UserState with `gold` gold and, when `runs` is above 0, a run record of `runs` runs.
func receive_state(gold: int, runs: int) -> void:
	var env: CoreContract.ResponseEnvelope = CoreContract.ResponseEnvelope.new()
	env.server_time_at = _SERVER_TIME
	env.user_state = CoreContract.UserStateDelta.new()
	env.user_state.full = true
	var balance: CoreContract.ItemBalanceUserState = CoreContract.ItemBalanceUserState.new()
	balance.id = ReservedId.gold()
	balance.amount = gold
	var entry: CoreContract.UserStateEntry = CoreContract.UserStateEntry.new()
	entry.kind = "ItemBalanceUserState"
	entry.id = ReservedId.gold()
	entry.value = balance.encode()
	env.user_state.entries.append(entry)
	if runs > 0:
		var record: GameContract.RunRecordUserState = GameContract.RunRecordUserState.new()
		record.runs = runs
		record.best_survived_ms = 150000
		record.best_kills = 662
		var record_entry: CoreContract.UserStateEntry = CoreContract.UserStateEntry.new()
		record_entry.kind = "RunRecordUserState"
		record_entry.value = record.encode()
		env.user_state.entries.append(record_entry)
	env.body = CoreContract.ResyncResponse.new().encode()
	UnitTestCore.add_result(_RESYNC, NetworkCore.TransferResult.DONE, 200, UnitTestCore.make_response(env))
	var changed: UnitTestLatch = UnitTestCore.latch_event(UserStateChangedEvent)
	NetworkCore.resync()
	await UnitTestCore.wait_latch(changed)
	await UnitTestCore.wait_frames(1)


## The number of upgrades whose first step costs `gold` or less.
func first_steps_within(gold: int) -> int:
	var count: int = 0
	for row: GameData.UpgradeStepRow in GameData.UpgradeStepTable.all_rows():
		if row.level == 1 and CommonUpgrades.cost(row.id) <= gold:
			count += 1
	return count


func test_a_new_user_sees_the_first_run_line_and_no_badge() -> void:
	var panel: LobbyPanel = await open_panel()
	await receive_state(0, 0)
	assert_true(panel.no_record_label.visible, "the first run line")
	assert_false(panel.stats_box.visible, "no record rows")
	assert_false(panel.badge.visible, "no badge")


func test_a_returning_user_sees_the_record_rows() -> void:
	var panel: LobbyPanel = await open_panel()
	await receive_state(0, 3)
	assert_false(panel.no_record_label.visible, "no first run line")
	assert_true(panel.stats_box.visible, "the record rows")
	var args: FormatArgs = FormatArgs.new()
	args.set_int("time", 150000)
	assert_eq(panel.stat_values[0].text, LocalizationCore.format(ReservedString.lobby_value_time(), args))
	args.clear()
	args.set_int("count", 3)
	assert_eq(panel.stat_values[2].text, LocalizationCore.format(ReservedString.lobby_value_times(), args))


func test_the_badge_counts_the_upgrades_the_gold_covers() -> void:
	var panel: LobbyPanel = await open_panel()
	var gold: int = 100
	await receive_state(gold, 1)
	var expected: int = first_steps_within(gold)
	assert_true(expected > 0, "the gold covers a first step")
	assert_true(panel.badge.visible, "the badge shows")
	var args: FormatArgs = FormatArgs.new()
	args.set_int("count", expected)
	assert_eq(panel.badge_label.text, LocalizationCore.format(ReservedString.lobby_badge(), args))
