extends Node2D

@export var slime_scene: PackedScene
@export var spawn_count: int = 3
@export var spawn_area: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 600)) # adjust this to fit your stage

func _ready():
	for i in range(spawn_count):
		spawn_slime()

func spawn_slime():
	if slime_scene:
		var slime = slime_scene.instantiate()
		print("Slime scene is working")
		var rand_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		var rand_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		
		slime.global_position = Vector2(rand_x, rand_y)
		
		get_parent().add_child(slime)
	else:
		print("❌ Slime scene not assigned!")
