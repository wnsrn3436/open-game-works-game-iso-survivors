class_name RunChoice
extends RefCounted
## One card of a level-up or chest pick: a new or higher weapon, a new or higher passive, or the heal when nothing is
## left to raise.

enum Kind { WEAPON, PASSIVE, HEAL }

var kind: Kind = Kind.HEAL
## `weapon` or `passive` ID value; 0 for the heal.
var id: int = 0
## The level the pick gives: 1 for a new weapon or passive.
var level: int = 0


static func of(choice_kind: Kind, choice_id: int, choice_level: int) -> RunChoice:
	var out: RunChoice = RunChoice.new()
	out.kind = choice_kind
	out.id = choice_id
	out.level = choice_level
	return out
