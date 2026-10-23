extends UnitTestCase
## The lantern shrine panel: each upgrade row shows its level and the cost of its next step; a buy press without
## enough gold sends no request and says why; a buy press the gold covers sends `BuyShopProduct` of the next step once,
## and a second press while it waits sends nothing.

const _SERVER_TIME: int = 1710000000000
const _RESYNC: String = "core/Resync"
const _BUY: String = "core/BuyShopProduct"


func after_each() -> void:
	super()
	BootstrapCoreDev.shutdown()


func open_panel() -> LobbyUpgradePanel:
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
	assert_true(await UICore.open_panel(ResourceKey.PREFAB__LOBBY__UPGRADE_PANEL, null, false), "open the shrine panel")
	await UnitTestCore.wait_frames(1)
	var panel: LobbyUpgradePanel = find_panel(UICore.get_layer(UICore.UILayer.PANEL))
	assert_not_null(panel, "the shrine panel instance")
	return panel


func find_panel(node: Node) -> LobbyUpgradePanel:
	if node is LobbyUpgradePanel:
		return node as LobbyUpgradePanel
	for child: Node in node.get_children():
		var found: LobbyUpgradePanel = find_panel(child)
		if found != null:
			return found
	return null


## Receives a full UserState whose only item balance is `gold` gold.
func receive_gold(gold: int) -> void:
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
	env.body = CoreContract.ResyncResponse.new().encode()
	UnitTestCore.add_result(_RESYNC, NetworkCore.TransferResult.DONE, 200, UnitTestCore.make_response(env))
	var changed: UnitTestLatch = UnitTestCore.latch_event(UserStateChangedEvent)
	NetworkCore.resync()
	await UnitTestCore.wait_latch(changed)


## The upgrade with the cheapest first step, and that step.
func cheapest_first_step() -> GameData.UpgradeStepRow:
	var best: GameData.UpgradeStepRow = GameData.UpgradeStepTable.empty_row()
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		var step: GameData.UpgradeStepRow = CommonUpgrades.next_step(row.id)
		if best.id == 0 or CommonUpgrades.cost(step.id) < CommonUpgrades.cost(best.id):
			best = step
	return best


func buy_requests() -> Array[CoreContract.BuyShopProductRequest]:
	var out: Array[CoreContract.BuyShopProductRequest] = []
	for request: UnitTestRequest in UnitTestCore.received_requests():
		if request.name == _BUY:
			var buy: CoreContract.BuyShopProductRequest = CoreContract.BuyShopProductRequest.new()
			assert_true(buy.decode(request.body), "the request decodes")
			out.append(buy)
	return out


func test_every_upgrade_row_shows_its_level_and_next_cost() -> void:
	var panel: LobbyUpgradePanel = await open_panel()
	var rows: Array[GameData.UpgradeRow] = CommonUpgrades.upgrades()
	for i: int in rows.size():
		var entry: LobbyUpgradeEntry = panel.entries[i]
		assert_eq(entry.upgrade_id, rows[i].id)
		var args: FormatArgs = FormatArgs.new()
		args.set_int("level", 0)
		args.set_int("max", CommonUpgrades.max_level(rows[i].id))
		assert_eq(entry.level_label.text, LocalizationCore.format(ReservedString.upgrade_level(), args))
		args.clear()
		args.set_int("cost", CommonUpgrades.cost(CommonUpgrades.next_step(rows[i].id).id))
		assert_eq(entry.cost_label.text, LocalizationCore.format(ReservedString.upgrade_cost(), args))


func test_a_buy_without_enough_gold_sends_nothing() -> void:
	await open_panel()
	var step: GameData.UpgradeStepRow = cheapest_first_step()
	await receive_gold(CommonUpgrades.cost(step.id) - 1)
	assert_true(UnitTestCore.tap_anchor("upgrade_buy", step.upgrade), "press buy")
	await UnitTestCore.wait_frames(2)
	assert_eq(buy_requests().size(), 0, "no purchase request")


func test_a_buy_the_gold_covers_sends_the_next_step_once() -> void:
	var panel: LobbyUpgradePanel = await open_panel()
	var step: GameData.UpgradeStepRow = cheapest_first_step()
	await receive_gold(CommonUpgrades.cost(step.id))
	UnitTestCore.add_pending(_BUY)
	assert_true(UnitTestCore.tap_anchor("upgrade_buy", step.upgrade), "press buy")
	await UnitTestCore.wait_frames(2)
	assert_true(panel.is_buying(), "the purchase waits")
	assert_false(panel.buy_next(step.upgrade), "a second buy while it waits is refused")
	await UnitTestCore.wait_frames(2)
	var sent: Array[CoreContract.BuyShopProductRequest] = buy_requests()
	assert_eq(sent.size(), 1, "one purchase request")
	assert_eq(sent[0].product_id, step.id)
	assert_eq(sent[0].quantity, 1)
