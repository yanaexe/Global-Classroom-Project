extends Control

func _ready():
	print("Dodge minigame started!")

func _on_Timer_timeout():
	print("You survived!")
	var bullet_spawner = get_node("BattleBox/BulletSpawner")
	# Stop spawning bullets (if you made a spawner node)
	if bullet_spawner:
		print("I'n here!")
		bullet_spawner.set_process(false)
		bullet_spawner.queue_free()
	
	print("I Didn't go through bullet spawner")
	# Optional: freeze player, show message, etc.
	var player = get_tree().get_nodes_in_group("player_soul")[0]
	player.set_physics_process(false)
