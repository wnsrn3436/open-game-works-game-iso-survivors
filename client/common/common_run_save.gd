class_name CommonRunSave
extends RefCounted
## The saved state of a run in progress, in the user local data: the play session, its start time, the loadout and the
## simulation state as two number lists. A run that the app left (restart, quit) resumes from it while its play
## session can still finish on the server. Losing it loses only that run: the server grants nothing before the run
## finishes.

const _SESSION: String = "common.run_session"
const _STARTED_AT: String = "common.run_started_at"
const _LOADOUT: String = "common.run_loadout"
const _INTS: String = "common.run_ints"
const _FLOATS: String = "common.run_floats"
const _FILE: LocalDataCore.FileKind = LocalDataCore.FileKind.USER


static func save(session_id: String, started_at: int, loadout: PackedByteArray, ints: PackedInt64Array,
		floats: PackedFloat64Array) -> void:
	if not LocalDataCore.is_loaded(_FILE):
		return
	LocalDataCore.set_value_string(_FILE, _SESSION, session_id)
	LocalDataCore.set_value_int(_FILE, _STARTED_AT, started_at)
	LocalDataCore.set_value_string(_FILE, _LOADOUT, Marshalls.raw_to_base64(loadout))
	LocalDataCore.set_array_int(_FILE, _INTS, ints)
	LocalDataCore.set_array_float(_FILE, _FLOATS, floats)


static func clear() -> void:
	if not LocalDataCore.is_loaded(_FILE):
		return
	for key: String in [_SESSION, _STARTED_AT, _LOADOUT, _INTS, _FLOATS]:
		LocalDataCore.remove_value(_FILE, key)


static func session_id() -> String:
	if not LocalDataCore.is_loaded(_FILE):
		return ""
	return LocalDataCore.get_value_string(_FILE, _SESSION, "")


static func started_at() -> int:
	return LocalDataCore.get_value_int(_FILE, _STARTED_AT, 0) if LocalDataCore.is_loaded(_FILE) else 0


static func loadout() -> PackedByteArray:
	if not LocalDataCore.is_loaded(_FILE):
		return PackedByteArray()
	return Marshalls.base64_to_raw(LocalDataCore.get_value_string(_FILE, _LOADOUT, ""))


static func ints() -> PackedInt64Array:
	return LocalDataCore.get_array_int(_FILE, _INTS) if LocalDataCore.is_loaded(_FILE) else PackedInt64Array()


static func floats() -> PackedFloat64Array:
	return LocalDataCore.get_array_float(_FILE, _FLOATS) if LocalDataCore.is_loaded(_FILE) else PackedFloat64Array()


## Whether a saved run can resume: it has a play session whose `max_duration` of the run mode has not passed.
static func is_resumable() -> bool:
	if session_id().is_empty():
		return false
	var mode: GameData.PlaySessionModeRow = GameData.PlaySessionModeTable.get_row(ReservedId.run_mode())
	return TimeCore.is_before_end(started_at() + mode.max_duration)
