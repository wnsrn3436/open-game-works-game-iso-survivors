class_name RunEffect
extends PoolObject
## A pooled one-shot effect of the run (hit spark, death puff, lightning strike, level-up light, pickup sparkle). The
## borrower attaches it and calls `play`; it restarts its particles, plays its life tween preset on game time and goes
## back to the pool when the tween ends, so a paused run also holds its effects.

@export var particles: GPUParticles3D
## Tween preset that sets how long the effect lives and how its root changes meanwhile.
@export var life_tween: String = ""

var _options: TweenOptions = null
var _handle: int = 0


func on_borrow() -> void:
	_handle = 0


func on_return() -> void:
	var handle: int = _handle
	_handle = 0
	if handle != 0:
		TweenCore.stop(handle)
	if particles != null:
		particles.emitting = false
	(self as Node as Node3D).scale = Vector3.ONE


## Starts the effect at `at` on the ground plane.
func play(at: Vector3) -> void:
	if _options == null:
		_options = TweenOptions.new()
		_options.time_basis = TweenCore.TimeBasis.GAME_TIME
		_options.callback = _on_life_end
	var root: Node3D = self as Node as Node3D
	root.position = at
	root.scale = Vector3.ONE
	if particles != null:
		particles.restart()
	_handle = TweenCore.play_preset(life_tween, SceneCore.current_scope(), root, _options)
	if _handle == 0:
		PoolCore.notify_finished(self)


func _on_life_end(reason: TweenCore.TweenEndReason) -> void:
	if _handle != 0 and reason == TweenCore.TweenEndReason.COMPLETED:
		_handle = 0
		PoolCore.notify_finished(self)
