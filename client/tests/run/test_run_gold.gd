extends UnitTestCase
## The run gold shared formula `run.gold_reward` gives the value of every case of its shared fixture.

const _CASE: String = "\\{\"name\": \"([^\"]+)\", \"input\": \\{\"survived_ms\": (\\d+), \"kills\": (\\d+), \"dawn\": (true|false), \"greed_permille\": (\\d+), \"interval_ms\": (\\d+), \"per_interval\": (\\d+), \"per_kill_permille\": (\\d+), \"dawn_bonus\": (\\d+)\\}, \"expected\": (\\d+)\\}"


func test_every_case_of_the_shared_fixture() -> void:
	var text: String = UnitTestCore.read_shared_fixture("run.gold_reward")
	var pattern: RegEx = RegEx.create_from_string(_CASE)
	var matches: Array[RegExMatch] = pattern.search_all(text)
	assert_gt(matches.size(), 0, "the fixture has cases")
	assert_eq(matches.size(), text.count("\"name\""), "every case of the fixture is read")
	for found: RegExMatch in matches:
		var gold: int = RunGold.gold_reward(found.get_string(2).to_int(), found.get_string(3).to_int(),
			found.get_string(4) == "true", found.get_string(5).to_int(), found.get_string(6).to_int(),
			found.get_string(7).to_int(), found.get_string(8).to_int(), found.get_string(9).to_int())
		assert_eq(gold, found.get_string(10).to_int(), found.get_string(1))
