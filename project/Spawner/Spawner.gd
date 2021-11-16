extends Node2D

signal enemy_spawned(enemy)

const _SLIME := preload("res://Enemies/Slime/Slime.tscn")

# These constants are tied to the export values for facing below.
const _LEFT := 0
const _RIGHT := 1

var _enemy:Node2D

onready var _anim_player := $AnimationPlayer

func spawn(scene:PackedScene, facing_left:bool=true):
	_enemy = scene.instance()
	_enemy.global_position = global_position
	_enemy.direction = Vector2.LEFT if facing_left else Vector2.RIGHT
	# This will start the spawn anim, which at the right point,
	# will call add_spawned_enemy, which adds _enemy as a child
	_anim_player.play("spawn")


func _add_spawned_enemy():
	get_parent().add_child(_enemy)
	emit_signal("enemy_spawned", _enemy)
	

# Plays an outro animation and removes this spawner
func expire():
	# This can be called while a spawn animation is still finishing.
	# If so, wait until that's done, then wrap up.
	if _anim_player.current_animation=="spawn":
		# warning-ignore:return_value_discarded
		_anim_player.connect("animation_finished", self, \
			"_on_AnimationPlayer_animation_finished", [], CONNECT_ONESHOT)
	else:
		_play_expiration()


func _on_AnimationPlayer_animation_finished(_anim:String)->void:
	_play_expiration()


func _play_expiration():
	_anim_player.play("disappear")
