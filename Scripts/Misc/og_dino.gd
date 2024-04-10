extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Random movement variables
var random_direction = 0
var flip_scale_speed = 5 # Speed of flipping
var target_scale_x = 2 # Target X scale for flipping effect

func _ready():
	randomize() # Initialize random number generator
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Random movement logic
	if randi() % 60 == 0: # Approximately once per second, adjust this for more/less frequent changes
		random_direction = randf_range(-1, 1)
		# Determine the flip direction
		target_scale_x = -2 if random_direction < 0 else 2;

	velocity.x = move_toward(velocity.x, random_direction * SPEED, SPEED * delta)

	# Flip the sprite smoothly
	var sprite = $AnimatedSprite2D # Adjust this path to your sprite node
	sprite.scale.x = move_toward(sprite.scale.x, target_scale_x, flip_scale_speed * delta)

	move_and_slide()
