class_name RunSaveData
extends RefCounted
## The state of a run as two number lists, as `RunWorld.save_state` writes it and `CommonRunSave` keeps it.

var ints: PackedInt64Array = PackedInt64Array()
var floats: PackedFloat64Array = PackedFloat64Array()
