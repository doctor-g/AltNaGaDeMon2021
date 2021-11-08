extends KinematicBody2D

export var speed := 100

var captured := false

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO
var _moving_right := false

onready var _sprite := $AnimatedSprite

func _ready():
	# The slime defaults to facing left
	_velocity.x = -speed


func _physics_process(_delta):
	if not captured:
		_velocity.y += _gravity
		_velocity = move_and_slide(_velocity, Vector2.UP)
		if is_on_wall():
			_moving_right = not _moving_right
			_velocity.x = speed if _moving_right else -speed
		_sprite.flip_h = _moving_right


# Damage the enemy, with the damage coming from the given source (player)
func damage(source)->void:
	source.score += 100
	queue_free()
