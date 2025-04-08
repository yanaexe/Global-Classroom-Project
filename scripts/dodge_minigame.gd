extends Control

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
	
	var screen_size = get_viewport_rect().size
	position = screen_size / 2 - size / 2
	print("Centered at:", position)
	
	timer.start()
	bullet_spawner.set_process(true)
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
