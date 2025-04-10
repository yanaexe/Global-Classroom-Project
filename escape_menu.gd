extends Control


func _on_try_again_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stage_1.tscn")
	
	
func _on_home_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
