extends CharacterBody2D

@export var speed = 400
@export var gravity = 100 #adjust this to make the player get pulled to the ground faster
@onready var animation = $AnimationPlayer
var last_direction = "right"


func get_input():
	velocity.y += gravity #this constantly makes the character always pull down to ground
	var input_direction = Input.get_axis("left", "right")
	velocity = Vector2(input_direction * speed, 0)
	

	# animation handling
	if input_direction > 0:
		velocity.y += gravity
		animation.play("walk_right")
		last_direction = "right"
	elif input_direction < 0:
		velocity.y += gravity
		animation.play("walk_left")
		last_direction = "left"
	else:
		animation.play("idle_" + last_direction)
		velocity.y= gravity
		
	# Jumping 
	if Input.is_action_just_pressed("jump") :
		if is_on_floor():
			velocity.y = -5000 
			animation.play("jump_" + last_direction) #Plays jump animation
			print("Jump Triggered!")  # Debugging

func _physics_process(_delta):
	get_input()
	move_and_slide()
	
func die():
	if last_direction == "right":
		animation.play("dead_right")
	else :
		animation.play("dead_left")
	set_physics_process(false)  # Stop movement
