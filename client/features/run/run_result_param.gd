class_name RunResultParam
extends UIParam
## Param of the result panel: what the finished run did and what the buttons do.

var dawn: bool = false
## Whether the server counted the run. An unsaved run shows no gold and no best line.
var saved: bool = false
var survived_ms: int = 0
var kills: int = 0
var level: int = 1
## Gold the server granted, from the `ItemChange` of the finish response.
var gold: int = 0
var new_best: bool = false
var on_again: Callable = Callable()
var on_lobby: Callable = Callable()
