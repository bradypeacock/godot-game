extends Camera2D

@export var max_position_smoothing_speed : float = 5.0
@export var position_smoothing_acceleration : float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# FIXME: once player can get speedier, make position smoothing scale with player speed
func _process(delta: float) -> void:
	# Variable position smoothing. Start slow and ramp up
	if (get_screen_center_position().is_equal_approx(get_target_position())):
		position_smoothing_speed = 0
	if (position_smoothing_speed < max_position_smoothing_speed):
		position_smoothing_speed += position_smoothing_acceleration
