class_name RunPauseParam
extends UIParam
## Param of the pause popup: what the run does after the popup closed.

var on_resume: Callable = Callable()
var on_give_up: Callable = Callable()
