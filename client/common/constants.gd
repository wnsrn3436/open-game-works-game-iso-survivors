class_name CommonConstants
extends RefCounted
## Drawing values the shared content code uses. Gameplay values are in `game_setting`.

## Permille of a whole.
const PERMILLE: int = 1000 # unit conversion, not a tunable value
const PERMILLE_F: float = 1000.0 # unit conversion, not a tunable value
## Permille per percent, to show permille values as percent.
const PERMILLE_PER_PERCENT: int = 10 # unit conversion, not a tunable value
## Text color of the terms hint while an agree toggle is off (lantern gold highlight) and once both are on (bone).
const TERMS_HINT_WAITING_COLOR: Color = Color(0.788, 0.635, 0.153, 1.0) # color of the drawing only; no rule reads it
const TERMS_HINT_DONE_COLOR: Color = Color(0.91, 0.882, 0.816, 1.0) # color of the drawing only; no rule reads it
