class_name Player
extends Object

signal score_changed(new_score)
signal lives_changed(new_lives)

var index := -1
var lives := 3 setget _set_lives
var score := 0 setget _set_score
var pawn setget _set_pawn

func _init(_index:int):
	index = _index


func make_hud()->Control:
	var lives_box : Control = preload("res://Player/PlayerHUD.tscn").instance()
	lives_box.player = self
	return lives_box


func _set_score(value:int)->void:
	score = value
	emit_signal("score_changed", score)


func _set_lives(value:int)->void:
	lives = value
	emit_signal("lives_changed", lives)


func _set_pawn(value)->void:
	pawn = value
	# warning-ignore:return_value_discarded
	pawn.connect("dead", self, "_on_Pawn_dead")


func _on_Pawn_dead():
	lives -= 1
	emit_signal("lives_changed", lives)
