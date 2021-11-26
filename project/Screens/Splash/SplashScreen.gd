extends Control

onready var _ready_button := $ReadyButton
onready var _anim_player := $AnimationPlayer

func _ready():
	_ready_button.visible = OS.get_name()=="HTML5"


func _unhandled_key_input(event):
	if event.is_action("ui_accept"):
		_go_to_main_menu()


func _wipe_out_if_not_html5()->void:
	if not OS.get_name()=="HTML5":
		_anim_player.play("wipe-out")


func _go_to_main_menu():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Screens/MainMenu/MainMenu.tscn")


func _on_ReadyButton_pressed():
	_ready_button.disabled=true
	_anim_player.play("wipe-out")
