extends CharacterBody2D

@export var speed = 400
@export var gravity = 1500  # Adjust this to make the player get pulled to the ground faster
@export var jump_strength = 400  # Adjust this to control how high the jump is
@onready var animation = $AnimationPlayer
var last_direction = "right"

func get_input():
	var input_direction = Input.get_axis("left", "right")
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

func _physics_process(_delta):
	get_input()
	move_and_slide() 

func die():
	if last_direction == "right":
		animation.play("dead_right")
	else:
		animation.play("dead_left")
	set_physics_process(false)  # Stop movement
