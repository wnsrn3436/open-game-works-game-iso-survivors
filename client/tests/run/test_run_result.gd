extends UnitTestCase
## The result panel title: dawn when the run reached dawn, the give-up title when the player gave up from the pause
## popup, and the fall title otherwise.


func param(dawn: bool, gave_up: bool) -> RunResultParam:
	var out: RunResultParam = RunResultParam.new()
	out.dawn = dawn
	out.gave_up = gave_up
	return out


func test_dawn_has_the_dawn_title() -> void:
	assert_eq(RunResultPanel.title_key(param(true, false)), ReservedString.result_dawn())


func test_a_give_up_has_the_give_up_title() -> void:
	assert_eq(RunResultPanel.title_key(param(false, true)), ReservedString.result_gave_up())


func test_a_fall_has_the_fall_title() -> void:
	assert_eq(RunResultPanel.title_key(param(false, false)), ReservedString.result_fallen())
