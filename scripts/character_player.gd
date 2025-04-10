extends CharacterBody2D

signal damaged(amount)

@export var speed = 300
@export var gravity = 1500
@export var jump_strength = 400  
@export var dash_speed = 600
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0
@export var dodge_minigame_scene: PackedScene = preload("res://scenes/dodge_minigame.tscn")


@onready var animation = $AnimationPlayer
var last_direction = "right"
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var health := 6
var can_take_damage := true
var frozen_enemy : CharacterBody2D = null
var is_dead: bool = false

func _ready():
	add_to_group("player")
	$Graze_Area.connect("body_entered", Callable(self, "_on_body_entered"))
	$InvincibilityTimer.connect("timeout", Callable(self, "_on_invincibility_timeout"))

func get_input():
	var input_direction = Input.get_axis("left", "right")

	if not is_dashing:
		velocity.x = input_direction * speed

	if not is_on_floor():
		velocity.y += gravity * get_process_delta_time()
	else:
		velocity.y = 0

	if input_direction > 0:
		animation.play("walk_right")
		last_direction = "right"
	elif input_direction < 0:
		animation.play("walk_left")
		last_direction = "left"
	else:
		animation.play("idle_" + last_direction)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_strength
		animation.play("jump_" + last_direction)

	if is_on_floor() == false and Input.is_action_just_pressed("down"):
		velocity.y = +jump_strength

	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		velocity.x = dash_speed if last_direction == "right" else -dash_speed
		animation.play("dash_" + last_direction)
		
	if Input.is_action_just_pressed("test"):
		die()

func _physics_process(delta):
	if is_dead:
		return  # skip input + movement if dead
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	get_input()
	move_and_slide()

func take_damage(amount):
	if not can_take_damage:
		return

	can_take_damage = false
	health = max(health - amount, 0)
	print("🩸 Damage taken. Health now:", health)
	emit_signal("damaged", amount)

	if health == 0:
		die()

	$InvincibilityTimer.start()


func _on_invincibility_timeout():
	can_take_damage = true
	print("Player can now be damaged again.")
	
func die():
	if is_dead:
		return  # avoid double death
	is_dead = true

	print("💀 Playing death animation")
	var death_anim = "dead_" + last_direction
	print("Playing:", death_anim)

	if animation.has_animation(death_anim):
		animation.play(death_anim)
	else:
		print("❌ Animation not found:", death_anim)

	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	get_tree().change_scene_to_file("res://scenes/escape_menu.tscn")

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		print("Collided with slime — triggering minigame.")
		frozen_enemy = body
		body.set_physics_process(false)
		set_physics_process(false)
		start_dodge_minigame()

func start_dodge_minigame():
	var minigame = get_node_or_null("/root/stage1/DodgeMinigame")
	if not minigame:
		minigame = dodge_minigame_scene.instantiate()
		minigame.name = "DodgeMinigame"
		get_node("/root/stage1").add_child(minigame)

	if not minigame.is_connected("minigame_won", Callable(self, "_on_minigame_won")):
		minigame.connect("minigame_won", Callable(self, "_on_minigame_won"))
	if not minigame.is_connected("minigame_lost", Callable(self, "_on_minigame_lost")):
		minigame.connect("minigame_lost", Callable(self, "_on_minigame_lost"))

	minigame.visible = true
	if minigame.has_method("start_minigame"):
		minigame.start_minigame()
	else:
		print("⚠️ DodgeMinigame not found!")

func _on_minigame_won():
	print("✅ Minigame WON – resuming player.")
	if frozen_enemy and is_instance_valid(frozen_enemy):
		frozen_enemy.set_physics_process(true)
	frozen_enemy = null
	set_physics_process(true)

func _on_minigame_lost():
	print("❌ Minigame LOST – taking damage and resuming.")
	if frozen_enemy and is_instance_valid(frozen_enemy):
		frozen_enemy.set_physics_process(true)
	frozen_enemy = null
	take_damage(1)
	set_physics_process(true)
