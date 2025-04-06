extends CharacterBody2D

@export var speed: float = 200
@export var heart_size: Vector2 = Vector2(8, 8)  # Size of the heart sprite

var battle_area: Control  # ColorRect or any Control node used as the border

func _physics_process(delta):

	# Movement input
	var input_vector = Vector2(
		Input.get_action_raw_strength("dodgeMG_right") - Input.get_action_raw_strength("dodgeMG_left"),
		Input.get_action_raw_strength("dodgeMG_down") - Input.get_action_raw_strength("dodgeMG_up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()
