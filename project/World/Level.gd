extends Node2D

var num_players := 2

var _players = []

onready var _game_over_label := $HUD/GameOverLabel

func _ready():
	for i in range(0,num_players):
		var player = Player.new(i)
		_players.append(player)
		player.pawn = _spawn_player(i, false)
		player.connect("lives_changed", self, "_on_Player_lives_changed", [player])
		$HUD/TopBar.add_child(player.make_hud())


func _spawn_player(index:int, invincible: bool)->Pawn:
	var pawn : Pawn = preload("res://Player/Pawn/Pawn.tscn").instance()
	pawn.index = index
	pawn.start_invincible = invincible
	pawn.position = $SpawnPoints.get_children()[index].position
	add_child(pawn)
	return pawn


func _on_Player_lives_changed(_new_lives:int, player:Player)->void:
	if player.lives > 0:
		# warning-ignore:return_value_discarded		
		player.pawn = _spawn_player(player.index, true)
		
	var any_lives = false
	for i in range(0,num_players):
		if _players[i].lives > 0:
			any_lives = true
			break
	if not any_lives:
		_game_over_label.visible = true
