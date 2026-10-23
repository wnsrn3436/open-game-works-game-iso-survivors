class_name RunView
extends Node3D
## Draws a `RunWorld` in the isometric 3D field: the player model with its lantern, the horde, projectiles, orbit
## blades, the aura, gems, chests and soups as multimeshes, the field props around the player, and the pooled effects
## and damage numbers of the event buffers. Enemies and projectiles are drawn between the last two ticks; the player
## is drawn ahead of the last tick with the held move, so it answers the input without a tick of delay. The player
## model glows blood red while it is invulnerable after a hit and tips over when it falls. Lantern bolts are drawn
## stretched along their flight as streaks of light, the lantern flashes when it fires, and dust puffs at the feet
## when the move starts, turns or stops. The damage numbers of a frame are the biggest hits, and a number starts only
## where no living number stands, so close numbers do not cover each other. Gems glow a deeper blue than the
## enemies and props.

@export var player: Node3D
@export var player_model: Node3D
## The hero model under `player_model`; the fall tween tips it over.
@export var player_body: Node3D
@export var aura: Node3D
@export var ground: Node3D
@export var effects: Node3D
## The lantern light of the player; the fire flash starts at it.
@export var lantern: Node3D

var _scope: Scope = null
var _enemy_meshes: Array[MultiMeshInstance3D] = []
var _enemy_bases: Array[Transform3D] = []
var _enemy_counts: PackedInt32Array = PackedInt32Array()
var _bolts: MultiMeshInstance3D = null
var _bolt_base: Transform3D = Transform3D.IDENTITY
var _axes: MultiMeshInstance3D = null
var _axe_base: Transform3D = Transform3D.IDENTITY
var _blades: MultiMeshInstance3D = null
var _blade_base: Transform3D = Transform3D.IDENTITY
var _gems: MultiMeshInstance3D = null
var _gem_base: Transform3D = Transform3D.IDENTITY
var _chests: MultiMeshInstance3D = null
var _chest_base: Transform3D = Transform3D.IDENTITY
var _soups: MultiMeshInstance3D = null
var _soup_base: Transform3D = Transform3D.IDENTITY
var _props: Array[MultiMeshInstance3D] = []
var _prop_bases: Array[Transform3D] = []
var _prop_chunk: Vector2i = RunConstants.NO_CHUNK
var _numbers: int = 0
var _spin: float = 0.0
var _number_done: Callable = Callable()
## Game time of the view in ms, to know which damage number spots are still taken.
var _clock_ms: int = 0
## How long a damage number lives: the length of its tween preset.
var _number_life_ms: int = 0
var _spot_x: PackedFloat32Array = PackedFloat32Array()
var _spot_z: PackedFloat32Array = PackedFloat32Array()
var _spot_until: PackedInt64Array = PackedInt64Array()
var _spot_next: int = 0
## Hit events of the frame already tried for a damage number.
var _hit_tried: PackedByteArray = PackedByteArray()
var _player_meshes: Array[MeshInstance3D] = []
var _hurt_overlay: StandardMaterial3D = null
var _hurt_shown: bool = false


## The mesh of a model and its ground transform.
class ModelInfo extends RefCounted:
	var mesh: Mesh = null
	var base: Transform3D = Transform3D.IDENTITY


func _ready() -> void:
	_number_done = _on_number_done


## Model resource keys the view instances; the scene preloads them.
static func model_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray([
		ResourceKey.MODEL__XP_GEM, ResourceKey.MODEL__CHEST, ResourceKey.MODEL__HEAL_SOUP,
		ResourceKey.MODEL__PROP_GRAVESTONE, ResourceKey.MODEL__PROP_ROCK, ResourceKey.MODEL__PROP_LANTERN_POST])
	for row: GameData.EnemyRow in GameData.EnemyTable.all_rows():
		keys.append(row.model)
	for row: GameData.WeaponRow in GameData.WeaponTable.all_rows():
		keys.append(row.model)
	return keys


## Pooled prefabs of the view; the scene prefills them.
static func pooled_keys() -> PackedStringArray:
	return PackedStringArray([
		ResourceKey.PREFAB__RUN__DAMAGE_NUMBER, ResourceKey.PREFAB__RUN__HIT_EFFECT, ResourceKey.PREFAB__RUN__DEATH_EFFECT,
		ResourceKey.PREFAB__RUN__STRIKE_EFFECT, ResourceKey.PREFAB__RUN__LEVEL_EFFECT, ResourceKey.PREFAB__RUN__PICKUP_EFFECT,
		ResourceKey.PREFAB__RUN__FIRE_EFFECT, ResourceKey.PREFAB__RUN__STEP_EFFECT])


## Builds the multimeshes from the loaded models. Called once in `on_prepare` of the scene.
## Enemy kinds follow the `enemy` table order, as `RunWorld` numbers them.
func setup(scope: Scope) -> void:
	_scope = scope
	for row: GameData.EnemyRow in GameData.EnemyTable.all_rows():
		var base: Transform3D = _base_of(row.model)
		_enemy_bases.append(Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * row.scale), Vector3.ZERO) * base)
		_enemy_meshes.append(_make_multimesh(row.model, RunConstants.MAX_ENEMIES, true))
	_enemy_counts.resize(_enemy_meshes.size())
	var bolt_key: String = _weapon_model(GameData.WeaponKind.BOLT)
	_bolts = _make_multimesh(bolt_key, RunConstants.MAX_PROJECTILES, false)
	_bolt_base = _base_of(bolt_key)
	var axe_key: String = _weapon_model(GameData.WeaponKind.AXE)
	_axes = _make_multimesh(axe_key, RunConstants.MAX_PROJECTILES, false)
	_axe_base = _base_of(axe_key)
	var blade_key: String = _weapon_model(GameData.WeaponKind.ORBIT)
	_blades = _make_multimesh(blade_key, RunConstants.MAX_WEAPONS * RunConstants.MAX_WEAPONS, false)
	_blade_base = _base_of(blade_key)
	_gems = _make_multimesh(ResourceKey.MODEL__XP_GEM, RunConstants.MAX_GEMS, false)
	_gems.multimesh.mesh = RunView._dimmed_mesh(_gems.multimesh.mesh, RunConstants.GEM_EMISSION_SCALE)
	_gem_base = _base_of(ResourceKey.MODEL__XP_GEM)
	_chests = _make_multimesh(ResourceKey.MODEL__CHEST, RunConstants.MAX_PICKUPS, false)
	_chest_base = _base_of(ResourceKey.MODEL__CHEST)
	_soups = _make_multimesh(ResourceKey.MODEL__HEAL_SOUP, RunConstants.MAX_PICKUPS, false)
	_soup_base = _base_of(ResourceKey.MODEL__HEAL_SOUP)
	var chunks: int = RunConstants.PROP_CHUNKS * RunConstants.PROP_CHUNKS * RunConstants.PROPS_PER_CHUNK
	for key: String in [ResourceKey.MODEL__PROP_GRAVESTONE, ResourceKey.MODEL__PROP_ROCK, ResourceKey.MODEL__PROP_LANTERN_POST]:
		_props.append(_make_multimesh(key, chunks, true))
		_prop_bases.append(_base_of(key))
	var aura_key: String = _weapon_model(GameData.WeaponKind.AURA)
	_attach_model(aura, aura_key)
	aura.visible = false
	RunView._collect_meshes(player_body, _player_meshes)
	_hurt_overlay = StandardMaterial3D.new()
	_hurt_overlay.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_hurt_overlay.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_hurt_overlay.albedo_color = RunConstants.PLAYER_HURT_COLOR
	_number_life_ms = RunView._length_of(ResourceCore.get_loaded(ResourceKey.TWEEN__RUN__DAMAGE_NUMBER,
		TweenCore.get_preset_kind(), _scope) as TweenDefinition)
	_spot_x.resize(RunConstants.MAX_DAMAGE_NUMBERS)
	_spot_z.resize(RunConstants.MAX_DAMAGE_NUMBERS)
	_spot_until.resize(RunConstants.MAX_DAMAGE_NUMBERS)
	_spot_until.fill(0)
	_hit_tried.resize(RunConstants.MAX_HIT_EVENTS)


## Draws `world` `weight` of a tick after its last tick, with the held move `move` for the player.
func draw(world: RunWorld, weight: float, move: Vector2, frame_ms: int) -> void:
	var ahead: float = world.move_speed * float(world.tick_ms()) / RunConstants.MS_PER_SECOND_F * weight
	var dir: Vector2 = move.limit_length(1.0)
	var px: float = world.player_x + dir.x * ahead
	var pz: float = world.player_z + dir.y * ahead
	if world.phase != RunWorld.Phase.PLAYING:
		px = world.player_x
		pz = world.player_z
	player.position = Vector3(px, 0.0, pz)
	player_model.rotation.y = atan2(world.facing_x, world.facing_z)
	_draw_hurt(world.is_hurt() and world.phase == RunWorld.Phase.PLAYING)
	ground.position = Vector3(px, 0.0, pz)
	_spin += float(frame_ms) / RunConstants.MS_PER_SECOND_F
	_clock_ms += frame_ms
	_draw_enemies(world, weight)
	_draw_projectiles(world, weight)
	_draw_blades(world)
	_draw_gems(world)
	_draw_pickups(world)
	aura.visible = world.aura_radius > 0.0
	aura.scale = Vector3.ONE * world.aura_radius
	_place_props(px, pz)


## Starts the effects and damage numbers of the event buffers of `world`.
func play_events(world: RunWorld) -> void:
	for i: int in mini(world.hit_count, RunConstants.HIT_EFFECTS_PER_FRAME):
		var at: Vector3 = Vector3(world.hit_x[i], RunConstants.NUMBER_HEIGHT, world.hit_z[i])
		_play_effect(ResourceKey.PREFAB__RUN__HIT_EFFECT, at)
	_play_numbers(world)
	if world.fired_kinds & (1 << GameData.WeaponKind.BOLT):
		_play_effect(ResourceKey.PREFAB__RUN__FIRE_EFFECT, lantern.global_position)
	for i: int in mini(world.death_count, RunConstants.DEATH_EFFECTS_PER_FRAME):
		_play_effect(ResourceKey.PREFAB__RUN__DEATH_EFFECT, Vector3(world.death_x[i], 0.0, world.death_z[i]))
	for i: int in world.strike_count:
		_play_effect(ResourceKey.PREFAB__RUN__STRIKE_EFFECT, Vector3(world.strike_x[i], 0.0, world.strike_z[i]))
	if world.events & RunWorld.EVENT_LEVEL_UP:
		_play_effect(ResourceKey.PREFAB__RUN__LEVEL_EFFECT, player.position)
	if world.events & (RunWorld.EVENT_GEM | RunWorld.EVENT_HEAL | RunWorld.EVENT_CHEST):
		_play_effect(ResourceKey.PREFAB__RUN__PICKUP_EFFECT, player.position)


## Tips the hero model over: the fall of the player.
func play_fall() -> void:
	_draw_hurt(false)
	TweenCore.play_preset(ResourceKey.TWEEN__RUN__PLAYER_FALL, _scope, player_body)


## Dust at the feet of the player: the move started, turned or stopped.
func play_step() -> void:
	_play_effect(ResourceKey.PREFAB__RUN__STEP_EFFECT, player.position)


## Damage numbers of the biggest hits of the frame, each where no living number stands.
func _play_numbers(world: RunWorld) -> void:
	_hit_tried.fill(0)
	var started: int = 0
	for attempt: int in mini(world.hit_count, RunConstants.NUMBER_TRIES_PER_FRAME):
		if started >= RunConstants.DAMAGE_NUMBERS_PER_FRAME or _numbers >= RunConstants.MAX_DAMAGE_NUMBERS:
			return
		var best: int = -1
		for i: int in world.hit_count:
			if _hit_tried[i] == 0 and (best < 0 or world.hit_amount[i] > world.hit_amount[best]):
				best = i
		_hit_tried[best] = 1
		if not _spot_free(world.hit_x[best], world.hit_z[best]):
			continue
		var number: RunDamageNumber = _borrow(ResourceKey.PREFAB__RUN__DAMAGE_NUMBER) as RunDamageNumber
		if number == null:
			return
		_take_spot(world.hit_x[best], world.hit_z[best])
		_numbers += 1
		started += 1
		number.show_amount(Vector3(world.hit_x[best], RunConstants.NUMBER_HEIGHT, world.hit_z[best]), world.hit_amount[best],
			_number_done)


## Whether no living damage number stands within `[NUMBER_GAP]` of (`x`, `z`).
func _spot_free(x: float, z: float) -> bool:
	var gap_sq: float = RunConstants.NUMBER_GAP * RunConstants.NUMBER_GAP
	for s: int in _spot_until.size():
		if _spot_until[s] > _clock_ms:
			var dx: float = _spot_x[s] - x
			var dz: float = _spot_z[s] - z
			if dx * dx + dz * dz < gap_sq:
				return false
	return true


func _take_spot(x: float, z: float) -> void:
	_spot_x[_spot_next] = x
	_spot_z[_spot_next] = z
	_spot_until[_spot_next] = _clock_ms + _number_life_ms
	_spot_next = (_spot_next + 1) % _spot_until.size()


## The length in ms of `definition`: the end of its latest change, over its steps one after another.
static func _length_of(definition: TweenDefinition) -> int:
	if definition == null:
		return 0
	var total: int = 0
	for step: TweenStep in definition.steps:
		var longest: int = 0
		for change: TweenChange in step.changes:
			longest = maxi(longest, change.delay + change.duration)
		total += longest
	return total


## Puts the blood red glow on the player model while `hurt`.
func _draw_hurt(hurt: bool) -> void:
	if hurt == _hurt_shown:
		return
	_hurt_shown = hurt
	for mesh: MeshInstance3D in _player_meshes:
		mesh.material_overlay = _hurt_overlay if hurt else null


func _on_number_done() -> void:
	_numbers = maxi(0, _numbers - 1)


func _play_effect(key: String, at: Vector3) -> void:
	var effect: RunEffect = _borrow(key) as RunEffect
	if effect != null:
		effect.play(at)


## A borrowed pool object attached under the effect layer, or `null`.
func _borrow(key: String) -> Node:
	var handle: Vector4i = PoolCore.borrow(key, _scope)
	if not PoolCore.is_valid(handle):
		return null
	var node: Node = PoolCore.get_instance(handle)
	if node.get_parent() == null:
		effects.add_child(node)
	return node


func _draw_enemies(world: RunWorld, weight: float) -> void:
	_enemy_counts.fill(0)
	for i: int in world.enemy_count:
		var kind: int = world.enemy_kind[i]
		var x: float = lerpf(world.enemy_prev_x[i], world.enemy_x[i], weight)
		var z: float = lerpf(world.enemy_prev_z[i], world.enemy_z[i], weight)
		var yaw: float = atan2(player.position.x - x, player.position.z - z)
		var bob: float = absf(sin(world.enemy_walk[i] * RunConstants.ENEMY_BOB_RATE)) * RunConstants.ENEMY_BOB
		var xform: Transform3D = Transform3D(Basis(Vector3.UP, yaw), Vector3(x, bob, z)) * _enemy_bases[kind]
		var at: int = _enemy_counts[kind]
		var mm: MultiMesh = _enemy_meshes[kind].multimesh
		mm.set_instance_transform(at, xform)
		mm.set_instance_color(at, RunConstants.ENEMY_FLASH_COLOR if world.enemy_flash[i] > 0 else RunConstants.ENEMY_COLOR)
		_enemy_counts[kind] = at + 1
	for kind: int in _enemy_meshes.size():
		_enemy_meshes[kind].multimesh.visible_instance_count = _enemy_counts[kind]


func _draw_projectiles(world: RunWorld, weight: float) -> void:
	var bolts: int = 0
	var axes: int = 0
	var bolt_mm: MultiMesh = _bolts.multimesh
	var axe_mm: MultiMesh = _axes.multimesh
	for p: int in world.proj_count:
		var at: Vector3 = Vector3(lerpf(world.proj_prev_x[p], world.proj_x[p], weight), RunConstants.PROJECTILE_HEIGHT,
			lerpf(world.proj_prev_z[p], world.proj_z[p], weight))
		if world.proj_kind[p] == GameData.WeaponKind.AXE:
			var spin: Basis = Basis(Vector3.UP, _spin * RunConstants.AXE_SPIN)
			axe_mm.set_instance_transform(axes, Transform3D(spin, at) * _axe_base)
			axes += 1
		else:
			var yaw: float = atan2(world.proj_vx[p], world.proj_vz[p])
			var streak: Basis = Basis(Vector3.UP, yaw) * Basis.from_scale(RunConstants.BOLT_STRETCH)
			bolt_mm.set_instance_transform(bolts, Transform3D(streak, at) * _bolt_base)
			bolts += 1
	bolt_mm.visible_instance_count = bolts
	axe_mm.visible_instance_count = axes


func _draw_blades(world: RunWorld) -> void:
	var mm: MultiMesh = _blades.multimesh
	var count: int = mini(world.orbit_count, mm.instance_count)
	for b: int in count:
		var angle: float = world.orbit_angle + TAU * float(b) / float(world.orbit_count)
		var at: Vector3 = player.position + Vector3(cos(angle) * world.orbit_radius, RunConstants.PROJECTILE_HEIGHT,
			sin(angle) * world.orbit_radius)
		mm.set_instance_transform(b, Transform3D(Basis(Vector3.UP, -angle), at) * _blade_base)
	mm.visible_instance_count = count


func _draw_gems(world: RunWorld) -> void:
	var mm: MultiMesh = _gems.multimesh
	var spin: Basis = Basis(Vector3.UP, _spin * RunConstants.GEM_SPIN)
	for g: int in world.gem_count:
		var size: float = 1.0 + float(mini(world.gem_value[g], RunConstants.GEM_SIZE_CAP)) * RunConstants.GEM_SIZE_STEP
		var at: Vector3 = Vector3(world.gem_x[g], RunConstants.GEM_HEIGHT, world.gem_z[g])
		mm.set_instance_transform(g, Transform3D(spin.scaled(Vector3.ONE * size), at) * _gem_base)
	mm.visible_instance_count = world.gem_count


func _draw_pickups(world: RunWorld) -> void:
	var chests: int = 0
	var soups: int = 0
	for k: int in world.pickup_count:
		var at: Vector3 = Vector3(world.pickup_x[k], 0.0, world.pickup_z[k])
		if world.pickup_kind[k] == RunWorld.PickupKind.CHEST:
			_chests.multimesh.set_instance_transform(chests, Transform3D(Basis.IDENTITY, at) * _chest_base)
			chests += 1
		else:
			_soups.multimesh.set_instance_transform(soups, Transform3D(Basis.IDENTITY, at) * _soup_base)
			soups += 1
	_chests.multimesh.visible_instance_count = chests
	_soups.multimesh.visible_instance_count = soups


## Places the field props of the chunks around (`x`, `z`) when the player entered another chunk. The props of a chunk
## always land on the same places, so a walk back meets the same field.
func _place_props(x: float, z: float) -> void:
	var chunk: Vector2i = Vector2i(int(floorf(x / RunConstants.PROP_CHUNK)), int(floorf(z / RunConstants.PROP_CHUNK)))
	if chunk == _prop_chunk:
		return
	_prop_chunk = chunk
	var counts: PackedInt32Array = PackedInt32Array()
	counts.resize(_props.size())
	var half: int = UtilCore.floor_div(RunConstants.PROP_CHUNKS, 2)
	for cz: int in range(chunk.y - half, chunk.y + half + 1):
		for cx: int in range(chunk.x - half, chunk.x + half + 1):
			for n: int in RunConstants.PROPS_PER_CHUNK:
				var h: int = RunView._hash(cx, cz, n)
				var kind: int = RunView._prop_kind(h % RunConstants.PROP_WEIGHT_TOTAL)
				var fx: float = float(h % RunConstants.PROP_HASH_MOD) / float(RunConstants.PROP_HASH_MOD)
				var fz: float = float(UtilCore.floor_div(h, RunConstants.PROP_HASH_MOD) % RunConstants.PROP_HASH_MOD) / float(RunConstants.PROP_HASH_MOD)
				var at: Vector3 = Vector3((float(cx) + fx) * RunConstants.PROP_CHUNK, 0.0, (float(cz) + fz) * RunConstants.PROP_CHUNK)
				var yaw: float = fx * TAU
				_props[kind].multimesh.set_instance_transform(counts[kind], Transform3D(Basis(Vector3.UP, yaw), at) * _prop_bases[kind])
				_props[kind].multimesh.set_instance_color(counts[kind], RunConstants.PROP_COLOR)
				counts[kind] += 1
	for kind: int in _props.size():
		_props[kind].multimesh.visible_instance_count = counts[kind]


## The prop kind of a hash slot: gravestones most, then rocks, lantern posts least, so few tall props stand around.
static func _prop_kind(slot: int) -> int:
	if slot < RunConstants.PROP_WEIGHT_GRAVE:
		return 0
	if slot < RunConstants.PROP_WEIGHT_GRAVE + RunConstants.PROP_WEIGHT_ROCK:
		return 1
	return 2


static func _hash(cx: int, cz: int, n: int) -> int:
	var h: int = (cx * RunConstants.PROP_HASH_X) ^ (cz * RunConstants.PROP_HASH_Z) ^ (n * RunConstants.PROP_HASH_MOD)
	h = (h ^ (h >> RunConstants.PROP_HASH_SHIFT)) * RunConstants.PROP_HASH_X
	return absi(h ^ (h >> RunConstants.PROP_HASH_SHIFT))


func _weapon_model(kind: GameData.WeaponKind) -> String:
	for row: GameData.WeaponRow in GameData.WeaponTable.all_rows():
		if row.kind == kind:
			return row.model
	return ""


## A multimesh node of the first mesh of model `key`, `count` instances, none visible.
func _make_multimesh(key: String, count: int, colors: bool) -> MultiMeshInstance3D:
	var node: MultiMeshInstance3D = MultiMeshInstance3D.new()
	var mm: MultiMesh = MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = colors
	mm.mesh = _tinted_mesh(_mesh_of(key), colors)
	mm.instance_count = count
	mm.visible_instance_count = 0
	node.multimesh = mm
	add_child(node)
	return node


## A copy of `mesh` whose surface materials glow `scale` times as bright, so a glow keeps its color under the bloom.
static func _dimmed_mesh(mesh: Mesh, scale: float) -> Mesh:
	if mesh == null:
		return mesh
	var copy: Mesh = mesh.duplicate() as Mesh
	for s: int in copy.get_surface_count():
		var material: BaseMaterial3D = copy.surface_get_material(s) as BaseMaterial3D
		if material != null:
			material = material.duplicate() as BaseMaterial3D
			material.emission_energy_multiplier *= scale
			copy.surface_set_material(s, material)
	return copy


## A copy of `mesh` whose surface materials take the instance color as albedo tint when `tint`.
static func _tinted_mesh(mesh: Mesh, tint: bool) -> Mesh:
	if mesh == null or not tint:
		return mesh
	var copy: Mesh = mesh.duplicate() as Mesh
	for s: int in copy.get_surface_count():
		var material: BaseMaterial3D = copy.surface_get_material(s) as BaseMaterial3D
		if material == null:
			material = StandardMaterial3D.new()
		else:
			material = material.duplicate() as BaseMaterial3D
		material.vertex_color_use_as_albedo = true
		copy.surface_set_material(s, material)
	return copy


func _mesh_of(key: String) -> Mesh:
	return _model_of(key).mesh


func _base_of(key: String) -> Transform3D:
	return _model_of(key).base


## The first mesh of model `key` and the transform that puts it on the ground with the node transforms above it.
func _model_of(key: String) -> ModelInfo:
	var info: ModelInfo = ModelInfo.new()
	var scene: PackedScene = ResourceCore.get_loaded(key, ResourceCore.BaseKind.PACKED_SCENE, _scope) as PackedScene
	if scene == null:
		return info
	var root: Node = scene.instantiate()
	var found: MeshInstance3D = RunView._first_mesh(root)
	if found != null and found.mesh != null:
		var xform: Transform3D = found.transform
		var parent: Node = found.get_parent()
		while parent != null and parent != root:
			if parent is Node3D:
				xform = (parent as Node3D).transform * xform
			parent = parent.get_parent()
		var box: AABB = xform * found.mesh.get_aabb()
		info.mesh = found.mesh
		info.base = Transform3D(Basis.IDENTITY, Vector3(0.0, -box.position.y, 0.0)) * xform
	root.free()
	return info


static func _collect_meshes(node: Node, out: Array[MeshInstance3D]) -> void:
	if node == null:
		return
	if node is MeshInstance3D:
		out.append(node as MeshInstance3D)
	for child: Node in node.get_children():
		RunView._collect_meshes(child, out)


static func _first_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node as MeshInstance3D
	for child: Node in node.get_children():
		var found: MeshInstance3D = RunView._first_mesh(child)
		if found != null:
			return found
	return null


func _attach_model(parent_node: Node3D, key: String) -> void:
	var scene: PackedScene = ResourceCore.get_loaded(key, ResourceCore.BaseKind.PACKED_SCENE, _scope) as PackedScene
	if scene != null:
		parent_node.add_child(scene.instantiate())
