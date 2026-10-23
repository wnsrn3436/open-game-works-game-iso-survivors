class_name RunPausePopup
extends UIPopup
## Pause popup over the run: continue, or give up the run. Giving up ends the run as a fall, so the gold of the run so
## far is still granted. A back input continues.

@export var title_label: Label
@export var note_label: Label
@export var resume_button: Button
@export var give_up_button: Button
@export var resume_click: UIButton
@export var give_up_click: UIButton

var _param: RunPauseParam = null


func accepts_param(param: UIParam) -> bool:
	return param is RunPauseParam


func prepare() -> bool:
	_param = popup_param as RunPauseParam
	LocalizationCore.bind_text(title_label, ReservedString.pause_title())
	LocalizationCore.bind_text(note_label, ReservedString.pause_give_up_note())
	LocalizationCore.bind_text(resume_button, ReservedString.pause_resume())
	LocalizationCore.bind_text(give_up_button, ReservedString.pause_give_up())
	resume_click.set_on_click(_on_resume)
	give_up_click.set_on_click(_on_give_up)
	return true


func on_back() -> void:
	_on_resume()


func _on_resume() -> void:
	UICore.close_popup(self, _param.on_resume)


func _on_give_up() -> void:
	UICore.close_popup(self, _param.on_give_up)
