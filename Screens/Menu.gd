extends Control

func _on_Start_pressed() -> void:
	var ok = get_tree().change_scene("res://Combat/Combat.tscn")
	
	if ok != OK:
		print("ERROR: Menu Screen: button start ( Menu -> Game )")
