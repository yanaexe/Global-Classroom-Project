extends Area2D

@export var speed: float = 50
@export var direction: Vector2 = Vector2.LEFT
var battle_area : Rect2

func _process(delta):
	position += direction.normalized() * speed * delta
	
	# Despawn bullet if it goes outside the battle area
	if battle_area and not battle_area.has_point(global_position):
		queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player_soul"):
		print("Player hit!")
		queue_free()

func _on_Timer_timeout():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
