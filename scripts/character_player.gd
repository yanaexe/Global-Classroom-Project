extends CharacterBody2D

@export var speed = 400  # Normal movement speed
@export var jump_force = -400  # Jump power
@export var gravity = 1200  # Gravity pulling player down
@export var dash_speed = 900  # Speed during dash
@export var dash_time = 0.2  # Dash duration
@export var dash_cooldown = 0.5  # Time before dashing again

var is_dashing = false
var can_dash = true
var dash_timer = 0.0
var cooldown_timer = 0.0
var saved_velocity = Vector2.ZERO  # Saves velocity before dashing

func _ready():
	# Load the saved player position when the game starts
	SaveLoad.load_game()
	position = Vector2(SaveLoad.save_data["player_position"][0], SaveLoad.save_data["player_position"][1])

func get_input():
	var input_direction = Input.get_axis("left", "right")

	# Dash mechanic (Fully Fixed)
	if Input.is_action_just_pressed("dash") and can_dash and input_direction != 0:
		is_dashing = true
		can_dash = false
		dash_timer = dash_time
		cooldown_timer = dash_cooldown
		saved_velocity = velocity  # Store movement before dashing
		velocity.x = input_direction * dash_speed  # Dash in the correct direction

	if is_dashing:
		dash_timer -= get_process_delta_time()
		if dash_timer <= 0:
			is_dashing = false
			velocity.x = saved_velocity.x  # Restore previous horizontal movement

	# Handle dash cooldown
	if not can_dash:
		cooldown_timer -= get_process_delta_time()
		if cooldown_timer <= 0:
			can_dash = true  # Allow dashing again

	# Normal movement (only apply if not dashing)
	if not is_dashing:
		velocity.x = input_direction * speed

	# Jump mechanic (Fixed)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

func _physics_process(delta):
	velocity.y += gravity * delta  # Apply gravity
	get_input()
	move_and_slide()

func _process(_delta):
	# Save & Load System 
	if Input.is_action_just_pressed("save"):
		SaveLoad.update_player_position(position)
		SaveLoad.save_game()
		print("✅ Player position saved:", position)

	if Input.is_action_just_pressed("load"):
		SaveLoad.load_game()
		position = Vector2(SaveLoad.save_data["player_position"][0], SaveLoad.save_data["player_position"][1])
		print("✅ Player position loaded:", position)
