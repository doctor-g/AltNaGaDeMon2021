extends Node2D

const _PLAYER := preload("res://Player/Player.tscn")

func _ready():
	_spawn_player(false)
	
func _spawn_player(invincible: bool)->void:
	var player : KinematicBody2D = _PLAYER.instance()
	player.start_invincible = invincible
	player.position = $P1SpawnPoint.position
	add_child(player)
	# warning-ignore:return_value_discarded
	player.connect("dead", self, "_spawn_player", [true])
