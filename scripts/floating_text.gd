extends Node2D

@export var text := "HIT!"
@export var color := Color.WHITE

func _ready():
	$Label.text = text
	$Label.modulate = color

	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	tween.tween_property(self, "position:y", position.y - 20, 0.6)
	await tween.finished
	queue_free()
