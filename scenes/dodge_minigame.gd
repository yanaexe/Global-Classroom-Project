extends Control

func _ready():
	print("Dodge minigame started!")

func _on_SurvivalTimer_timeout():
	print("You survived!")
	
	# Stop spawning bullets (if you made a spawner node)
	if has_node("BulletSpawner"):
		$BulletSpawner.queue_free()
	
	# Optional: freeze player, show message, etc.
	get_node("PlayerSoul").set_physics_process(false)



func _on_timer_timeout() -> void:
	pass # Replace with function body.
