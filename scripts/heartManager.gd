extends Control

@export var hearts: Array[AnimatedSprite2D]
var player: CharacterBody2D

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		player.connect("damaged", Callable(self, "on_player_damaged"))
		update_hearts(player.health)
	else:
		print("❌ No player found in 'player' group.")

	
func on_player_damaged(amount):
	update_hearts(player.health)
	
func update_hearts(current_health):
	var full_health = 6
	var damage_taken = full_health - current_health
	print("Damage taken:", damage_taken)
	print("Health:", full_health - damage_taken)
	
	for i in range(hearts.size()):
		var heart_damage = clamp(damage_taken - i * 2, 0, 2)
		hearts[i].stop()
		hearts[i].frame = heart_damage
