class_name RunWorld
extends RefCounted
## The simulation of one run on fixed ticks of `[run_tick]`: the player, the horde of the wave rows, the weapons and
## passives, XP gems, chests and soups. Positions are meters on the ground plane (x, z). The caller runs `step` once
## per tick with the move direction on the ground and reads the state and the event buffers after the ticks of a
## frame. Everything random comes from one `UtilCore` random of the loadout seed, so the same seed and the same inputs
## give the same run.

enum Phase { PLAYING, DEAD, DAWN }
enum PickupKind { CHEST, SOUP }

## `events` bits: what happened since the caller last cleared the events.
const EVENT_HIT: int = 1
const EVENT_KILL: int = EVENT_HIT * 2
const EVENT_GEM: int = EVENT_KILL * 2
const EVENT_HURT: int = EVENT_GEM * 2
const EVENT_LEVEL_UP: int = EVENT_HURT * 2
const EVENT_ELITE: int = EVENT_LEVEL_UP * 2
const EVENT_CHEST: int = EVENT_ELITE * 2
const EVENT_HEAL: int = EVENT_CHEST * 2
const EVENT_DEATH: int = EVENT_HEAL * 2
const EVENT_DAWN: int = EVENT_DEATH * 2
const EVENT_DAWN_NEAR: int = EVENT_DAWN * 2

const _PURPOSE: String = "play_session_simulation"
const _PERMILLE: int = RunConstants.PERMILLE

var phase: Phase = Phase.PLAYING
var time_ms: int = 0
var kills: int = 0
var level: int = 1
var xp: int = 0
var xp_next: int = 0
var hp: int = 0
var max_hp: int = 0
## Level-ups and opened chests whose pick has not been made yet.
var pending_levelups: int = 0
var pending_chests: int = 0
var events: int = 0
## Bits `1 << WeaponKind` of the weapons that fired since the events were cleared.
var fired_kinds: int = 0

var player_x: float = 0.0
var player_z: float = 0.0
var prev_player_x: float = 0.0
var prev_player_z: float = 0.0
## Last move direction on the ground; the axe flies this way.
var facing_x: float = 0.0
var facing_z: float = 1.0
## Move speed in m per second with the bonuses.
var move_speed: float = 0.0
var pickup_radius: float = 0.0

## Owned weapons and passives in the order they were taken.
var weapon_ids: PackedInt32Array = PackedInt32Array()
var weapon_levels: PackedInt32Array = PackedInt32Array()
var passive_ids: PackedInt32Array = PackedInt32Array()
var passive_levels: PackedInt32Array = PackedInt32Array()

var enemy_count: int = 0
var enemy_kind: PackedInt32Array = PackedInt32Array()
var enemy_x: PackedFloat32Array = PackedFloat32Array()
var enemy_z: PackedFloat32Array = PackedFloat32Array()
var enemy_prev_x: PackedFloat32Array = PackedFloat32Array()
var enemy_prev_z: PackedFloat32Array = PackedFloat32Array()
var enemy_hp: PackedInt32Array = PackedInt32Array()
var enemy_flash: PackedInt32Array = PackedInt32Array()
var enemy_walk: PackedFloat32Array = PackedFloat32Array()

var gem_count: int = 0
var gem_x: PackedFloat32Array = PackedFloat32Array()
var gem_z: PackedFloat32Array = PackedFloat32Array()
var gem_value: PackedInt32Array = PackedInt32Array()

var pickup_count: int = 0
var pickup_x: PackedFloat32Array = PackedFloat32Array()
var pickup_z: PackedFloat32Array = PackedFloat32Array()
var pickup_kind: PackedInt32Array = PackedInt32Array()

var proj_count: int = 0
var proj_kind: PackedInt32Array = PackedInt32Array()
var proj_x: PackedFloat32Array = PackedFloat32Array()
var proj_z: PackedFloat32Array = PackedFloat32Array()
var proj_prev_x: PackedFloat32Array = PackedFloat32Array()
var proj_prev_z: PackedFloat32Array = PackedFloat32Array()
var proj_vx: PackedFloat32Array = PackedFloat32Array()
var proj_vz: PackedFloat32Array = PackedFloat32Array()

## Orbit blades of the orbit weapon: count, radius and the angle of the first blade.
var orbit_count: int = 0
var orbit_radius: float = 0.0
var orbit_angle: float = 0.0
## Radius of the aura weapon; 0 without it.
var aura_radius: float = 0.0

## Event buffers of the hits, deaths and lightning strikes since the caller last cleared them.
var hit_count: int = 0
var hit_x: PackedFloat32Array = PackedFloat32Array()
var hit_z: PackedFloat32Array = PackedFloat32Array()
var hit_amount: PackedInt32Array = PackedInt32Array()
var death_count: int = 0
var death_x: PackedFloat32Array = PackedFloat32Array()
var death_z: PackedFloat32Array = PackedFloat32Array()
var strike_count: int = 0
var strike_x: PackedFloat32Array = PackedFloat32Array()
var strike_z: PackedFloat32Array = PackedFloat32Array()

var _rng: UtilRandom = null
var _tick_ms: int = 1
var _dt: float = 0.0
var _duration_ms: int = 0
var _dawn_warned: bool = false
## Time left of the player's invulnerability after a hit.
var _invuln_ms: int = 0

## Bonuses of the passives and the loadout upgrades by `RunStat`.
var _might: int = 0
var _haste: int = 0
var _vitality: int = 0
var _magnet: int = 0
var _swiftness: int = 0
var _greed: int = 0
var _upgrade_might: int = 0
var _upgrade_haste: int = 0
var _upgrade_vitality: int = 0
var _upgrade_magnet: int = 0
var _upgrade_swiftness: int = 0
var _upgrade_greed: int = 0

var _enemy_rows: Array[GameData.EnemyRow] = []
var _enemy_index: Dictionary[int, int] = {}
var _waves: Array[GameData.WaveRow] = []
var _wave_weights: Array[PackedInt64Array] = []
var _wave_index: int = -1
var _spawn_timer: int = 0

var _weapon_kind: PackedInt32Array = PackedInt32Array()
var _weapon_timer: PackedInt32Array = PackedInt32Array()
var _weapon_rows: Array[GameData.WeaponLevelRow] = []

var _enemy_contact: PackedInt32Array = PackedInt32Array()
var _enemy_orbit: PackedInt32Array = PackedInt32Array()
var _enemy_aura: PackedInt32Array = PackedInt32Array()
var _enemy_kx: PackedFloat32Array = PackedFloat32Array()
var _enemy_kz: PackedFloat32Array = PackedFloat32Array()
var _enemy_uid: PackedInt32Array = PackedInt32Array()
var _next_uid: int = 1

var _proj_life: PackedInt32Array = PackedInt32Array()
var _proj_damage: PackedInt32Array = PackedInt32Array()
var _proj_pierce: PackedInt32Array = PackedInt32Array()
var _proj_radius: PackedFloat32Array = PackedFloat32Array()
var _proj_hits: PackedInt32Array = PackedInt32Array()
var _proj_hit_count: PackedInt32Array = PackedInt32Array()

var _orbit_damage: int = 0
var _orbit_interval: int = 0
var _aura_damage: int = 0
var _aura_interval: int = 0
var _aura_knockback: float = 0.0

var _cell_head: PackedInt32Array = PackedInt32Array()
var _cell_next: PackedInt32Array = PackedInt32Array()
var _grid_x: float = 0.0
var _grid_z: float = 0.0
## Buffer of the nearest targets one bolt volley picked.
var _targets: PackedInt32Array = PackedInt32Array()
var _hit_orbit_call: Callable = Callable()
var _hit_aura_call: Callable = Callable()


func _init(loadout: GameContract.PlaySessionLoadout) -> void:
	_rng = UtilCore.create_random(UtilCore.make_purpose_seed(_PURPOSE, loadout.seed))
	_tick_ms = maxi(GameSetting.run_tick(), 1)
	_dt = float(_tick_ms) / RunConstants.MS_PER_SECOND_F
	_duration_ms = GameSetting.run_duration()
	_read_tables()
	_read_upgrades(loadout)
	_size_buffers()
	_hit_orbit_call = _hit_orbit
	_hit_aura_call = _hit_aura
	xp_next = RunWorld.xp_for_level(1)
	_add_weapon(ReservedId.start_weapon())
	_recompute_stats()
	hp = max_hp


## XP from level `at` to the next level: `[xp_base]` + (`at` − 1) × `[xp_step]`.
static func xp_for_level(at: int) -> int:
	return GameSetting.xp_base() + (at - 1) * GameSetting.xp_step()


func tick_ms() -> int:
	return _tick_ms


## Run time survived in ms: the run time, `[run_duration]` at dawn.
func survived_ms() -> int:
	return mini(time_ms, _duration_ms)


func duration_ms() -> int:
	return _duration_ms


## Whether the simulation waits for a level-up or chest pick before the next tick.
func is_waiting_pick() -> bool:
	return pending_levelups > 0 or pending_chests > 0


## The greed bonus of the loadout, for the run gold shown during the run.
func greed_permille() -> int:
	return _upgrade_greed + _greed


func enemy_row(index: int) -> GameData.EnemyRow:
	return _enemy_rows[enemy_kind[index]]


func enemy_kind_count() -> int:
	return _enemy_rows.size()


func enemy_kind_row(kind: int) -> GameData.EnemyRow:
	return _enemy_rows[kind]


func weapon_level_of(weapon_id: int) -> int:
	var at: int = weapon_ids.find(weapon_id)
	return 0 if at < 0 else weapon_levels[at]


func passive_level_of(passive_id: int) -> int:
	var at: int = passive_ids.find(passive_id)
	return 0 if at < 0 else passive_levels[at]


func clear_events() -> void:
	events = 0
	fired_kinds = 0
	hit_count = 0
	death_count = 0
	strike_count = 0


## One tick with the move direction `move` on the ground (length 0 to 1).
func step(move: Vector2) -> void:
	if phase != Phase.PLAYING or is_waiting_pick():
		return
	time_ms += _tick_ms
	if time_ms >= _duration_ms:
		_reach_dawn()
		return
	if not _dawn_warned and time_ms >= _duration_ms - GameSetting.dawn_warning():
		_dawn_warned = true
		events |= EVENT_DAWN_NEAR
	_update_wave()
	_move_player(move)
	_build_grid()
	_move_enemies()
	_build_grid()
	_touch_player()
	_tick_weapons()
	_move_projectiles()
	_collect_gems()
	_collect_pickups()
	_remove_dead()
	if hp <= 0:
		hp = 0
		phase = Phase.DEAD
		events |= EVENT_DEATH


## The cards of the next pick: `count` different raises of owned or new weapons and passives, or the heal when
## nothing is left to raise.
func roll_choices(count: int) -> Array[RunChoice]:
	var pool: Array[RunChoice] = []
	for row: GameData.WeaponRow in GameData.WeaponTable.all_rows():
		var owned: int = weapon_level_of(row.id)
		if owned > 0 and owned < row.max_level:
			pool.append(RunChoice.of(RunChoice.Kind.WEAPON, row.id, owned + 1))
		elif owned == 0 and weapon_ids.size() < GameSetting.weapon_slots():
			pool.append(RunChoice.of(RunChoice.Kind.WEAPON, row.id, 1))
	for row: GameData.PassiveRow in GameData.PassiveTable.all_rows():
		var owned: int = passive_level_of(row.id)
		if owned > 0 and owned < row.max_level:
			pool.append(RunChoice.of(RunChoice.Kind.PASSIVE, row.id, owned + 1))
		elif owned == 0 and passive_ids.size() < GameSetting.passive_slots():
			pool.append(RunChoice.of(RunChoice.Kind.PASSIVE, row.id, 1))
	var out: Array[RunChoice] = []
	if pool.is_empty():
		out.append(RunChoice.of(RunChoice.Kind.HEAL, 0, 0))
		return out
	var order: PackedInt64Array = UtilCore.shuffle_indices(_rng, pool.size())
	for i: int in mini(count, pool.size()):
		out.append(pool[order[i]])
	return out


## Applies the pick of one pending level-up or chest.
func apply_choice(choice: RunChoice) -> void:
	if pending_chests > 0:
		pending_chests -= 1
	elif pending_levelups > 0:
		pending_levelups -= 1
	match choice.kind:
		RunChoice.Kind.WEAPON:
			if weapon_level_of(choice.id) == 0:
				_add_weapon(choice.id)
			else:
				_set_weapon_level(weapon_ids.find(choice.id), choice.level)
		RunChoice.Kind.PASSIVE:
			var at: int = passive_ids.find(choice.id)
			if at < 0:
				passive_ids.append(choice.id)
				passive_levels.append(choice.level)
			else:
				passive_levels[at] = choice.level
		RunChoice.Kind.HEAL:
			hp = mini(max_hp, hp + GameSetting.levelup_heal())
	var before: int = max_hp
	_recompute_stats()
	hp = mini(max_hp, hp + maxi(0, max_hp - before))


## The state of the run as two number lists for `CommonRunSave`. Projectiles in flight are not kept.
func save_state() -> RunSaveData:
	var out: RunSaveData = RunSaveData.new()
	var ints: PackedInt64Array = out.ints
	var floats: PackedFloat64Array = out.floats
	ints.append_array(PackedInt64Array([RunConstants.SAVE_VERSION, time_ms, kills, level, xp, xp_next, hp, pending_levelups,
		pending_chests, _wave_index, _spawn_timer, _next_uid, 1 if _dawn_warned else 0]))
	floats.append_array(PackedFloat64Array([player_x, player_z, facing_x, facing_z, orbit_angle]))
	ints.append(weapon_ids.size())
	for slot: int in weapon_ids.size():
		ints.append_array(PackedInt64Array([weapon_ids[slot], weapon_levels[slot], _weapon_timer[slot]]))
	ints.append(passive_ids.size())
	for slot: int in passive_ids.size():
		ints.append_array(PackedInt64Array([passive_ids[slot], passive_levels[slot]]))
	ints.append(enemy_count)
	for i: int in enemy_count:
		ints.append_array(PackedInt64Array([enemy_kind[i], enemy_hp[i], _enemy_contact[i], _enemy_orbit[i], _enemy_aura[i], _enemy_uid[i]]))
		floats.append_array(PackedFloat64Array([enemy_x[i], enemy_z[i], enemy_walk[i], _enemy_kx[i], _enemy_kz[i]]))
	ints.append(gem_count)
	for g: int in gem_count:
		ints.append(gem_value[g])
		floats.append_array(PackedFloat64Array([gem_x[g], gem_z[g]]))
	ints.append(pickup_count)
	for k: int in pickup_count:
		ints.append(pickup_kind[k])
		floats.append_array(PackedFloat64Array([pickup_x[k], pickup_z[k]]))
	out.ints = ints
	out.floats = floats
	return out


## Puts back a state of `save_state`. `false`, with the world unchanged in part, when the lists do not fit this
## version or the tables; the caller then starts a new run.
func load_state(data: RunSaveData, seed_base: int) -> bool:
	var r: RunSaveReader = RunSaveReader.new(data.ints, data.floats)
	if r.next_int() != RunConstants.SAVE_VERSION:
		return false
	time_ms = r.next_int()
	kills = r.next_int()
	level = r.next_int()
	xp = r.next_int()
	xp_next = r.next_int()
	hp = r.next_int()
	pending_levelups = r.next_int()
	pending_chests = r.next_int()
	_wave_index = r.next_int()
	_spawn_timer = r.next_int()
	_next_uid = r.next_int()
	_dawn_warned = r.next_int() == 1
	player_x = r.next_float()
	player_z = r.next_float()
	facing_x = r.next_float()
	facing_z = r.next_float()
	orbit_angle = r.next_float()
	prev_player_x = player_x
	prev_player_z = player_z
	if not _load_loadout_parts(r):
		return false
	_load_field(r)
	_rng = UtilCore.create_random(UtilCore.make_purpose_seed(_PURPOSE, seed_base + time_ms))
	_recompute_stats()
	return r.ok and _wave_index < _waves.size() and level >= 1 and hp > 0


func _load_loadout_parts(r: RunSaveReader) -> bool:
	weapon_ids.clear()
	weapon_levels.clear()
	_weapon_kind.clear()
	_weapon_timer.clear()
	_weapon_rows.clear()
	for n: int in clampi(r.next_int(), 0, RunConstants.MAX_WEAPONS):
		var weapon_id: int = r.next_int()
		var at: int = r.next_int()
		var timer: int = r.next_int()
		if not GameData.WeaponTable.has_row(weapon_id):
			return false
		_add_weapon(weapon_id)
		_set_weapon_level(weapon_ids.size() - 1, at)
		_weapon_timer[weapon_ids.size() - 1] = timer
	passive_ids.clear()
	passive_levels.clear()
	for n: int in clampi(r.next_int(), 0, RunConstants.MAX_PASSIVES):
		var passive_id: int = r.next_int()
		var at: int = r.next_int()
		if not GameData.PassiveTable.has_row(passive_id):
			return false
		passive_ids.append(passive_id)
		passive_levels.append(at)
	return true


func _load_field(r: RunSaveReader) -> void:
	enemy_count = clampi(r.next_int(), 0, RunConstants.MAX_ENEMIES)
	for i: int in enemy_count:
		enemy_kind[i] = clampi(r.next_int(), 0, _enemy_rows.size() - 1)
		enemy_hp[i] = r.next_int()
		_enemy_contact[i] = r.next_int()
		_enemy_orbit[i] = r.next_int()
		_enemy_aura[i] = r.next_int()
		_enemy_uid[i] = r.next_int()
		enemy_x[i] = r.next_float()
		enemy_z[i] = r.next_float()
		enemy_walk[i] = r.next_float()
		_enemy_kx[i] = r.next_float()
		_enemy_kz[i] = r.next_float()
		enemy_prev_x[i] = enemy_x[i]
		enemy_prev_z[i] = enemy_z[i]
		enemy_flash[i] = 0
	gem_count = clampi(r.next_int(), 0, RunConstants.MAX_GEMS)
	for g: int in gem_count:
		gem_value[g] = r.next_int()
		gem_x[g] = r.next_float()
		gem_z[g] = r.next_float()
	pickup_count = clampi(r.next_int(), 0, RunConstants.MAX_PICKUPS)
	for k: int in pickup_count:
		pickup_kind[k] = clampi(r.next_int(), PickupKind.CHEST, PickupKind.SOUP)
		pickup_x[k] = r.next_float()
		pickup_z[k] = r.next_float()
	proj_count = 0


## Ends the run as a give-up: the run counts as a fall at the current time.
func give_up() -> void:
	if phase == Phase.PLAYING:
		phase = Phase.DEAD
		events |= EVENT_DEATH


# --- setup


func _read_tables() -> void:
	for row: GameData.EnemyRow in GameData.EnemyTable.all_rows():
		_enemy_index[row.id] = _enemy_rows.size()
		_enemy_rows.append(row)
	for row: GameData.WaveRow in GameData.WaveTable.all_rows():
		_waves.append(row)
	_waves.sort_custom(func(a: GameData.WaveRow, b: GameData.WaveRow) -> bool: return a.order < b.order)
	for wave: GameData.WaveRow in _waves:
		var weights: PackedInt64Array = PackedInt64Array()
		for item: GameData.WaveEnemiesItem in wave.enemies:
			weights.append(item.weight)
		_wave_weights.append(weights)


func _read_upgrades(loadout: GameContract.PlaySessionLoadout) -> void:
	for i: int in mini(loadout.upgrade_ids.size(), loadout.upgrade_levels.size()):
		var row: GameData.UpgradeRow = GameData.UpgradeTable.get_row(loadout.upgrade_ids[i])
		var bonus: int = row.per_level * loadout.upgrade_levels[i]
		match row.stat:
			GameData.RunStat.MIGHT:
				_upgrade_might += bonus
			GameData.RunStat.HASTE:
				_upgrade_haste += bonus
			GameData.RunStat.VITALITY:
				_upgrade_vitality += bonus
			GameData.RunStat.MAGNET:
				_upgrade_magnet += bonus
			GameData.RunStat.SWIFTNESS:
				_upgrade_swiftness += bonus
			GameData.RunStat.GREED:
				_upgrade_greed += bonus


func _size_buffers() -> void:
	var enemies: int = RunConstants.MAX_ENEMIES
	enemy_kind.resize(enemies)
	enemy_hp.resize(enemies)
	enemy_flash.resize(enemies)
	_enemy_contact.resize(enemies)
	_enemy_orbit.resize(enemies)
	_enemy_aura.resize(enemies)
	_enemy_uid.resize(enemies)
	_cell_next.resize(enemies)
	enemy_x.resize(enemies)
	enemy_z.resize(enemies)
	enemy_prev_x.resize(enemies)
	enemy_prev_z.resize(enemies)
	enemy_walk.resize(enemies)
	_enemy_kx.resize(enemies)
	_enemy_kz.resize(enemies)
	gem_x.resize(RunConstants.MAX_GEMS)
	gem_z.resize(RunConstants.MAX_GEMS)
	gem_value.resize(RunConstants.MAX_GEMS)
	pickup_x.resize(RunConstants.MAX_PICKUPS)
	pickup_z.resize(RunConstants.MAX_PICKUPS)
	pickup_kind.resize(RunConstants.MAX_PICKUPS)
	var projs: int = RunConstants.MAX_PROJECTILES
	proj_kind.resize(projs)
	_proj_life.resize(projs)
	_proj_damage.resize(projs)
	_proj_pierce.resize(projs)
	_proj_hit_count.resize(projs)
	proj_x.resize(projs)
	proj_z.resize(projs)
	proj_prev_x.resize(projs)
	proj_prev_z.resize(projs)
	proj_vx.resize(projs)
	proj_vz.resize(projs)
	_proj_radius.resize(projs)
	_proj_hits.resize(projs * RunConstants.PROJECTILE_HIT_SLOTS)
	hit_x.resize(RunConstants.MAX_HIT_EVENTS)
	hit_z.resize(RunConstants.MAX_HIT_EVENTS)
	hit_amount.resize(RunConstants.MAX_HIT_EVENTS)
	death_x.resize(RunConstants.MAX_DEATH_EVENTS)
	death_z.resize(RunConstants.MAX_DEATH_EVENTS)
	strike_x.resize(RunConstants.MAX_STRIKE_EVENTS)
	strike_z.resize(RunConstants.MAX_STRIKE_EVENTS)
	_cell_head.resize(RunConstants.GRID_CELLS * RunConstants.GRID_CELLS)
	_targets.resize(RunConstants.MAX_PROJECTILES)


func _add_weapon(weapon_id: int) -> void:
	var row: GameData.WeaponRow = GameData.WeaponTable.get_row(weapon_id)
	weapon_ids.append(weapon_id)
	weapon_levels.append(1)
	_weapon_kind.append(row.kind)
	_weapon_timer.append(0)
	_weapon_rows.append(RunWorld.weapon_level_row(weapon_id, 1))


func _set_weapon_level(slot: int, at: int) -> void:
	weapon_levels[slot] = at
	_weapon_rows[slot] = RunWorld.weapon_level_row(weapon_ids[slot], at)


## The `weapon_level` row of `weapon_id` at `at`; the empty row when there is none.
static func weapon_level_row(weapon_id: int, at: int) -> GameData.WeaponLevelRow:
	for row: GameData.WeaponLevelRow in GameData.WeaponLevelTable.get_rows(weapon_id):
		if row.level == at:
			return row
	return GameData.WeaponLevelTable.empty_row()


func _recompute_stats() -> void:
	_might = 0
	_haste = 0
	_vitality = 0
	_magnet = 0
	_swiftness = 0
	_greed = 0
	for i: int in passive_ids.size():
		var row: GameData.PassiveRow = GameData.PassiveTable.get_row(passive_ids[i])
		var bonus: int = row.per_level * passive_levels[i]
		match row.stat:
			GameData.RunStat.MIGHT:
				_might += bonus
			GameData.RunStat.HASTE:
				_haste += bonus
			GameData.RunStat.VITALITY:
				_vitality += bonus
			GameData.RunStat.MAGNET:
				_magnet += bonus
			GameData.RunStat.SWIFTNESS:
				_swiftness += bonus
			GameData.RunStat.GREED:
				_greed += bonus
	max_hp = GameSetting.player_health() + _vitality + _upgrade_vitality
	move_speed = GameSetting.player_speed() * float(_PERMILLE + _swiftness + _upgrade_swiftness) / RunConstants.PERMILLE_F
	pickup_radius = GameSetting.pickup_radius() * float(_PERMILLE + _magnet + _upgrade_magnet) / RunConstants.PERMILLE_F
	orbit_count = 0
	aura_radius = 0.0
	for slot: int in weapon_ids.size():
		var row: GameData.WeaponLevelRow = _weapon_rows[slot]
		if _weapon_kind[slot] == GameData.WeaponKind.ORBIT:
			orbit_count = row.count
			orbit_radius = row.area
			_orbit_damage = _damage(row.damage)
			_orbit_interval = row.cooldown
		elif _weapon_kind[slot] == GameData.WeaponKind.AURA:
			aura_radius = row.area
			_aura_damage = _damage(row.damage)
			_aura_interval = _cooldown(row.cooldown)
			_aura_knockback = row.speed


func _damage(base: int) -> int:
	return maxi(1, UtilCore.floor_div(base * (_PERMILLE + _might + _upgrade_might), _PERMILLE))


func _cooldown(base: int) -> int:
	var cut: int = mini(_haste + _upgrade_haste, _PERMILLE - GameSetting.min_cooldown_permille())
	return maxi(_tick_ms, UtilCore.floor_div(base * (_PERMILLE - cut), _PERMILLE))


# --- waves


func _update_wave() -> void:
	var next: int = _wave_index + 1
	while next < _waves.size() and time_ms >= _waves[next].start:
		_wave_index = next
		_spawn_timer = 0
		var elite: int = _waves[next].elite
		if elite != 0 and _enemy_index.has(elite):
			_spawn(_enemy_index[elite], _waves[next].health_permille)
			events |= EVENT_ELITE
		next += 1
	if _wave_index < 0:
		return
	var wave: GameData.WaveRow = _waves[_wave_index]
	_spawn_timer -= _tick_ms
	if _spawn_timer > 0:
		return
	_spawn_timer = wave.spawn_interval
	for i: int in wave.spawn_count:
		if enemy_count >= mini(wave.max_alive, RunConstants.MAX_ENEMIES):
			return
		var pick: int = UtilCore.pick_weighted(_rng, _wave_weights[_wave_index])
		if pick < 0:
			return
		var enemy_id: int = wave.enemies[pick].enemy
		if _enemy_index.has(enemy_id):
			_spawn(_enemy_index[enemy_id], wave.health_permille)


## A new enemy of `kind` on the spawn ring around the player.
func _spawn(kind: int, health_permille: int) -> void:
	if enemy_count >= RunConstants.MAX_ENEMIES:
		return
	var i: int = enemy_count
	enemy_count += 1
	var row: GameData.EnemyRow = _enemy_rows[kind]
	var angle: float = UtilCore.next_float(_rng) * TAU
	var radius: float = GameSetting.spawn_radius()
	enemy_kind[i] = kind
	enemy_x[i] = player_x + cos(angle) * radius
	enemy_z[i] = player_z + sin(angle) * radius
	enemy_prev_x[i] = enemy_x[i]
	enemy_prev_z[i] = enemy_z[i]
	enemy_hp[i] = maxi(1, UtilCore.floor_div(row.health * health_permille, _PERMILLE))
	enemy_flash[i] = 0
	enemy_walk[i] = 0.0
	_enemy_contact[i] = 0
	_enemy_orbit[i] = 0
	_enemy_aura[i] = 0
	_enemy_kx[i] = 0.0
	_enemy_kz[i] = 0.0
	_enemy_uid[i] = _next_uid
	_next_uid += 1


# --- movement


func _move_player(move: Vector2) -> void:
	prev_player_x = player_x
	prev_player_z = player_z
	var length: float = move.length()
	if length <= 0.0:
		return
	var dir: Vector2 = move / maxf(length, 1.0)
	player_x += dir.x * move_speed * _dt
	player_z += dir.y * move_speed * _dt
	var unit: Vector2 = move.normalized()
	facing_x = unit.x
	facing_z = unit.y


func _move_enemies() -> void:
	var decay: float = maxf(0.0, 1.0 - GameSetting.knockback_decay() * _dt)
	var push: float = GameSetting.separation()
	var despawn: float = GameSetting.despawn_radius()
	for i: int in enemy_count:
		enemy_prev_x[i] = enemy_x[i]
		enemy_prev_z[i] = enemy_z[i]
		if enemy_hp[i] <= 0:
			continue
		var row: GameData.EnemyRow = _enemy_rows[enemy_kind[i]]
		var dx: float = player_x - enemy_x[i]
		var dz: float = player_z - enemy_z[i]
		var dist: float = sqrt(dx * dx + dz * dz)
		if dist > despawn:
			_relocate(i)
			continue
		var step_len: float = row.speed * _dt
		var mx: float = 0.0
		var mz: float = 0.0
		if dist > row.radius:
			mx = dx / dist * step_len
			mz = dz / dist * step_len
		var sep: Vector2 = _separation(i, row.radius)
		mx += sep.x * push + _enemy_kx[i] * _dt
		mz += sep.y * push + _enemy_kz[i] * _dt
		_enemy_kx[i] *= decay
		_enemy_kz[i] *= decay
		enemy_x[i] += mx
		enemy_z[i] += mz
		enemy_walk[i] += step_len
		_count_down(i)


func _count_down(i: int) -> void:
	_enemy_contact[i] -= _tick_ms
	_enemy_orbit[i] -= _tick_ms
	_enemy_aura[i] -= _tick_ms
	if enemy_flash[i] > 0:
		enemy_flash[i] -= _tick_ms


## Moves an enemy that fell too far behind back onto the spawn ring, ahead of where the player walks.
func _relocate(i: int) -> void:
	var angle: float = atan2(facing_z, facing_x) + (UtilCore.next_float(_rng) - 0.5) * PI
	var radius: float = GameSetting.spawn_radius()
	enemy_x[i] = player_x + cos(angle) * radius
	enemy_z[i] = player_z + sin(angle) * radius
	enemy_prev_x[i] = enemy_x[i]
	enemy_prev_z[i] = enemy_z[i]


## The push that keeps enemy `i` out of the bodies of its neighbors in the grid.
func _separation(i: int, radius: float) -> Vector2:
	var out: Vector2 = Vector2.ZERO
	var cx: int = _cell_of(enemy_x[i], _grid_x)
	var cz: int = _cell_of(enemy_z[i], _grid_z)
	for gz: int in range(maxi(cz - 1, 0), mini(cz + 2, RunConstants.GRID_CELLS)):
		for gx: int in range(maxi(cx - 1, 0), mini(cx + 2, RunConstants.GRID_CELLS)):
			var j: int = _cell_head[gz * RunConstants.GRID_CELLS + gx]
			while j >= 0:
				if j != i and enemy_hp[j] > 0:
					var dx: float = enemy_x[i] - enemy_x[j]
					var dz: float = enemy_z[i] - enemy_z[j]
					var reach: float = radius + _enemy_rows[enemy_kind[j]].radius
					var d2: float = dx * dx + dz * dz
					if d2 < reach * reach and d2 > 0.0:
						var d: float = sqrt(d2)
						out += Vector2(dx, dz) / d * (reach - d) * 0.5
				j = _cell_next[j]
	return out


func _build_grid() -> void:
	var half: float = float(RunConstants.GRID_CELLS) * RunConstants.GRID_CELL_SIZE * 0.5
	_grid_x = player_x - half
	_grid_z = player_z - half
	_cell_head.fill(-1)
	for i: int in enemy_count:
		var cx: int = _cell_of(enemy_x[i], _grid_x)
		var cz: int = _cell_of(enemy_z[i], _grid_z)
		var cell: int = cz * RunConstants.GRID_CELLS + cx
		_cell_next[i] = _cell_head[cell]
		_cell_head[cell] = i


func _cell_of(value: float, origin: float) -> int:
	return clampi(int(floorf((value - origin) / RunConstants.GRID_CELL_SIZE)), 0, RunConstants.GRID_CELLS - 1)


func _touch_player() -> void:
	if _invuln_ms > 0:
		_invuln_ms -= _tick_ms
		return
	var player_r: float = GameSetting.player_radius()
	for i: int in enemy_count:
		if enemy_hp[i] <= 0 or _enemy_contact[i] > 0:
			continue
		var row: GameData.EnemyRow = _enemy_rows[enemy_kind[i]]
		var dx: float = enemy_x[i] - player_x
		var dz: float = enemy_z[i] - player_z
		var reach: float = row.radius + player_r
		if dx * dx + dz * dz <= reach * reach:
			hp -= row.damage
			_enemy_contact[i] = GameSetting.contact_interval()
			_invuln_ms = GameSetting.hurt_invuln()
			events |= EVENT_HURT
			return


# --- weapons


func _tick_weapons() -> void:
	for slot: int in weapon_ids.size():
		var kind: int = _weapon_kind[slot]
		if kind == GameData.WeaponKind.ORBIT:
			_tick_orbit(_weapon_rows[slot])
			continue
		if kind == GameData.WeaponKind.AURA:
			_tick_aura()
			continue
		_weapon_timer[slot] -= _tick_ms
		if _weapon_timer[slot] > 0:
			continue
		var row: GameData.WeaponLevelRow = _weapon_rows[slot]
		var fired: bool = false
		match kind:
			GameData.WeaponKind.BOLT:
				fired = _fire_bolts(row)
			GameData.WeaponKind.AXE:
				fired = _fire_axes(row)
			GameData.WeaponKind.LIGHTNING:
				fired = _fire_lightning(row)
		if fired:
			_weapon_timer[slot] = _cooldown(row.cooldown)
			fired_kinds |= 1 << kind
		else:
			_weapon_timer[slot] = 0


func _fire_bolts(row: GameData.WeaponLevelRow) -> bool:
	var range_sq: float = GameSetting.bolt_range() * GameSetting.bolt_range()
	var found: int = 0
	for n: int in mini(row.count, _targets.size()):
		var best: int = -1
		var best_d: float = range_sq
		for i: int in enemy_count:
			if enemy_hp[i] <= 0 or _is_target(i, found):
				continue
			var dx: float = enemy_x[i] - player_x
			var dz: float = enemy_z[i] - player_z
			var d: float = dx * dx + dz * dz
			if d < best_d:
				best_d = d
				best = i
		if best < 0:
			break
		_targets[found] = best
		found += 1
	if found == 0:
		return false
	for n: int in row.count:
		var target: int = _targets[n % found]
		var dir: Vector2 = Vector2(enemy_x[target] - player_x, enemy_z[target] - player_z).normalized()
		_add_projectile(GameData.WeaponKind.BOLT, dir, row)
	return true


func _is_target(i: int, found: int) -> bool:
	for n: int in found:
		if _targets[n] == i:
			return true
	return false


func _fire_axes(row: GameData.WeaponLevelRow) -> bool:
	var base: float = atan2(facing_z, facing_x)
	var spread: float = GameSetting.axe_spread()
	for n: int in row.count:
		var angle: float = base + (float(n) - float(row.count - 1) * 0.5) * spread
		_add_projectile(GameData.WeaponKind.AXE, Vector2(cos(angle), sin(angle)), row)
	return true


func _add_projectile(kind: int, dir: Vector2, row: GameData.WeaponLevelRow) -> void:
	if proj_count >= RunConstants.MAX_PROJECTILES:
		return
	var p: int = proj_count
	proj_count += 1
	proj_kind[p] = kind
	proj_x[p] = player_x
	proj_z[p] = player_z
	proj_prev_x[p] = player_x
	proj_prev_z[p] = player_z
	proj_vx[p] = dir.x * row.speed
	proj_vz[p] = dir.y * row.speed
	_proj_life[p] = row.lifetime
	_proj_damage[p] = _damage(row.damage)
	_proj_pierce[p] = maxi(1, row.pierce)
	_proj_radius[p] = row.area
	_proj_hit_count[p] = 0


func _fire_lightning(row: GameData.WeaponLevelRow) -> bool:
	var range_sq: float = GameSetting.lightning_range() * GameSetting.lightning_range()
	var damage: int = _damage(row.damage)
	var struck: int = 0
	for n: int in row.count:
		var pick: int = -1
		var seen: int = 0
		for i: int in enemy_count:
			if enemy_hp[i] <= 0:
				continue
			var dx: float = enemy_x[i] - player_x
			var dz: float = enemy_z[i] - player_z
			if dx * dx + dz * dz > range_sq:
				continue
			seen += 1
			if UtilCore.range_int(_rng, 1, seen) == 1:
				pick = i
		if pick < 0:
			break
		var sx: float = enemy_x[pick]
		var sz: float = enemy_z[pick]
		_strike_event(sx, sz)
		_hit_area(sx, sz, row.area, damage, 0.0)
		struck += 1
	return struck > 0


func _tick_orbit(row: GameData.WeaponLevelRow) -> void:
	orbit_angle = fmod(orbit_angle + row.speed * _dt, TAU)
	var reach: float = GameSetting.blade_radius()
	for b: int in orbit_count:
		var angle: float = orbit_angle + TAU * float(b) / float(orbit_count)
		var bx: float = player_x + cos(angle) * orbit_radius
		var bz: float = player_z + sin(angle) * orbit_radius
		_for_each_near(bx, bz, reach, _hit_orbit_call)


func _hit_orbit(i: int) -> void:
	if _enemy_orbit[i] > 0:
		return
	_enemy_orbit[i] = _orbit_interval
	_damage_enemy(i, _orbit_damage, GameSetting.hit_knockback())


func _tick_aura() -> void:
	_for_each_near(player_x, player_z, aura_radius, _hit_aura_call)


func _hit_aura(i: int) -> void:
	if _enemy_aura[i] > 0:
		return
	_enemy_aura[i] = _aura_interval
	_damage_enemy(i, _aura_damage, _aura_knockback)


func _hit_area(x: float, z: float, radius: float, damage: int, knockback: float) -> void:
	for i: int in enemy_count:
		if enemy_hp[i] <= 0:
			continue
		var dx: float = enemy_x[i] - x
		var dz: float = enemy_z[i] - z
		var reach: float = radius + _enemy_rows[enemy_kind[i]].radius
		if dx * dx + dz * dz <= reach * reach:
			_damage_enemy(i, damage, knockback)


## Calls `hit` with each living enemy whose body touches the circle at (`x`, `z`) of `radius`.
func _for_each_near(x: float, z: float, radius: float, hit: Callable) -> void:
	var span: int = int(ceilf(radius / RunConstants.GRID_CELL_SIZE)) + 1
	var cx: int = _cell_of(x, _grid_x)
	var cz: int = _cell_of(z, _grid_z)
	for gz: int in range(maxi(cz - span, 0), mini(cz + span + 1, RunConstants.GRID_CELLS)):
		for gx: int in range(maxi(cx - span, 0), mini(cx + span + 1, RunConstants.GRID_CELLS)):
			var j: int = _cell_head[gz * RunConstants.GRID_CELLS + gx]
			while j >= 0:
				if enemy_hp[j] > 0:
					var dx: float = enemy_x[j] - x
					var dz: float = enemy_z[j] - z
					var reach: float = radius + _enemy_rows[enemy_kind[j]].radius
					if dx * dx + dz * dz <= reach * reach:
						hit.call(j)
				j = _cell_next[j]


func _move_projectiles() -> void:
	var p: int = 0
	while p < proj_count:
		proj_prev_x[p] = proj_x[p]
		proj_prev_z[p] = proj_z[p]
		proj_x[p] += proj_vx[p] * _dt
		proj_z[p] += proj_vz[p] * _dt
		_proj_life[p] -= _tick_ms
		_hit_with_projectile(p)
		if _proj_life[p] <= 0 or _proj_pierce[p] <= 0:
			_remove_projectile(p)
		else:
			p += 1


func _hit_with_projectile(p: int) -> void:
	var span: int = 1
	var cx: int = _cell_of(proj_x[p], _grid_x)
	var cz: int = _cell_of(proj_z[p], _grid_z)
	for gz: int in range(maxi(cz - span, 0), mini(cz + span + 1, RunConstants.GRID_CELLS)):
		for gx: int in range(maxi(cx - span, 0), mini(cx + span + 1, RunConstants.GRID_CELLS)):
			var j: int = _cell_head[gz * RunConstants.GRID_CELLS + gx]
			while j >= 0:
				if _proj_pierce[p] <= 0:
					return
				if enemy_hp[j] > 0 and not _projectile_hit_before(p, _enemy_uid[j]):
					var dx: float = enemy_x[j] - proj_x[p]
					var dz: float = enemy_z[j] - proj_z[p]
					var reach: float = _proj_radius[p] + _enemy_rows[enemy_kind[j]].radius
					if dx * dx + dz * dz <= reach * reach:
						_remember_hit(p, _enemy_uid[j])
						_proj_pierce[p] -= 1
						_damage_enemy(j, _proj_damage[p], GameSetting.hit_knockback())
				j = _cell_next[j]


func _projectile_hit_before(p: int, uid: int) -> bool:
	var base: int = p * RunConstants.PROJECTILE_HIT_SLOTS
	for n: int in mini(_proj_hit_count[p], RunConstants.PROJECTILE_HIT_SLOTS):
		if _proj_hits[base + n] == uid:
			return true
	return false


func _remember_hit(p: int, uid: int) -> void:
	var n: int = _proj_hit_count[p]
	if n < RunConstants.PROJECTILE_HIT_SLOTS:
		_proj_hits[p * RunConstants.PROJECTILE_HIT_SLOTS + n] = uid
		_proj_hit_count[p] = n + 1


func _remove_projectile(p: int) -> void:
	var last: int = proj_count - 1
	if p != last:
		proj_kind[p] = proj_kind[last]
		proj_x[p] = proj_x[last]
		proj_z[p] = proj_z[last]
		proj_prev_x[p] = proj_prev_x[last]
		proj_prev_z[p] = proj_prev_z[last]
		proj_vx[p] = proj_vx[last]
		proj_vz[p] = proj_vz[last]
		_proj_life[p] = _proj_life[last]
		_proj_damage[p] = _proj_damage[last]
		_proj_pierce[p] = _proj_pierce[last]
		_proj_radius[p] = _proj_radius[last]
		_proj_hit_count[p] = _proj_hit_count[last]
		var slots: int = RunConstants.PROJECTILE_HIT_SLOTS
		for n: int in slots:
			_proj_hits[p * slots + n] = _proj_hits[last * slots + n]
	proj_count = last


func _damage_enemy(i: int, damage: int, knockback: float) -> void:
	enemy_hp[i] -= damage
	enemy_flash[i] = GameSetting.hurt_flash()
	events |= EVENT_HIT
	if hit_count < RunConstants.MAX_HIT_EVENTS:
		hit_x[hit_count] = enemy_x[i]
		hit_z[hit_count] = enemy_z[i]
		hit_amount[hit_count] = damage
		hit_count += 1
	if knockback > 0.0:
		var row: GameData.EnemyRow = _enemy_rows[enemy_kind[i]]
		var away: Vector2 = Vector2(enemy_x[i] - player_x, enemy_z[i] - player_z).normalized()
		var power: float = knockback * GameSetting.knockback_decay() * float(_PERMILLE - row.knockback_resist) / RunConstants.PERMILLE_F
		_enemy_kx[i] = away.x * power
		_enemy_kz[i] = away.y * power
	if enemy_hp[i] <= 0:
		_on_enemy_died(i)


func _on_enemy_died(i: int) -> void:
	var row: GameData.EnemyRow = _enemy_rows[enemy_kind[i]]
	kills += 1
	events |= EVENT_KILL
	_death_event(enemy_x[i], enemy_z[i])
	_drop_gem(enemy_x[i], enemy_z[i], row.xp)
	if row.elite:
		_drop_pickup(enemy_x[i], enemy_z[i], PickupKind.CHEST)
	elif UtilCore.range_int(_rng, 1, _PERMILLE) <= GameSetting.heal_drop_permille():
		_drop_pickup(enemy_x[i], enemy_z[i], PickupKind.SOUP)


func _death_event(x: float, z: float) -> void:
	if death_count < RunConstants.MAX_DEATH_EVENTS:
		death_x[death_count] = x
		death_z[death_count] = z
		death_count += 1


func _strike_event(x: float, z: float) -> void:
	if strike_count < RunConstants.MAX_STRIKE_EVENTS:
		strike_x[strike_count] = x
		strike_z[strike_count] = z
		strike_count += 1


func _remove_dead() -> void:
	var i: int = 0
	while i < enemy_count:
		if enemy_hp[i] > 0:
			i += 1
			continue
		var last: int = enemy_count - 1
		if i != last:
			_copy_enemy(last, i)
		enemy_count = last


func _copy_enemy(from: int, to: int) -> void:
	enemy_kind[to] = enemy_kind[from]
	enemy_x[to] = enemy_x[from]
	enemy_z[to] = enemy_z[from]
	enemy_prev_x[to] = enemy_prev_x[from]
	enemy_prev_z[to] = enemy_prev_z[from]
	enemy_hp[to] = enemy_hp[from]
	enemy_flash[to] = enemy_flash[from]
	enemy_walk[to] = enemy_walk[from]
	_enemy_contact[to] = _enemy_contact[from]
	_enemy_orbit[to] = _enemy_orbit[from]
	_enemy_aura[to] = _enemy_aura[from]
	_enemy_kx[to] = _enemy_kx[from]
	_enemy_kz[to] = _enemy_kz[from]
	_enemy_uid[to] = _enemy_uid[from]


# --- pickups


func _drop_gem(x: float, z: float, value: int) -> void:
	if gem_count >= RunConstants.MAX_GEMS:
		var into: int = UtilCore.range_int(_rng, 0, gem_count - 1)
		gem_value[into] += value
		return
	gem_x[gem_count] = x
	gem_z[gem_count] = z
	gem_value[gem_count] = value
	gem_count += 1


func _drop_pickup(x: float, z: float, kind: PickupKind) -> void:
	if pickup_count >= RunConstants.MAX_PICKUPS:
		return
	pickup_x[pickup_count] = x
	pickup_z[pickup_count] = z
	pickup_kind[pickup_count] = kind
	pickup_count += 1


func _collect_gems() -> void:
	var pull_sq: float = pickup_radius * pickup_radius
	var take: float = GameSetting.player_radius() + GameSetting.gem_reach()
	var step_len: float = GameSetting.magnet_speed() * _dt
	var g: int = 0
	while g < gem_count:
		var dx: float = player_x - gem_x[g]
		var dz: float = player_z - gem_z[g]
		var d2: float = dx * dx + dz * dz
		if d2 <= take * take:
			_gain_xp(gem_value[g])
			events |= EVENT_GEM
			gem_count -= 1
			gem_x[g] = gem_x[gem_count]
			gem_z[g] = gem_z[gem_count]
			gem_value[g] = gem_value[gem_count]
			continue
		if d2 <= pull_sq:
			var d: float = sqrt(d2)
			var move: float = minf(step_len, d)
			gem_x[g] += dx / d * move
			gem_z[g] += dz / d * move
		g += 1


func _gain_xp(amount: int) -> void:
	xp += amount
	while xp >= xp_next:
		xp -= xp_next
		level += 1
		xp_next = RunWorld.xp_for_level(level)
		pending_levelups += 1
		events |= EVENT_LEVEL_UP


func _collect_pickups() -> void:
	var take: float = GameSetting.player_radius() + GameSetting.pickup_reach()
	var k: int = 0
	while k < pickup_count:
		var dx: float = player_x - pickup_x[k]
		var dz: float = player_z - pickup_z[k]
		if dx * dx + dz * dz > take * take:
			k += 1
			continue
		if pickup_kind[k] == PickupKind.CHEST:
			pending_chests += 1
			events |= EVENT_CHEST
		else:
			hp = mini(max_hp, hp + GameSetting.heal_amount())
			events |= EVENT_HEAL
		pickup_count -= 1
		pickup_x[k] = pickup_x[pickup_count]
		pickup_z[k] = pickup_z[pickup_count]
		pickup_kind[k] = pickup_kind[pickup_count]


func _reach_dawn() -> void:
	time_ms = _duration_ms
	for i: int in enemy_count:
		_death_event(enemy_x[i], enemy_z[i])
	enemy_count = 0
	proj_count = 0
	phase = Phase.DAWN
	events |= EVENT_DAWN
