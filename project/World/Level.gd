extends Node2D

# Called when the level is complete
signal complete

var players := []

var _enemies := 0
var _spawning_complete := false

onready var _game_over_label := $HUD/GameOverLabel
onready var _spawners = $Spawners.get_children()

func _ready():
	assert(not players.empty(), "players variable must be set")
	
	for spawner in $Spawners.get_children():
		# warning-ignore:return_value_discarded	
		spawner.connect("enemy_spawned", self, "_on_Spawner_enemy_spawned")
	
	# Spawn the pawns
	for i in range(0,players.size()):
		var player = players[i]
		player.pawn = _spawn_player(i, false)
		# warning-ignore:return_value_discarded	
		player.connect("lives_changed", self, "_on_Player_lives_changed", [player])
		$HUD/TopBar.add_child(player.make_hud())
		
	_run()


# Run this level
func _run():
	var Slime := preload("res://Enemies/Slime/Slime.tscn")
	yield(get_tree().create_timer(1.0), "timeout")
	for _i in range(0,2):
		_spawners[0].spawn(Slime, true)
		_spawners[1].spawn(Slime, false)
		yield(get_tree().create_timer(3.0), "timeout")
	_spawning_complete = true
	

func _on_Spawner_enemy_spawned(enemy:Node2D)->void:
	_enemies += 1
	# warning-ignore:return_value_discarded
	enemy.connect("destroyed", self, "_on_Enemy_destroyed")
	

func _on_Enemy_destroyed()->void:
	_enemies -= 1
	_check_end_of_level()
	
	
func _check_end_of_level()->void:
	if _enemies==0 and _spawning_complete:
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
