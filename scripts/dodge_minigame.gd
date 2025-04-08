extends Control

func _ready():
	print("Dodge minigame started!")

func _on_Timer_timeout():
	print("You survived!")
	
	# Stop spawning bullets (if you made a spawner node)
	if has_node("BulletSpawner"):
		$BulletSpawner.queue_free()
	
	# Optional: freeze player, show message, etc.
	var player = get_tree().get_nodes_in_group("player_soul")[0]
	player.set_physics_process(false)
