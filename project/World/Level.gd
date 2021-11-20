extends Node2D

const _GREEN_SLIME := preload("res://Enemies/Slime/GreenSlime.tscn")
const _PINK_SLIME := preload("res://Enemies/Slime/PinkSlime.tscn")

# Sent when the level is complete
signal complete

# Sent when the level ends due to players' losing all lives
signal game_over

var players := []

var _enemies := 0
var _active_spawners := 0
var _runover_sound : AudioStreamPlayer = AudioStreamPlayer.new()

onready var _spawners = $Spawners.get_children()

func _ready():
	assert(not players.empty(), "players variable must be set")
	
	for spawner in $Spawners.get_children():
		_active_spawners += 1
		# warning-ignore:return_value_discarded
		spawner.connect("enemy_spawned", self, "_on_Spawner_enemy_spawned")
		# warning-ignore:return_value_discarded
		spawner.connect("tree_exited", self, "_on_Spawner_tree_exited")
		
	
	# Spawn the pawns
	for i in range(0,players.size()):
		var player = players[i]
		if player.lives > 0:
			player.pawn = _spawn_pawn(i, false)
			# warning-ignore:return_value_discarded	
			player.connect("lives_changed", self, "_on_Player_lives_changed", [player])
	
	# Make the runover sfx player
	add_child(_runover_sound)
	_runover_sound.stream = preload("res://Enemies/2_runover.wav")
	
	_run()


# Run this level
func _run():
	assert(false, "Subclasses must override this function.")


func _on_Spawner_enemy_spawned(enemy:Node2D)->void:
	_enemies += 1
	
	# Watch for when the enemy is destroyed
	# warning-ignore:return_value_discarded
	enemy.connect("destroyed", self, "_on_Enemy_destroyed", [], CONNECT_ONESHOT)
	

func _on_Spawner_tree_exited()->void:
	_active_spawners -= 1


func _on_Enemy_destroyed()->void:
	# We play the sound here because if we played it in the enemy,
	# there would be a conflict between freeing the enemy and finishing
	# the sound effect playback.
	_runover_sound.play()
	
	# Now, handle the logic of enemy destruction
	_enemies -= 1
	_check_end_of_level()
	
	
func _check_end_of_level()->void:
	assert(_enemies >= 0, "Counted negative enemies.")
	if _enemies==0 and _active_spawners==0:
		emit_signal("complete")


func _spawn_pawn(index:int, invincible: bool)->Pawn:
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
		player.pawn = _spawn_pawn(player.index, true)
		
	# If no one has any lives left, trigger game_over
	var any_lives = false
	for i in range(0,players.size()):
		if players[i].lives > 0:
			any_lives = true
			break
	if not any_lives:
		emit_signal("game_over")
