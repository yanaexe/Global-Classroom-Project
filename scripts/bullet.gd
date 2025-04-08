extends Area2D

@export var speed: float = 50
@export var direction: Vector2 = Vector2.LEFT

func _process(delta):
	position += direction.normalized() * speed * delta

func _on_body_entered(body: Node2D):
	if body.is_in_group("player_soul"):
		print("Player hit!")
		queue_free()

func _on_Timer_timeout():
	queue_free()
