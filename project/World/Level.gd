extends Node2D

# Called when the level is complete
signal complete

var players := []

var _enemies := 0
var _spawners := 0

onready var _game_over_label := $HUD/GameOverLabel

func _ready():
	assert(not players.empty(), "players variable must be set")
	
	for spawner in $Spawners.get_children():
		_spawners += 1
		# warning-ignore:return_value_discarded	
		spawner.connect("enemy_spawned", self, "_on_Spawner_enemy_spawned")
		# warning-ignore:return_value_discarded	
		spawner.connect("tree_exited", self, "_on_Spawner_tree_exited")
	
	# Spawn the pawns
	for i in range(0,players.size()):
		var player = players[i]
		player.pawn = _spawn_player(i, false)
		# warning-ignore:return_value_discarded	
		player.connect("lives_changed", self, "_on_Player_lives_changed", [player])
		$HUD/TopBar.add_child(player.make_hud())


func _on_Spawner_enemy_spawned(enemy:Node2D)->void:
	_enemies += 1
	# warning-ignore:return_value_discarded
	enemy.connect("destroyed", self, "_on_Enemy_destroyed")
	

func _on_Enemy_destroyed()->void:
	_enemies -= 1
	_check_end_of_level()
	
	
func _on_Spawner_tree_exited()->void:
	_spawners -= 1
	_check_end_of_level()
	
	
func _check_end_of_level()->void:
	if _spawners==0 and _enemies==0:
		emit_signal("complete")


func _spawn_player(index:int, invincible: bool)->Pawn:
	var pawn : Pawn = preload("res://Player/Pawn/Pawn.tscn").instance()
	pawn.player = players[index]
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
	for i in range(0,players.size()):
		if players[i].lives > 0:
			any_lives = true
			break
	if not any_lives:
		_game_over_label.visible = true
