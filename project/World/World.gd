extends Control

var num_players := 2

var _players := []
var _level_node : Node2D

onready var _anim_player := $AnimationPlayer

func _ready():
	# Instantiate the players
	for i in range(0,num_players):
		var player = Player.new(i)
		_players.append(player)
		
	# Make and configure the level
	_start_next_level()


func _start_next_level():
	var new_level : Node2D= load("res://World/Level.tscn").instance()
	new_level.players = _players
	_level_node = new_level	
	
	# Add the child between frames and move it to the first position
	# so that the endgame HUD will draw over it
	call_deferred("add_child", new_level)
	call_deferred("move_child", new_level, 0)
	
	# Connect signals to watch for finishing a level and game over.
	# warning-ignore:return_value_discarded
	new_level.connect("complete", self, "_on_Level_complete")
	# warning-ignore:return_value_discarded	
	new_level.connect("game_over", self, "_on_game_over")


func _on_Level_complete():
	_level_node.queue_free()
	_start_next_level()


func _on_game_over():
	_anim_player.play("GameOver")


func _on_PlayAgainButton_pressed():
	var world = load("res://World/World.tscn").instance()
	world.num_players = num_players
	get_tree().get_root().add_child(world)
	get_tree().get_root().remove_child(self)


func _on_MenuButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Screens/MainMenu.tscn")
