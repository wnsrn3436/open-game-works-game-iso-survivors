class_name LobbyDev
extends RefCounted
## DEV registration of the camp feature: the screen commands, the shrine purchase of the save fixtures and the gold
## and upgrade invariants.


static func register() -> void:
	QACore.register_command("lobby.open_lobby", "Opens the camp scene with its root panel on top.", PackedStringArray(),
		func(_args: PackedStringArray) -> RunCommandResult: return await LobbyDev.open_lobby())
	QACore.register_command("lobby.open_upgrades", "Opens the lantern shrine panel over the camp.", PackedStringArray(),
		func(_args: PackedStringArray) -> RunCommandResult: return await LobbyDev.open_over_lobby(ResourceKey.PREFAB__LOBBY__UPGRADE_PANEL))
	QACore.register_command("lobby.open_option", "Opens the option panel over the camp.", PackedStringArray(),
		func(_args: PackedStringArray) -> RunCommandResult: return await LobbyDev.open_over_lobby(ResourceKey.PREFAB__LOBBY__OPTION_PANEL))
	QACore.register_command("lobby.buy_upgrade",
		"Opens the lantern shrine and buys the next level of the cheapest upgrade the gold covers, as a press of its buy button does; fails when the gold covers none.",
		PackedStringArray(), func(_args: PackedStringArray) -> RunCommandResult: return await LobbyDev.buy_upgrade())
	QACore.register_invariant("lobby.gold_not_negative", func() -> bool: return CommonUpgrades.gold() >= 0)
	QACore.register_invariant("lobby.upgrades_in_range", func() -> bool: return LobbyDev.upgrades_in_range())


static func open_lobby() -> RunCommandResult:
	UICore.close_all_popups()
	if SceneCore.current_scene_key() != ResourceKey.SCENE__LOBBY__LOBBY:
		if not await SceneCore.change_scene(ResourceKey.SCENE__LOBBY__LOBBY, null):
			return _result(false, "\"the camp did not open\"")
	return _result(await UICore.close_panels_to(ResourceKey.PREFAB__LOBBY__LOBBY_PANEL), "\"the camp did not open\"")


static func open_over_lobby(panel_key: String) -> RunCommandResult:
	var lobby: RunCommandResult = await open_lobby()
	if not lobby.ok:
		return lobby
	return _result(await UICore.open_panel(panel_key, null, false), "\"the panel did not open\"")


static func buy_upgrade() -> RunCommandResult:
	var opened: RunCommandResult = await open_over_lobby(ResourceKey.PREFAB__LOBBY__UPGRADE_PANEL)
	if not opened.ok:
		return opened
	var target: int = CommonUpgrades.cheapest_affordable()
	if target == 0:
		return _result(false, "\"the gold covers no upgrade\"")
	var panel: LobbyUpgradePanel = LobbyDev._find_panel((Engine.get_main_loop() as SceneTree).root)
	if panel == null:
		return _result(false, "\"no shrine panel\"")
	var level: int = CommonUpgrades.level(target)
	if not panel.buy_next(target):
		return _result(false, "\"the purchase was refused\"")
	for i: int in LobbyConstants.DEV_WAIT_FRAMES:
		if CommonUpgrades.level(target) > level and not panel.is_buying():
			return _result(true, "")
		await (Engine.get_main_loop() as SceneTree).process_frame
	return _result(false, "\"the purchase did not finish\"")


static func upgrades_in_range() -> bool:
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		var level: int = CommonUpgrades.level(row.id)
		if level < 0 or level > CommonUpgrades.max_level(row.id):
			return false
	return true


static func _find_panel(node: Node) -> LobbyUpgradePanel:
	if node is LobbyUpgradePanel:
		return node as LobbyUpgradePanel
	for child: Node in node.get_children():
		var found: LobbyUpgradePanel = LobbyDev._find_panel(child)
		if found != null:
			return found
	return null


static func _result(ok: bool, failure: String) -> RunCommandResult:
	var out: RunCommandResult = RunCommandResult.new()
	out.ok = ok
	out.result = "" if ok else failure
	return out
