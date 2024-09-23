extends VBoxContainer

# FIXME: make tab bar more dynamic
# FIXME: ScrollContainer can only have one child. What's the solution here?
#var tab_bar : TabBar

func _on_option_tabs_tab_selected(tab: int) -> void:
	if tab == 0:
		show()
	else:
		hide()
