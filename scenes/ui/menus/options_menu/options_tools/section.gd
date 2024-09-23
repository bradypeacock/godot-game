@tool
class_name Section
extends MarginContainer

@export var label : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SectionLabel.text = label
