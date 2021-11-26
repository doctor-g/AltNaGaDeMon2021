extends Control

const _MAX_PLAYERS := 2

export var dance_duration := 2.0
export var level_index := 0
export var use_difficulty_override := false
export var difficulty_override := 0

var num_players := 2

var _players := []
var _difficulty := 0
var _level_node : Node2D
var _levels := [
	load("res://World/Levels/Level00.tscn"),
	load("res://World/Levels/Level01.tscn")
]
var _old_level : Node2D

onready var _anim_player := $AnimationPlayer
onready var _level_label := $LevelLabelHolder/LevelLabel
onready var _pause_menu := $PauseMenu


func _ready():
	assert(num_players > 0 and num_players <= _MAX_PLAYERS)
	
	# Instantiate the players
	for i in range(0,num_players):
		var player = Player.new(i)
		_players.append(player)
		$HUD/TopBar.add_child(player.make_hud())
		
	# Make and configure the level
	_start_next_level()


func _start_next_level():
	var new_level : Node2D = _levels[level_index % _levels.size()].instance()
	new_level.players = _players
	
	# Either use the overridden difficulty (for testing levels) or compute 
	# the difficulty based on how many times we've gone through all the
	# levels
	if use_difficulty_override:
		_difficulty = difficulty_override
	else:
		# warning-ignore:integer_division
		_difficulty = level_index / _levels.size()
	new_level.difficulty = _difficulty
	
	# If there is an old level, fly in the new level, then remove the old level.
	if _level_node:
		_old_level = _level_node
		var viewport_height := get_viewport_rect().size.y
		$Tween.interpolate_property(_level_node, "position", null, Vector2(0, -viewport_height), 1.0)
		new_level.position.y = get_viewport_rect().size.y
		$Tween.interpolate_property(new_level, "position", null, Vector2.ZERO, 1.0)
		$Tween.start()
	
	_level_node = new_level
	
	# Add the child between frames and move it just under the background
	# so that the endgame HUD will draw over it
	call_deferred("add_child", new_level)
	call_deferred("move_child", new_level, 1)
	
	# Connect signals to watch for finishing a level and game over.
	# warning-ignore:return_value_discarded
	new_level.connect("complete", self, "_on_Level_complete")
	# warning-ignore:return_value_discarded	
	new_level.connect("game_over", self, "_on_game_over")
	
	_level_label.text = "Level %d" % (level_index+1)
	_anim_player.play("advance-level")


func _on_Level_complete():
	# Make the surviving pawns dance
	for player in _players:
		if player.lives > 0:
			player.pawn.dance()
	
	yield(get_tree().create_timer(dance_duration), "timeout")
	
	# Remove the player pawns
	for player in _players:
		if player.pawn!=null and is_instance_valid(player.pawn):
			player.pawn.queue_free()
	
	level_index += 1
	_start_next_level()


func _on_game_over():
	_pause_menu.enabled = false
	_anim_player.play("GameOver")


func _on_PlayAgainButton_pressed():
	var world = load("res://World/World.tscn").instance()
	world.num_players = num_players
	var root := get_tree().get_root()
	root.add_child(world)
	root.remove_child(self)


func _on_MenuButton_pressed():
	# Note that we cannot simply use change_scene here. It doesn't
	# jive with the add/remove child approach that has to be taken
	# with the World above, which is required to set the number of
	# players. Specifically, it works once, and then not again.
	# The best I can figure is that this is due to get_tree().get_root()
	# manipulation.
	var root := get_tree().get_root()
	root.remove_child(self)
	root.add_child(load("res://Screens/MainMenu/MainMenu.tscn").instance())


# This should be called when the level transition is complete, so then
# we free the previous level
func _on_Tween_tween_all_completed():
	_old_level.queue_free()
