class_name LobbyConstants
extends RefCounted
## Drawing values of the camp feature. Gameplay values are in `game_setting` and the shrine tables.

## Tint of the buy button of a shrine step the gold does not cover; that step also shows the "not enough gold" line.
const SHORT_TINT: Color = Color(0.55, 0.52, 0.56, 1.0) # color of the drawing only; no rule reads it
## Size of one level pip of a shrine row.
const PIP_SIZE: Vector2 = Vector2(30.0, 30.0) # size of the drawing only; no rule reads it
## Frames a DEV command waits for a purchase answer.
const DEV_WAIT_FRAMES: int = 600 # DEV command time limit; no game rule reads it
