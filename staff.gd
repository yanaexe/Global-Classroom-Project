extends Node2D

const STAFF = preload("res://scenes/staff_attack.tscn")
@onready var gem: Marker2D = $Marker2D

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("fire"):
		var staff_instance = STAFF.instantiate()
		get_tree().root.add_child(staff_instance)
		
		staff_instance.global_position = gem.global_position
		staff_instance.rotation = rotation
