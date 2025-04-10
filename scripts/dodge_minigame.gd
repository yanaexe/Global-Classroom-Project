extends Control

signal minigame_won
signal minigame_lost

@onready var bullet_spawner = get_node("BattleBox/BulletSpawner")
@onready var timer = $Timer

func _ready():
	visible = false  # hidden by default
	timer.stop()
	bullet_spawner.set_process(false)
	print("Dodge minigame ready!")

func start_minigame():
	print("Minigame started!")
	visible = true
	
	var camera := get_viewport().get_camera_2d()
	if camera:
		var camera_screen_pos := get_viewport().get_camera_2d().get_screen_center_position()
		position = camera_screen_pos - size / 2
		print("Centered at camera screen center:", position)
	else:
		print("⚠️ No camera found")

	timer.start()
	bullet_spawner.set_process(true)

func _on_Timer_timeout():
	print("You survived!")

	# Stop spawning bullets
	if bullet_spawner:
		print("I'm here!")
		bullet_spawner.set_process(false)
		

	print("I didn't go through bullet spawner")

	# Signal the player won
	emit_signal("minigame_won")

	# Hide the minigame UI
	visible = false
