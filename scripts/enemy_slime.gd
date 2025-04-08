extends CharacterBody2D

@export var speed: float = 70
@export var gravity: float = 50

var player: CharacterBody2D


func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		print("✅ Found player:", player.name)
	else:
		print("❌ No player found in group")

func _physics_process(delta):
	if player == null:
		print("❌ Player is null in physics process")
		return

	var direction = sign(player.global_position.x - global_position.x)

	if abs(player.global_position.x - global_position.x) < 80:
		velocity.x = direction * speed
		$AnimatedSprite2D.play()
	else:
		velocity.x = 0
		$AnimatedSprite2D.stop()

	velocity.y += gravity * delta
	move_and_slide()
	$AnimatedSprite2D.flip_h = velocity.x > 0
