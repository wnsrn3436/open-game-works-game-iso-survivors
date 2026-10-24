class_name CommonButtonText
extends RefCounted
## Button text is drawn bold by an outline in the text color. A button that turns disabled draws its text in the
## disabled color, so its outline follows that color.


## Sets the text outline color of `button` to the text color of its current state.
static func match_outline(button: Button) -> void:
	var color_name: StringName = &"font_disabled_color" if button.disabled else &"font_color"
	button.add_theme_color_override(&"font_outline_color", button.get_theme_color(color_name))
