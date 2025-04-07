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
	var player = get_tree().get_nodes_in_group("player_soul")[0]
	var area = get_node("/root/DodgeMinigame/BattleBox/Border/BattleArea")
	
	var global_top_left = area.get_global_transform_with_canvas().origin
	var size = area.get_size()  # ColorRect's size in world coords

	var margin = 0
	var min_x = global_top_left.x + margin
	var max_x = global_top_left.x + size.x - margin
	var min_y = global_top_left.y + margin
	var max_y = global_top_left.y + size.y - margin

	global_position = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
	print("🔫 FIXED Spawner Pos:", global_position)

	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	get_tree().get_root().add_child(bullet)

	var dir = player.global_position - bullet.global_position
	if dir.length() < 2:
		dir = Vector2.DOWN
	bullet.direction = dir.normalized()
