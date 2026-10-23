class_name LobbyConstants
extends RefCounted
## Drawing values of the camp feature. Gameplay values are in `game_setting` and the shrine tables.

## Cost text of a shrine step the gold covers (bone) and one it does not cover (blood red); a short step also shows
## the "not enough gold" line.
const AFFORDABLE_COLOR: Color = Color(0.91, 0.882, 0.816, 1.0) # color of the drawing only; no rule reads it
const SHORT_COLOR: Color = Color(0.85, 0.32, 0.36, 1.0) # color of the drawing only; no rule reads it
## Frames a DEV command waits for a purchase answer.
const DEV_WAIT_FRAMES: int = 600 # DEV command time limit; no game rule reads it
