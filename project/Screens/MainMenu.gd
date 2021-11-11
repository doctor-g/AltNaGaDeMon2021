extends Control

const _WORLD := preload("res://World/World.tscn")


func _ready():
	$ButtonBox/Start1PButton.grab_focus()


func _on_Start1PButton_pressed():
	_start_game(1)


func _on_Start2PButton_pressed():
	_start_game(2)


func _start_game(num_players:int)->void:
	assert (num_players>0)
	var world := _WORLD.instance()
	world.num_players = num_players
	get_tree().get_root().add_child(world)
	get_tree().get_root().remove_child(self)


