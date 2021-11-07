extends Node

signal lives_changed(new_lives)

var lives := 3 setget _set_lives

func _set_lives(value:int)->void:
	lives = value
	emit_signal("lives_changed", lives)
