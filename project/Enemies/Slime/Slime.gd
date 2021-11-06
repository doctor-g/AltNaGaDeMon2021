extends KinematicBody2D

export var speed := 100

var captured := false

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO

func _ready():
	# The slime defaults to facing left
	_velocity.x = -speed


func _physics_process(_delta):
	if not captured:
		_velocity.y += _gravity
		_velocity = move_and_slide(_velocity, Vector2.UP)
