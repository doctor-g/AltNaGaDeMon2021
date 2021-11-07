extends Control

const _LIFE_ICON := preload("res://HUD/hud_p1Alt.png")

onready var _lives_box := $LivesBox

func _ready():
	for _i in range(0, Globals.lives):
		var icon := TextureRect.new()
		icon.texture = _LIFE_ICON
		_lives_box.add_child(icon)
	
	# warning-ignore:return_value_discarded
	Globals.connect("lives_changed", self, "_on_Globals_lives_changed")
	
	
func _on_Globals_lives_changed(new_lives:int)->void:
	if new_lives >= 0:
		var to_remove := _lives_box.get_child(_lives_box.get_child_count()-1)
		_lives_box.remove_child(to_remove)

