extends Node2D

signal enemy_spawned(enemy)

const _SLIME := preload("res://Enemies/Slime/Slime.tscn")

# These constants are tied to the export values for facing below.
const _LEFT := 0
const _RIGHT := 1

# The number of enemies to spawn before this spawner is done
export var number_to_spawn := 3

# Which direction are things facing that come forth
export(int, "left", "right") var facing := _LEFT

onready var _anim_player := $AnimationPlayer

func spawn():
	var enemy :Node2D = _SLIME.instance()
	enemy.global_position = global_position
	enemy.direction = Vector2.LEFT if facing==_LEFT else Vector2.RIGHT
	get_parent().add_child(enemy)
	number_to_spawn -= 1
	emit_signal("enemy_spawned", enemy)


func _on_WaitTimer_timeout():
	_anim_player.play("spawn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="spawn" and number_to_spawn==0:
		_anim_player.play("disappear")
	elif anim_name=="disappear":
		queue_free()
