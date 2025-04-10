extends Area2D
signal note_hit
signal note_missed

@export var hit_time: float = 0.0
var clicked := false
var approach_duration := 1000
var floating_text_scene = preload("res://scenes/FloatingText.tscn")

func _ready():
	$Sprite2D.scale = Vector2(2, 2)
	modulate = Color.WHITE
	set_process(true)
	input_pickable = true

func _process(delta):
	var time_left = hit_time - Time.get_ticks_msec()
	var scale_factor = clamp(float(time_left) / approach_duration, 0, 1)
	var scale = lerp(2.0, 1.0, 1.0 - scale_factor)
	$Sprite2D.scale = Vector2.ONE * scale

	if time_left < -150 and not clicked:
		show_floating_text("Miss!", Color.RED)
		emit_signal("note_missed")
		queue_free()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and not clicked:
		var time_diff = abs(Time.get_ticks_msec() - hit_time)
		if time_diff <= 150:
			clicked = true
			show_floating_text("Hit!", Color.LIME)
			emit_signal("note_hit")
			queue_free()

func show_floating_text(text: String, color: Color):
	var ft = floating_text_scene.instantiate()
	ft.text = text
	ft.color = color
	ft.position = position
	get_parent().add_child(ft)
