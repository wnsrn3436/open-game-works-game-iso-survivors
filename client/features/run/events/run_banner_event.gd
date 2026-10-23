class_name RunBannerEvent
extends EventBase
## Content event: the HUD shows a banner. `text` is the translation key of its text.

var text: String = ""
## A gold notice (the shrine blessing at the run start) instead of a red warning.
var notice: bool = false
