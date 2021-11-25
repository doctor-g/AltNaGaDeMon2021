extends PopupDialog

export var enabled := true setget _set_enabled

func _set_enabled(value:bool)->void:
	enabled = value
	set_process_unhandled_input(enabled)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			_unpause()
		else:
			_pause()


func _pause():
	popup()
	get_tree().paused = true


func _unpause():
	visible=false
	get_tree().paused = false


func _on_ContinueButton_pressed():
	_unpause()


func _on_QuitButton_pressed():
	_unpause()
	get_tree().call_group("world", "queue_free")
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Screens/MainMenu.tscn"))
