extends KinematicBody2D

export var speed := 250
export var jump_strength := 920

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO

onready var _sprite := $AnimatedSprite
onready var _duck_sprite := $DuckSprite

func _physics_process(_delta):
	_velocity.y += _gravity
	
	if Input.is_action_pressed("duck"):
		_sprite.visible = false
		_duck_sprite.visible = true
		_velocity.x = 0
	else:
		_sprite.visible = true
		_duck_sprite.visible = false
		_process_movement_input()
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _process_movement_input()->void:
	var direction := Input.get_action_strength("move_right") \
						 - Input.get_action_strength("move_left")
	_velocity.x = speed * direction
	if _velocity.x != 0:
		_sprite.flip_h = _velocity.x < 0
		_duck_sprite.flip_h = _velocity.x < 0
		
	if Input.is_action_just_pressed("jump"):
		_velocity.y -= jump_strength
	
	if not is_on_floor():
		_sprite.play("jump")
	else:
		_sprite.play("walk" if _velocity.x != 0 else "idle")
	

