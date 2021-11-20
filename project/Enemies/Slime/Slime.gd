extends KinematicBody2D

signal destroyed

export var speed := 100

# Which direction is this thing moving
export var direction := Vector2.LEFT

var captured := false setget _set_captured

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO

onready var _sprite := $AnimatedSprite
onready var _anim_player := $AnimationPlayer

func _ready():
	# The slime defaults to facing left
	_velocity.x = speed * direction.x
	
	# Give each instance its own shader
	_sprite.material = _sprite.material.duplicate()


func _physics_process(_delta):
	if not captured:
		_velocity.y += _gravity
		_velocity = move_and_slide(_velocity, Vector2.UP)
		if is_on_wall():
			direction.x *= -1
			_velocity.x = direction.x * speed
		_sprite.flip_h = direction.x > 0


# Damage the enemy, with the damage coming from the given source (pawn)
func damage(source)->void:
	var points = 100
	source.score += points
	
	# Make and show the popup
	var points_popup = preload("res://Enemies/PointsPopup.tscn").instance()
	points_popup.color = source.color
	points_popup.points = points
	get_parent().add_child(points_popup)
	points_popup.set_as_toplevel(true)
	points_popup.position = global_position
	
	emit_signal("destroyed")
	
	queue_free()


func _set_captured(value:bool)->void:
	captured = value
	if captured:
		_anim_player.play("captured")
	else:
		# Reset animated values and then stop the animation
		_anim_player.stop()
		_anim_player.play("RESET")
