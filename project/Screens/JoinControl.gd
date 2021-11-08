extends VBoxContainer

const _PROGRESS_FILL_SPEED := 0.8

signal complete

export var index := 0

var _action_prefix : String
var joined := false
var complete := false

onready var _label := $Label
onready var _progress_bar := $ProgressBar


func _ready():
	_action_prefix = "p%d_" % (index + 1)
	

func _input(event):
	if not joined and event.is_action_pressed(_action_prefix + "jump"):
		_label.text = "Hold to Start"
		_progress_bar.visible = true
		joined = true


func _process(delta):
	if joined:
		if Input.is_action_pressed(_action_prefix + "jump"):
			_progress_bar.value += delta * _PROGRESS_FILL_SPEED
			if _progress_bar.value >= 1:
				_label.text = "Ready!"
				complete = true
				emit_signal("complete")
		elif not complete:
			_progress_bar.value = 0
