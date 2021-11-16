extends Node2D

# Called when the level is complete
signal complete

# Called when the level ends due to players' losing all lives
signal game_over

var players := []

var _enemies := 0
var _spawning_complete := false

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
		
	_run()


# Run this level
func _run():
	assert(false, "Subclasses must override this function.")


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
		emit_signal("game_over")
