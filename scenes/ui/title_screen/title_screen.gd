extends Control

@export var show_version : bool = true
@export var version_prefix : String = "v"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the version string.
	%VersionLabel.set_text(version_prefix + ProjectSettings.get_setting("application/config/version"))
