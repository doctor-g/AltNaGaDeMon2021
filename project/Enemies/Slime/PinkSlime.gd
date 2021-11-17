extends "res://Enemies/Slime/Slime.gd"

const _FIREBALL := preload("res://Enemies/Slime/Fireball.tscn")

export var impulse := 280.0

onready var _fireball_timer := $FireballTimer

func _on_FireballTimer_timeout():
	var fireball : RigidBody2D = _FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.global_position = global_position
	fireball.set_as_toplevel(true)
	var left := direction.x < 0
	fireball.apply_impulse(Vector2.ZERO, \
		Vector2(-1 if left else 1, -1).normalized()  * impulse)


func _set_captured(value:bool)->void:
	._set_captured(value)
	if value:
		_fireball_timer.stop()
	else:
		_fireball_timer.start()
