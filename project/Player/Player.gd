class_name Player
extends Object

const _COLORS = [ Color8(139, 207, 186), Color8(243, 175, 197) ]

signal score_changed(new_score)
signal lives_changed(new_lives)

var index := -1 
var lives := 3 setget _set_lives
var score := 0 setget _set_score
var pawn setget _set_pawn
var color 

# This is separated from lives above because the actual loss of a life happens
# at the end of the death animation. However, we want to stop getting points
# when the last life is the process of being lost. Hence, we have this
# variable to track that.
var can_earn_points := true

func _init(_index:int):
	index = _index
	color = _COLORS[index]


func make_hud()->Control:
	var lives_box : Control = preload("res://Player/PlayerHUD.tscn").instance()
	lives_box.player = self
	return lives_box


func _set_score(value:int)->void:
	if can_earn_points:
		score = value
		emit_signal("score_changed", score)


func _set_lives(value:int)->void:
	lives = value
	emit_signal("lives_changed", lives)


func _set_pawn(value)->void:
	pawn = value
	if pawn!=null:
		# warning-ignore:return_value_discarded
		pawn.connect("dead", self, "_on_Pawn_dead")


func _on_Pawn_dead():
	lives -= 1
	emit_signal("lives_changed", lives)
