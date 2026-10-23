class_name RunLevelupParam
extends UIParam
## Param of the level-up popup: the cards, whether a chest opened it, the levels the run has now and what the run does
## with the pick.

var choices: Array[RunChoice] = []
var chest: bool = false
## Called with the picked `RunChoice` after the popup closed.
var on_pick: Callable = Callable()
