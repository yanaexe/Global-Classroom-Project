extends CharacterBody2D

@export var speed = 300
@export var gravity = 1500  # Adjust this to make the player get pulled to the ground faster
@export var jump_strength = 400  
@export var dash_speed = 600  # Speed boost during dash
@export var dash_duration = 0.2  # Dash time in seconds
@export var dash_cooldown = 1.0  # Cooldown before dashing again

@onready var animation = $AnimationPlayer
var last_direction = "right"
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0

func get_input():
	var input_direction = Input.get_axis("left", "right")

	# Apply normal movement if not dashing
	if not is_dashing:
		velocity.x = input_direction * speed

	if not is_on_floor():
		velocity.y += gravity * get_process_delta_time()  # Apply gravity only when not on the floor
	else:
		velocity.y = 0  # Reset vertical velocity to 0 when on the ground

	# Animation handling
	if input_direction > 0:
		animation.play("walk_right")
		last_direction = "right"
	elif input_direction < 0:
		animation.play("walk_left")
		last_direction = "left"
	else:
		animation.play("idle_" + last_direction)

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_strength  # Apply jump force
		animation.play("jump_" + last_direction)
	
	#Moving down
	if is_on_floor()==false and Input.is_action_just_pressed("down"):
		velocity.y = +jump_strength
		 	
	# Dash Mechanic
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		velocity.x = dash_speed if last_direction == "right" else -dash_speed
		animation.play("dash_" + last_direction)

func _physics_process(delta):
	# Handle dashing
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false  # End dash

	# Cooldown countdown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	get_input()
	move_and_slide() 

func die():
	if last_direction == "right":
		animation.play("dead_right")
	else:
		animation.play("dead_left")
	set_physics_process(false)  # Stop movement
