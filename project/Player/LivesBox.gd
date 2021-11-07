extends HBoxContainer

const _ICONS = [
	preload("res://Player/Pawn/P1Images/hud_p1Alt.png"),
	preload("res://Player/Pawn/P2Images/hud_p3Alt.png")
]

var player setget _set_player


func _set_player(value)->void:
	player = value
	for _i in range(0,player.lives):
		var icon := TextureRect.new()
		icon.texture = _ICONS[player.index]
		add_child(icon)
		
	player.connect("lives_changed", self, "_on_Player_lives_changed")


func _on_Player_lives_changed(_new_lives:int)->void:
	remove_child(get_child(0))
