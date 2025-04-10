extends Node2D

var player_near: bool
var player: CharacterBody2D = null

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "character_player":
		player_near = true
		player = body
		
func _process(delta: float) -> void:
	if player_near and player:
		player.die()
		player_near
		
