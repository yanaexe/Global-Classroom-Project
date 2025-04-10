extends CharacterBody2D

@export var max_health = 100
@export var speed = 100
var current_health = max_health

@onready var timer = $Timer
var player = null

func _ready():
	set_meta("boss_attack", true)
	player = get_tree().get_first_node_in_group("player")
	timer.start()
	set_physics_process(true)

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func _on_Timer_timeout():
	attack_player()

func attack_player():
	if player and player.has_method("take_damage"):
		player.take_damage(2)
		print("Boss attacks player!")

func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()


func _on_damage_zone_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(2)
			print("🔥 Boss touched the player!")
