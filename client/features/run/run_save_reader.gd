class_name RunSaveReader
extends RefCounted
## Reads the two number lists of a saved run in order. Reading past the end gives 0 and turns `ok` off.

var ok: bool = true
var _ints: PackedInt64Array = PackedInt64Array()
var _floats: PackedFloat64Array = PackedFloat64Array()
var _int_at: int = 0
var _float_at: int = 0


func _init(ints: PackedInt64Array, floats: PackedFloat64Array) -> void:
	_ints = ints
	_floats = floats


func next_int() -> int:
	if _int_at >= _ints.size():
		ok = false
		return 0
	_int_at += 1
	return _ints[_int_at - 1]


func next_float() -> float:
	if _float_at >= _floats.size():
		ok = false
		return 0.0
	_float_at += 1
	return _floats[_float_at - 1]
