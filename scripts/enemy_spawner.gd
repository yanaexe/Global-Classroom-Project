extends Node2D

@export var slime_scene: PackedScene
@export var spawn_count: int = 3
@export var spawn_area: Rect2 = Rect2(Vector2(0, 0), Vector2(50, 50)) # adjust this to fit your stage

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

func spawn_slime():
	
	var slime = slime_scene.instantiate()
	print("👀 Slime children:", slime.get_children())
	print("✅ Slime instantiated as:", slime.get_class())

	# Add green debug sprite
	var debug_sprite := Sprite2D.new()
	var texture := Image.new()
	texture.create(32, 32, false, Image.FORMAT_RGBA8)
	texture.fill(Color.GREEN)
	var img_tex := ImageTexture.create_from_image(texture)
	debug_sprite.texture = img_tex
	debug_sprite.position = Vector2.ZERO  # ensure it's centered
	slime.add_child(debug_sprite)

	slime.global_position = Vector2(400, 300)  # hardcoded test pos
	get_tree().current_scene.add_child(slime)

	print("✅ Slime added to scene at 0,0")


	get_tree().current_scene.add_child(slime)
	print("✅ Slime added to scene")
