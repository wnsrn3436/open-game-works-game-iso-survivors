class_name RunEffect
extends PoolObject
## A pooled one-shot effect of the run (hit spark and flash, death puff, lightning strike, level-up light, pickup
## sparkle, lantern flash, step dust). The borrower attaches it and calls `play`; it restarts its particles, plays its
## life tween preset on game time and goes back to the pool when the tween ends, so a paused run also holds its effects.

@export var particles: GPUParticles3D
## A second particle node that starts with `particles`, such as the bright flash of a hit; `null` when there is none.
@export var flash: GPUParticles3D
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
	if flash != null:
		flash.emitting = false
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
	if flash != null:
		flash.restart()
	_handle = TweenCore.play_preset(life_tween, SceneCore.current_scope(), root, _options)
	if _handle == 0:
		PoolCore.notify_finished(self)


func _on_life_end(reason: TweenCore.TweenEndReason) -> void:
	if _handle != 0 and reason == TweenCore.TweenEndReason.COMPLETED:
		_handle = 0
		PoolCore.notify_finished(self)
