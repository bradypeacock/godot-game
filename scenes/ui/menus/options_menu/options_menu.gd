class_name OptionsMenu
extends Control

signal go_back

func _ready():
	set_process(false)

func _on_back_button_pressed() -> void:
	go_back.emit()
	set_process(false)
