extends Control

var next_scene 

func _ready():
	assert(next_scene!=null, "Next scene is not set!")


func _on_AnimationPlayer_animation_finished(_anim_name):
	_advance()


func _advance():
	get_tree().get_root().add_child(next_scene)
	get_tree().get_root().remove_child(self)


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		_advance()
		
