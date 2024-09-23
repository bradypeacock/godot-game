#FIXME: duplicate for Range, Tab, etc.
class_name MenuButtonControl
extends Button

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if self.is_hovered():
			self.grab_focus()
