extends Control

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stage_1.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
