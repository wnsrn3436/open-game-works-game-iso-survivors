class_name CommonRunRecord
extends RefCounted
## The run record of the user, read from the `RunRecordUserState` cache. Every value is 0 before the first finished
## run.


static func runs() -> int:
	var state: GameContract.RunRecordUserState = _state()
	return 0 if state == null else state.runs


static func dawns() -> int:
	var state: GameContract.RunRecordUserState = _state()
	return 0 if state == null else state.dawns


static func best_survived_ms() -> int:
	var state: GameContract.RunRecordUserState = _state()
	return 0 if state == null else state.best_survived_ms


static func best_kills() -> int:
	var state: GameContract.RunRecordUserState = _state()
	return 0 if state == null else state.best_kills


static func _state() -> GameContract.RunRecordUserState:
	return UserStateCore.get_single(GameContract.RunRecordUserState) as GameContract.RunRecordUserState
