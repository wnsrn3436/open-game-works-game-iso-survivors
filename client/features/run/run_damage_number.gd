class_name RunDamageNumber
extends PoolObject
## A pooled damage number over a hit enemy. The borrower attaches it and calls `show_amount`; it pops, rises and fades
## with its tween preset on game time and goes back to the pool when the tween ends.

@export var label: Label3D

var _options: TweenOptions = null
var _handle: int = 0
var _done: Callable = Callable()


func on_borrow() -> void:
	_handle = 0


func on_return() -> void:
	var handle: int = _handle
	_handle = 0
	if handle != 0:
		TweenCore.stop(handle)
	label.modulate.a = 1.0


## Shows `amount` at `at`; `done` is called when the number is gone.
func show_amount(at: Vector3, amount: int, done: Callable) -> void:
	if _options == null:
		_options = TweenOptions.new()
		_options.time_basis = TweenCore.TimeBasis.GAME_TIME
		_options.callback = _on_end
	_done = done
	(self as Node as Node3D).position = at
	label.text = str(amount)
	_handle = TweenCore.play_preset(ResourceKey.TWEEN__RUN__DAMAGE_NUMBER, SceneCore.current_scope(), label, _options)
	if _handle == 0:
		_finish()


func _on_end(reason: TweenCore.TweenEndReason) -> void:
	if _handle != 0 and reason == TweenCore.TweenEndReason.COMPLETED:
		_finish()


func _finish() -> void:
	_handle = 0
	if _done.is_valid():
		_done.call()
	PoolCore.notify_finished(self)
