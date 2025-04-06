extends Control

@export var hearts: Array[AnimatedSprite2D]
@onready var player : CharacterBody2D = get_tree().get_nodes_in_group("player")[0]


func _ready():
	if player:
		player.connect("damaged",Callable(self, "on_player_damaged"))
		update_hearts(player.health)

func on_player_damaged(amount):
	update_hearts(player.health)
	
func update_hearts(current_health):
	var full_health = 6
	var damage_taken = full_health - current_health
	print("Damage taken:", damage_taken)
	
	for i in range(hearts.size()):
		var heart_damage = clamp(damage_taken - i * 2, 0, 2)
		hearts[i].stop()
		hearts[i].frame = heart_damage
		print("Setting heart", i, "to frame", heart_damage)
