extends Node2D

var num_players := 2

var _players := []
var _level_node : Node2D

func _ready():
	# Instantiate the players
	for i in range(0,num_players):
		var player = Player.new(i)
		_players.append(player)
		
	# Make and configure the level
	_start_next_level()


func _on_Level_complete():
	print("Complete!")
	_level_node.queue_free()
	_start_next_level()


func _start_next_level():
	var new_level : Node2D= load("res://World/Level.tscn").instance()
	new_level.players = _players
	call_deferred("add_child", new_level)
	# warning-ignore:return_value_discarded
	new_level.connect("complete", self, "_on_Level_complete")
	_level_node = new_level

