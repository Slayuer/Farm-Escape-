extends CharacterBody3D

## PLAYER MOVEMENT SCRIPT — Stage 1 of the MVP.
##
## Right now this only handles the most basic movement:
##   - The vegetable always runs forward on its own.
##   - The player can steer left/right.
##   - Basic gravity + a placeholder jump so it doesn't fall through the floor.
##
## Jump feel, stomping, lives, etc. are NOT here yet — those come in later stages.
## Keeping this script small and focused makes it easy to test "is running fun?"
## before adding anything else on top of it.

# --- Tunable variables ---
# @export makes these editable from the Godot Inspector panel without touching code.
@export var forward_speed: float = 6.0   # constant forward running speed
@export var steer_speed: float = 6.0     # how fast the vegetable can move sideways
@export var lane_limit: float = 4.0      # how far left/right of center it's allowed to go
@export var jump_velocity: float = 8.0   # upward speed applied on jump
@export var gravity: float = 20.0        # custom gravity (stronger = snappier jumps)

func _physics_process(delta: float) -> void:
	# --- Forward movement ---
	# In Godot's default 3D setup, "forward" is the -Z direction.
	velocity.z = -forward_speed

	# --- Left / right steering ---
	# get_axis returns -1.0 (full left) to 1.0 (full right) based on which keys are held.
	# "ui_left"/"ui_right" are Godot's built-in input actions (arrow keys by default),
	# so this works immediately without any extra setup.
	var steer_input := Input.get_axis("ui_left", "ui_right")
	velocity.x = steer_input * steer_speed

	# --- Gravity + placeholder jump ---
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("ui_accept"):
		# ui_accept = spacebar/enter by default. We'll give jump its own
		# dedicated input action once we start Stage 1's jump/stomp work.
		velocity.y = jump_velocity

	move_and_slide()

	# --- Keep the player within the lane, even mid-air ---
	# clamp() just means "don't let this number go below the min or above the max."
	position.x = clamp(position.x, -lane_limit, lane_limit)
