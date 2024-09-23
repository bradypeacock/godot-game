class_name PauseMenu
extends CanvasLayer

@export_file("*.tscn") var title_screen_scene_path : String

func unpause() -> void:
	%AnimationPlayer.play("Unpause")
	get_tree().paused = false

func pause() -> void:
	%AnimationPlayer.play("Pause")
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		if %OptionsMenu.visible: _on_options_menu_go_back()
		elif (get_tree().paused): unpause()
		else: pause()

func _on_resume_game_button_pressed() -> void:
	unpause()

func _on_options_button_pressed() -> void:
	%PauseTitledMenu.visible = false
	%OptionsMenu.set_process(true)
	%OptionsMenu.visible = true

func _on_quit_to_main_button_pressed() -> void:
	unpause()
	get_tree().change_scene_to_file(title_screen_scene_path)

func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()

func _on_options_menu_go_back() -> void:
	%PauseTitledMenu.visible = true
	%OptionsMenu.visible = false
	# Give focus to the options button so that the player is where they were in the menu before
	%OptionsButton.grab_focus()
