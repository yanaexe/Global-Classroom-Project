extends Area2D
signal note_hit
signal note_missed

@export var hit_time: float = 0.0
var clicked := false
var approach_duration := 1000

func _ready():
	$Sprite2D.scale = Vector2(2, 2)
	modulate = Color.WHITE
	set_process(true)

func _process(delta):
	var time_left = hit_time - Time.get_ticks_msec()
	var scale_factor = clamp(float(time_left) / approach_duration, 0, 1)
	$Sprite2D.scale = Vector2(1, 1) + Vector2(scale_factor, scale_factor)

	if time_left < -150 and not clicked:
		emit_signal("note_missed")
		queue_free()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and not clicked:
		var time_diff = abs(Time.get_ticks_msec() - hit_time)
		if time_diff <= 150:
			clicked = true
			emit_signal("note_hit")
			queue_free()
