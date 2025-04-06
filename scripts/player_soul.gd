extends CharacterBody2D

@export var speed: float = 200
@export var heart_size: Vector2 = Vector2(8, 8)  # Size of the heart sprite

var battle_area: Control  # ColorRect or any Control node used as the border

func _ready():
	# Get the BattleArea node (adjust path if needed)
	battle_area = get_node("/root/DodgeMinigame/BattleBox/Border/BattleArea")

func _process(delta):

	# Movement input
	var input_vector = Vector2(
		Input.get_action_raw_strength("dodgeMG_right") - Input.get_action_raw_strength("dodgeMG_left"),
		Input.get_action_raw_strength("dodgeMG_down") - Input.get_action_raw_strength("dodgeMG_up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()

	# Convert UI screen position to world space using Godot 4.2+ syntax
	var screen_pos := battle_area.get_screen_position()
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var top_left: Vector2 = canvas_transform.affine_inverse() * screen_pos
	var size: Vector2 = battle_area.size
	var bottom_right: Vector2 = top_left + size

	# Clamp inside the box, accounting for the heart's size
	var min_x = top_left.x + heart_size.x / 2
	var max_x = bottom_right.x - heart_size.x / 2
	var min_y = top_left.y + heart_size.y / 2
	var max_y = bottom_right.y - heart_size.y / 2
	
	print("Top-left:", top_left, " | Bottom-right:", bottom_right)
	print("PlayerSoul global_position:", global_position)


	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)
