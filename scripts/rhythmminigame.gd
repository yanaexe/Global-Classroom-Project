extends Node2D
signal minigame_finished(success: bool)

var hit_circle_scene = preload("res://scenes/HitCircle.tscn")

# Use dummy times for now — all positions will be randomized inside the background
var beatmap = [
	{"time": 1000},
	{"time": 2000},
	{"time": 3000},
]

@onready var background = $Background 
@onready var result_label = $ResultLabel
@onready var hit_spawner = $HitSpawner

var start_time := 0
var total_notes := 0
var notes_hit := 0

func _ready():
	start_minigame()

func start_minigame():
	visible = true
	result_label.visible = false
	start_time = Time.get_ticks_msec()
	total_notes = beatmap.size()
	notes_hit = 0
	spawn_beatmap()

func spawn_beatmap():
	for note in beatmap:
		var hit_time = start_time + note.time
		var spawn_time = hit_time - 1000  # show it 1s before hit time

		var delay = spawn_time - Time.get_ticks_msec()
		delay = max(delay, 0)

		await get_tree().create_timer(delay / 1000.0).timeout

		var spawn_pos = get_random_spawn_pos()
		spawn_hitcircle(spawn_pos, hit_time)


func spawn_hitcircle(pos: Vector2, hit_time: int):
	var hc = hit_circle_scene.instantiate()
	hc.position = pos
	hc.hit_time = hit_time
	hc.z_index = 1  # make sure it's in front of background
	hc.connect("note_hit", _on_note_hit)
	hc.connect("note_missed", _on_note_missed)
	hit_spawner.add_child(hc)


func _on_note_hit():
	notes_hit += 1
	check_finish()

func _on_note_missed():
	check_finish()

func check_finish():
	if notes_hit >= total_notes:
		finish_minigame(true)
	elif hit_spawner.get_child_count() == 0:
		finish_minigame(false)

func finish_minigame(success: bool):
	result_label.visible = true
	if success:
		$ResultLabel.text = "Success!"
	else:
		$ResultLabel.text = "Missed!"
	await get_tree().create_timer(1.0).timeout
	visible = false
	emit_signal("minigame_finished", success)

# Function grabs the visible area of your background image
func get_spawn_bounds() -> Rect2:
	var tex_size = background.texture.get_size()
	var pos = background.position - tex_size * 0.5  # top-left corner
	return Rect2(pos, tex_size)

#Function spawns a random point within that area
func get_random_spawn_pos() -> Vector2:
	var rect = get_spawn_bounds()
	return rect.position + Vector2(
		randf() * rect.size.x,
		randf() * rect.size.y
	)
