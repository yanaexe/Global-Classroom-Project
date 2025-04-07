extends Node2D

@export var bullet_scene: PackedScene = preload("res://scenes/dodge_bullet.tscn")
@export var spawn_interval: float = 0.5  # Seconds between shots

var spawn_timer := 0.0

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_bullet()
		spawn_timer = spawn_interval

func spawn_bullet():
	var bullet = bullet_scene.instantiate()
	
	var player = get_tree().get_nodes_in_group("player_soul")[0]

	# Convert ColorRect UI to world space
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var battle_area = get_node("/root/DodgeMinigame/BattleBox/Border/BattleArea")
	var top_left: Vector2 = canvas_transform.affine_inverse() * battle_area.get_screen_position()
	var size: Vector2 = Vector2(36, 36)

	# Spawn just above the box, with slight randomness
	var spawn_x = randf_range(top_left.x + 4, top_left.x + size.x - 4)
	var spawn_y = top_left.y - 10  # Just above the box

	var spawn_pos = Vector2(spawn_x, spawn_y)
	bullet.global_position = spawn_pos
	bullet.direction = (player.global_position - spawn_pos).normalized()

	get_tree().get_root().add_child(bullet)
