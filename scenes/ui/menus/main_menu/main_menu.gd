class_name MainMenu
extends Control

@export_file("*.tscn") var game_start_scene_path : String

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(game_start_scene_path)

func _on_options_button_pressed() -> void:
	%MainTitledMenu.visible = false
	%OptionsMenu.set_process(true)
	%OptionsMenu.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_options_menu_go_back() -> void:
	%MainTitledMenu.visible = true
	%OptionsMenu.visible = false
	# Give focus to the options button so that the player is where they were in the menu before
	%OptionsButton.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		if %OptionsMenu.visible: _on_options_menu_go_back()
