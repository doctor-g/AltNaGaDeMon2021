extends Node2D

const _SLIME := preload("res://Enemies/Slime/Slime.tscn")

onready var _anim_player := $AnimationPlayer

func spawn():
	var enemy :Node2D = _SLIME.instance()
	enemy.global_position = global_position
	get_parent().add_child(enemy)


func _on_WaitTimer_timeout():
	_anim_player.play("spawn")
