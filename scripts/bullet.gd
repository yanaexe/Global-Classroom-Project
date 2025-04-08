extends Area2D

@export var speed: float = 50
@export var direction: Vector2 = Vector2.LEFT

func _process(delta):
	position += direction.normalized() * speed * delta

func _on_area_entered(area):
	if area.name == "PlayerSoul":
		print("Player hit!")
		# Handle damage here
		queue_free()

func _on_timer_timeout():
	queue_free()
