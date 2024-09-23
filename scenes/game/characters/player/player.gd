extends CharacterBody2D

@export_group("Kinematics")
@export var speed : float = 100
# Default jump height of 4 tiles
# FIXME: Define a TILE_SIZE and change to "TILE_SIZE * 4"
@export var jump_velocity : float = -256
@export var max_jumps : int = 2
var jumps : int = 0
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_group("Stats")
@export var max_health : int = 110
var health : float = max_health
@export var health_regen_per_second : float = 1
@export var damage : float = 12
@export var armor : float = 0

@export_group("Status Effects")
var invincible : bool = false
var in_combat : bool = false

@export_group("Resources")
var level : int = 1
var xp : int = 0
var xp_to_next_level : int = 50
var gold : int = 20

@export_group("Nodes")
@onready var coyote_timer : Timer = %CoyoteTimer
@onready var animated_sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var camera : Camera2D = %Camera2D

func _physics_process(delta):
	# Horizontal movement code. First, get the player's input.
	var direction = Input.get_axis(&"move_left", &"move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# FIXME: use state machine?
	if direction == 0:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Run")

	velocity.x = speed * direction

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()

	# Check for jumping. is_on_floor() must be called after movement code.
	# Reset the player's jumps if they are grounded.
	if is_on_floor():
		jumps = max_jumps
		coyote_timer.stop()
	else:
		# Otherwise, if the player is falling and did not jump, start coyote time.
		# FIXME: this code could be in the "FALLING" state of a state machine
		if velocity.y > 0 and jumps == max_jumps:
			if coyote_timer.is_stopped():
				coyote_timer.start()

	# If we have a jump stored, allow the player to jump on action press and decrement jumps.
	if jumps > 0 and Input.is_action_just_pressed(&"jump"):
		# If a coyote timer was in action, stop it. Congrats!
		coyote_timer.stop()
		jumps -= 1
		velocity.y = jump_velocity

	 # If the player releases the jump key before we are halfway through the jump, cap it at
	 # halfway for a shorter jump. This gives variable jump height.
	if Input.is_action_just_released(&"jump"):
		if velocity.y < jump_velocity / 2:
			velocity.y = jump_velocity / 2

func _on_coyote_timer_timeout() -> void:
	jumps -= 1
