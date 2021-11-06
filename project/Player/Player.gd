extends KinematicBody2D

export var speed := 250
export var jump_strength := 920

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO

onready var _sprite := $AnimatedSprite

func _physics_process(_delta):
	_velocity.y += _gravity
	
	var direction := Input.get_action_strength("move_right") \
					 - Input.get_action_strength("move_left")
	
	_velocity.x = speed * direction
	if _velocity.x != 0:
		_sprite.flip_h = _velocity.x < 0
		
	if Input.is_action_just_pressed("jump"):
		_velocity.y -= jump_strength
	
	_sprite.play("walk" if _velocity.x != 0 else "idle")
	
	
	
	_velocity = move_and_slide(_velocity, Vector2.UP)
