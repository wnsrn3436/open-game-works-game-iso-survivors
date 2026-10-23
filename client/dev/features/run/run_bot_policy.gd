class_name RunBotPolicy
extends RefCounted
## How a DEV bot player plays a run: it walks to the nearest gem in reach, keeps away from the enemies close to it, and
## picks level-up cards that raise an owned weapon first, then a new weapon, then a passive.


## The move direction on the ground for `world`.
static func direction(world: RunWorld) -> Vector2:
	var away: Vector2 = Vector2.ZERO
	var danger_sq: float = RunConstants.BOT_DANGER_RADIUS * RunConstants.BOT_DANGER_RADIUS
	for i: int in world.enemy_count:
		var offset: Vector2 = Vector2(world.player_x - world.enemy_x[i], world.player_z - world.enemy_z[i])
		var d2: float = offset.length_squared()
		if d2 < danger_sq and d2 > 0.0:
			away += offset / d2
	var toward: Vector2 = Vector2.ZERO
	var best: float = RunConstants.BOT_GEM_RADIUS * RunConstants.BOT_GEM_RADIUS
	for g: int in world.gem_count:
		var offset: Vector2 = Vector2(world.gem_x[g] - world.player_x, world.gem_z[g] - world.player_z)
		var d2: float = offset.length_squared()
		if d2 < best:
			best = d2
			toward = offset.normalized()
	var move: Vector2 = away.normalized() + toward
	if move.length_squared() <= 0.0:
		return Vector2.ZERO
	return move.normalized()


## Index of the card the bot picks among `choices`.
static func pick(choices: Array[RunChoice], world: RunWorld) -> int:
	var best: int = 0
	var best_score: int = -1
	for i: int in choices.size():
		var choice: RunChoice = choices[i]
		var score: int = 0
		if choice.kind == RunChoice.Kind.WEAPON:
			score = 2 if world.weapon_level_of(choice.id) > 0 else 1
			score = score * 2 + 1
		elif choice.kind == RunChoice.Kind.PASSIVE:
			score = 2
		if score > best_score:
			best_score = score
			best = i
	return best


## The keys to hold for the ground direction `move`: the screen axes of the isometric camera.
static func keys(move: Vector2) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	if move.length_squared() <= 0.0:
		return out
	var ground: Vector3 = Vector3(move.x, 0.0, move.y)
	var right: float = ground.dot(RunConstants.ISO_RIGHT)
	var up: float = ground.dot(RunConstants.ISO_UP)
	if up > RunConstants.BOT_KEY_THRESHOLD:
		out.append(RunBotPolicy.KEY_UP)
	elif up < -RunConstants.BOT_KEY_THRESHOLD:
		out.append(RunBotPolicy.KEY_DOWN)
	if right > RunConstants.BOT_KEY_THRESHOLD:
		out.append(RunBotPolicy.KEY_RIGHT)
	elif right < -RunConstants.BOT_KEY_THRESHOLD:
		out.append(RunBotPolicy.KEY_LEFT)
	return out


const KEY_UP: String = "W"
const KEY_DOWN: String = "S"
const KEY_LEFT: String = "A"
const KEY_RIGHT: String = "D"
