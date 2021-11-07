class_name Player
extends Object

signal lives_changed(new_lives)

var lives : int = 3
var index := -1

var pawn : Pawn setget _set_pawn

func _init(_index:int):
	index = _index


func make_hud()->Control:
	var lives_box : Control = preload("res://Player/LivesBox.tscn").instance()
	lives_box.player = self
	return lives_box
	

func _set_lives_changed(value:int)->void:
	lives = value
	emit_signal("lives_changed",value)


func _set_pawn(value:Pawn)->void:
	pawn = value
	# warning-ignore:return_value_discarded
	pawn.connect("dead", self, "_on_Pawn_dead")


func _on_Pawn_dead():
	lives -= 1
	emit_signal("lives_changed", lives)
