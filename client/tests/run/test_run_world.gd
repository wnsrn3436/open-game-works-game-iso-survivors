extends UnitTestCase
## The run simulation: the same seed and inputs give the same run; the start weapon, health and level; XP gems raise
## the level and queue a pick; picks raise or add weapons and passives within the slots and the top levels; the waves
## spawn enemies; contact hurts the player and a fall ends the run; dawn ends the run at `[run_duration]`; a saved
## state loads back to the same run.

const _SEED: int = 4242


func before_each() -> void:
	assert_true(LogCore.init(), "LogCore.init")
	assert_true(EventCore.init(), "EventCore.init")
	assert_true(TimeCore.init(), "TimeCore.init")
	assert_true(LocalDataCore.init(), "LocalDataCore.init")
	assert_true(LocalDataCore.load_device_file(), "LocalDataCore.load_device_file")
	assert_true(ResourceCore.init(), "ResourceCore.init")
	assert_true(PoolCore.init(), "PoolCore.init")
	assert_true(DataCore.init(), "DataCore.init")
	assert_true(await DataCore.load(null), "DataCore.load")


func after_each() -> void:
	super()
	BootstrapCoreDev.shutdown()


func loadout(seed_value: int) -> GameContract.PlaySessionLoadout:
	var out: GameContract.PlaySessionLoadout = GameContract.PlaySessionLoadout.new()
	out.seed = seed_value
	return out


## A move that turns around every few seconds.
func move_at(i: int) -> Vector2:
	var turn: int = UtilCore.floor_mod(UtilCore.floor_div(i, 61), 4)
	var moves: PackedVector2Array = PackedVector2Array([Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP])
	return moves[turn]


## Runs `ticks` ticks, picking the first card of every pick and keeping the player alive.
func play(world: RunWorld, ticks: int, from: int) -> void:
	for i: int in ticks:
		while world.is_waiting_pick():
			world.apply_choice(world.roll_choices(GameSetting.levelup_choices())[0])
		world.step(move_at(from + i))
		world.hp = world.max_hp
		world.clear_events()


func snapshot(world: RunWorld) -> PackedInt64Array:
	var out: PackedInt64Array = PackedInt64Array([world.time_ms, world.kills, world.level, world.xp, world.hp,
		world.enemy_count, world.gem_count, world.proj_count, world.pickup_count])
	for list: PackedInt32Array in [world.weapon_ids, world.weapon_levels, world.passive_ids, world.passive_levels]:
		for value: int in list:
			out.append(value)
	for i: int in world.enemy_count:
		out.append(roundi(world.enemy_x[i] * 1000.0))
		out.append(roundi(world.enemy_z[i] * 1000.0))
		out.append(world.enemy_hp[i])
	return out


func test_a_run_starts_with_the_start_weapon_full_health_and_level_1() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	assert_eq(world.weapon_ids, PackedInt32Array([ReservedId.start_weapon()]))
	assert_eq(world.weapon_levels, PackedInt32Array([1]))
	assert_eq(world.hp, GameSetting.player_health())
	assert_eq(world.max_hp, GameSetting.player_health())
	assert_eq(world.level, 1)
	assert_eq(world.xp_next, GameSetting.xp_base())
	assert_eq(world.phase, RunWorld.Phase.PLAYING)


func test_the_same_seed_and_inputs_give_the_same_run() -> void:
	var a: RunWorld = RunWorld.new(loadout(_SEED))
	var b: RunWorld = RunWorld.new(loadout(_SEED))
	play(a, 2400, 0)
	play(b, 2400, 0)
	assert_eq(snapshot(a), snapshot(b))
	assert_gt(a.kills, 0, "the run killed enemies")


func test_the_waves_spawn_enemies_around_the_player() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	play(world, UtilCore.floor_div(GameSetting.run_save_interval(), world.tick_ms()), 0)
	assert_gt(world.enemy_count, 0, "enemies spawned")
	for i: int in world.enemy_count:
		var d: float = Vector2(world.enemy_x[i] - world.player_x, world.enemy_z[i] - world.player_z).length()
		assert_lt(d, GameSetting.despawn_radius() + 1.0, "an enemy stays inside the despawn radius")


func test_gems_raise_the_level_and_queue_a_pick() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	world.gem_count = 1
	world.gem_x[0] = world.player_x
	world.gem_z[0] = world.player_z
	world.gem_value[0] = GameSetting.xp_base() + 1
	world.step(Vector2.ZERO)
	assert_eq(world.level, 2)
	assert_eq(world.xp, 1)
	assert_eq(world.xp_next, RunWorld.xp_for_level(2))
	assert_eq(world.pending_levelups, 1)
	assert_true(world.is_waiting_pick(), "the run waits for the pick")
	var time: int = world.time_ms
	world.step(Vector2.RIGHT)
	assert_eq(world.time_ms, time, "no tick runs while a pick waits")


func test_picks_stay_within_the_slots_and_the_top_levels() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	for n: int in 200:
		world.pending_levelups = 1
		var choices: Array[RunChoice] = world.roll_choices(GameSetting.levelup_choices())
		assert_between(choices.size(), 1, GameSetting.levelup_choices())
		world.apply_choice(choices[0])
	assert_eq(world.weapon_ids.size(), GameSetting.weapon_slots())
	assert_eq(world.passive_ids.size(), GameSetting.passive_slots())
	for i: int in world.weapon_ids.size():
		assert_eq(world.weapon_levels[i], GameData.WeaponTable.get_row(world.weapon_ids[i]).max_level)
	for i: int in world.passive_ids.size():
		assert_eq(world.passive_levels[i], GameData.PassiveTable.get_row(world.passive_ids[i]).max_level)
	var last: Array[RunChoice] = world.roll_choices(GameSetting.levelup_choices())
	assert_eq(last.size(), 1)
	assert_eq(last[0].kind, RunChoice.Kind.HEAL, "only the heal is left")


func test_a_weapon_pick_raises_its_level() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	world.pending_levelups = 1
	world.apply_choice(RunChoice.of(RunChoice.Kind.WEAPON, ReservedId.start_weapon(), 2))
	assert_eq(world.weapon_level_of(ReservedId.start_weapon()), 2)
	assert_eq(world.pending_levelups, 0)


func test_a_vitality_passive_raises_the_health() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	for row: GameData.PassiveRow in GameData.PassiveTable.all_rows():
		if row.stat == GameData.RunStat.VITALITY:
			world.apply_choice(RunChoice.of(RunChoice.Kind.PASSIVE, row.id, 1))
			assert_eq(world.max_hp, GameSetting.player_health() + row.per_level)
			assert_eq(world.hp, world.max_hp, "the raised health is filled")


func test_upgrades_of_the_loadout_raise_the_stats() -> void:
	var with_upgrades: GameContract.PlaySessionLoadout = loadout(_SEED)
	var vitality: int = 0
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		if row.stat == GameData.RunStat.VITALITY:
			with_upgrades.upgrade_ids.append(row.id)
			with_upgrades.upgrade_levels.append(2)
			vitality = row.per_level * 2
	var world: RunWorld = RunWorld.new(with_upgrades)
	assert_eq(world.max_hp, GameSetting.player_health() + vitality)
	assert_eq(world.hp, world.max_hp)


func test_contact_hurts_and_a_fall_ends_the_run() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	var kind: int = 0
	world.hp = 1
	world.enemy_count = 1
	world.enemy_kind[0] = kind
	world.enemy_x[0] = world.player_x
	world.enemy_z[0] = world.player_z
	world.enemy_hp[0] = world.enemy_kind_row(kind).health * 100
	world.step(Vector2.ZERO)
	assert_eq(world.phase, RunWorld.Phase.DEAD)
	assert_eq(world.hp, 0)
	assert_true((world.events & RunWorld.EVENT_HURT) != 0, "the hurt event")
	assert_true((world.events & RunWorld.EVENT_DEATH) != 0, "the death event")
	var time: int = world.time_ms
	world.step(Vector2.RIGHT)
	assert_eq(world.time_ms, time, "a fallen run does not tick")


func test_dawn_ends_the_run_at_the_run_duration() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	world.time_ms = world.duration_ms() - world.tick_ms()
	world.step(Vector2.ZERO)
	assert_eq(world.phase, RunWorld.Phase.DAWN)
	assert_eq(world.survived_ms(), GameSetting.run_duration())
	assert_eq(world.enemy_count, 0, "dawn clears the field")
	assert_true((world.events & RunWorld.EVENT_DAWN) != 0, "the dawn event")


func test_give_up_ends_the_run_as_a_fall() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	world.give_up()
	assert_eq(world.phase, RunWorld.Phase.DEAD)


func test_a_saved_state_loads_back_to_the_same_run() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	play(world, 3000, 0)
	var data: RunSaveData = world.save_state()
	var loaded: RunWorld = RunWorld.new(loadout(_SEED))
	assert_true(loaded.load_state(data, _SEED), "the state loads")
	world.proj_count = 0
	assert_eq(snapshot(loaded), snapshot(world))
	assert_eq(loaded.max_hp, world.max_hp)
	assert_eq(loaded.pickup_radius, world.pickup_radius)


func test_a_state_of_another_version_does_not_load() -> void:
	var world: RunWorld = RunWorld.new(loadout(_SEED))
	var data: RunSaveData = world.save_state()
	data.ints[0] = RunConstants.SAVE_VERSION + 1
	assert_false(RunWorld.new(loadout(_SEED)).load_state(data, _SEED))
	var cut: RunSaveData = world.save_state()
	cut.ints.resize(3)
	assert_false(RunWorld.new(loadout(_SEED)).load_state(cut, _SEED), "a cut state does not load")
