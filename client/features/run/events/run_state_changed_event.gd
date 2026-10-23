class_name RunStateChangedEvent
extends EventBase
## Content event: a value the run HUD shows changed. The run scene publishes it with the whole HUD state.

var hp: int = 0
var max_hp: int = 0
var level: int = 1
var xp: int = 0
var xp_next: int = 1
var kills: int = 0
## Run gold the run would give if it ended now (`run.gold_reward`).
var gold: int = 0
## Run time survived in ms.
var time_ms: int = 0
var duration_ms: int = 0
## The run waits for the server before it starts.
var starting: bool = false
## The move hint shows: the player has not moved in this run yet.
var show_hint: bool = false
## Owned weapons and their levels, in the order taken.
var weapon_ids: PackedInt32Array = PackedInt32Array()
var weapon_levels: PackedInt32Array = PackedInt32Array()
## Owned passives and their levels, in the order taken.
var passive_ids: PackedInt32Array = PackedInt32Array()
var passive_levels: PackedInt32Array = PackedInt32Array()
## Health is at or below `[low_health_permille]` of the maximum.
var low_health: bool = false
## Shrine upgrades of the loadout and their levels, in `upgrade.order`.
var upgrade_ids: PackedInt32Array = PackedInt32Array()
var upgrade_levels: PackedInt32Array = PackedInt32Array()
