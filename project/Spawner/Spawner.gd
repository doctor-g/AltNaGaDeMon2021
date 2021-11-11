extends Node2D

signal enemy_spawned(enemy)

const _SLIME := preload("res://Enemies/Slime/Slime.tscn")

# The number of enemies to spawn before this spawner is done
export var number := 3

onready var _anim_player := $AnimationPlayer

func spawn():
	var enemy :Node2D = _SLIME.instance()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	number -= 1
	emit_signal("enemy_spawned", enemy)


func _on_WaitTimer_timeout():
	_anim_player.play("spawn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="spawn" and number==0:
		_anim_player.play("disappear")
	elif anim_name=="disappear":
		queue_free()
