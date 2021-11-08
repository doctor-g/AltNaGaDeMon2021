extends Control

const _LEVEL := preload("res://World/Level.tscn")

func _on_JoinControl_complete():
	var joined_players := 0
	for control in $JoinControls.get_children():
		if control.joined:
			joined_players += 1
	
	var level := _LEVEL.instance()
	level.num_players = joined_players
	get_tree().get_root().add_child(level)
	get_tree().get_root().remove_child(self)
	
