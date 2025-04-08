extends Node2D

var player_near: bool = false

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.name == "character_player":
		player_near = true

func _on_body_exited(body: Node) -> void:
	if body.name == "character_player":
		player_near = false

func _process(delta: float) -> void:
	if player_near and Input.is_action_just_pressed("enter_door"):
		get_tree().change_scene_to_file("res://scenes/stage_2.tscn")
