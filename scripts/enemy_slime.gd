extends CharacterBody2D

@export var speed: float = 100
@export var gravity: float = 500

var player: CharacterBody2D

func _process(delta):
	# Keep trying to find the player if not yet assigned
	player = get_node("../character_player")


func _physics_process(delta):
	if player == null:
		return  # Player not found yet, skip this frame

	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * speed
	velocity.y += gravity * delta

	move_and_slide()

	# Play idle animation while moving
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = velocity.x > 0
