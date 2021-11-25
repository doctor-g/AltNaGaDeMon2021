extends PopupDialog

onready var _ok_button := $CenterContainer/VBoxContainer/OkButton

func show_modal(exclusive:bool=false)->void:
	.show_modal(exclusive)
	_ok_button.grab_focus()


func _on_OkButton_pressed():
	visible = false
