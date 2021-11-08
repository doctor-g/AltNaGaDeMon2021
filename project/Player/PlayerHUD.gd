extends VBoxContainer

const _ICONS = [
	preload("res://Player/Pawn/P1Images/hud_p1Alt.png"),
	preload("res://Player/Pawn/P2Images/hud_p3Alt.png")
]

var player

onready var _lives_box := $LivesBox
onready var _score_label := $ScoreLabel

func _ready():
	assert (player != null, "Player must be set during initialization")
	for _i in range(0, player.lives):
		var icon := TextureRect.new()
		icon.texture = _ICONS[player.index]
		_lives_box.add_child(icon)
	
	_score_label.text = str(player.score)
	player.connect("lives_changed", self, "_on_Player_lives_changed")
	player.connect("score_changed", self, "_on_Player_score_changed")


func _on_Player_lives_changed(_new_lives:int)->void:
	var life_icon = _lives_box.get_child(0)
	_lives_box.remove_child(life_icon)


func _on_Player_score_changed(new_score:int)->void:
	_score_label.text = str(new_score)
