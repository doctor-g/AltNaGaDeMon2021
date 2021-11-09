extends Node2D

# Text color
var color : Color
var points : int

onready var _label := $AnimatableNode/Label


func _ready():
	assert(color!=null, "Color must be set")
	assert(points != 0, "Points must be set and nonzero")
	_label.text = "+%d" % points	
	_label.add_color_override("font_color", color)


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
