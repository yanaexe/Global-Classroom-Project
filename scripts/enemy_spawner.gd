extends Node2D

@export var slime_scene: PackedScene
@export var spawn_count: int = 20
@export var spawn_area: Rect2 = Rect2(Vector2(-64, -5), Vector2(91, 7)) # adjust this to fit your stage

func _process(delta):
	if Input.is_action_just_pressed("spawn_key"):
		print("🕹️ Manual spawn trigger")
		spawn_slime()

func _ready():
	print("slime scene is,", slime_scene)
	print("⚙️ Spawner ready")

	if slime_scene:
		print("📦 Slime scene is assigned")
		for i in range(spawn_count):
			print("🔁 Spawning slime", i)
			spawn_slime()
	else:
		print("❌ Slime scene not assigned!")

	await get_tree().process_frame
	print("👾 TOTAL slimes in scene after delay:", get_tree().get_nodes_in_group("enemy").size())

func spawn_slime():
	var slime = slime_scene.instantiate()
	print("👀 Slime children:", slime.get_children())
	print("✅ Slime instantiated as:", slime.get_class())

	# Add green debug sprite
	var debug_sprite := Sprite2D.new()
	var texture := Image.new()
	texture.create(32, 32, false, Image.FORMAT_RGBA8)
	texture.fill(Color.GREEN)
	debug_sprite.position = Vector2.ZERO  # ensure it's centered
	slime.add_child(debug_sprite)

	# Calculate spawn position using scene coordinates
	var spawn_pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)

	# Now we assume spawn_pos should be in world space (no conversion needed)
	slime.position = spawn_pos

	# Defer adding the slime to avoid the error
	get_tree().current_scene.call_deferred("add_child", slime)
	slime.add_to_group("enemy")

	print("👾 Spawned slime at:", slime.position)
	print("🐾 Spawning slime at:", spawn_pos)
	print("👾 Total slimes in scene:", get_tree().get_nodes_in_group("enemy").size())
