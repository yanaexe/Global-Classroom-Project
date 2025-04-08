extends CharacterBody2D

@export var max_health = 100
var current_health = max_health

@onready var timer = $Timer
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player") # Assumes player is in the "player" group
	timer.start()  # Start the timer to trigger attacks at intervals

func _on_Timer_timeout():
	attack_player()

func attack_player():
	# Example attack logic: Reduce player's health
	if player and player.has_method("take_damage"):  # Check if player can take damage
		player.take_damage(10)  # Deal 10 damage to the player every time the timer triggers
		print("Boss attacks player!")
	
	# You can also add other attack effects here, like animations or visual effects
	# Example: play animation or spawn an effect like a blast

func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	# Boss dies when health reaches 0
	queue_free()  # Remove boss from the scene
