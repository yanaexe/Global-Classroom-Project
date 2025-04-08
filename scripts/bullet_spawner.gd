extends Node2D

@export var bullet_scene: PackedScene = preload("res://scenes/dodge_bullet.tscn")
@export var spawn_interval: float = 0.5  # Seconds between shots
@onready var area := get_node("../Border/BattleArea")


var spawn_timer := 0.0

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_bullet()
		spawn_timer = spawn_interval

func spawn_bullet():
	# Get global rectangle of the area (for Control nodes like ColorRect)
	var rect = area.get_global_rect()

	# Generate a random position inside that rectangle
	var spawn_pos = Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.y, rect.position.y + rect.size.y)
	)

	# Create the bullet
	var bullet = bullet_scene.instantiate()
	bullet.global_position = spawn_pos
	bullet.battle_area = rect # Pass the battle area to the bullet
	get_tree().get_root().add_child(bullet)

	# Find the player
	var player = get_tree().get_nodes_in_group("player_soul")[0]

	# Aim the bullet at the player
	var dir = player.global_position - spawn_pos
	if dir.length() < 2:
		dir = Vector2.DOWN
	bullet.direction = dir.normalized()
