extends KinematicBody2D

const BASE_POINTS := 100
const CHAIN_BONUS := 50

signal destroyed

export var speed := 100

# Which direction is this thing moving
export var direction := Vector2.LEFT

var captured := false setget _set_captured

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO
# Stored value of velocity.x during capture.
# It can be reset when being uncaptured
var _previous_x := 0.0
var _previous_layer : int
var _previous_mask : int

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


# Score the enemy, with points going to the given Player source
func score(source, chain:int = 0)->void:
	var points = BASE_POINTS + chain * CHAIN_BONUS
	source.score += points
	
	# Make and show the popup
	var points_popup = preload("res://Enemies/PointsPopup.tscn").instance()
	points_popup.color = source.color
	points_popup.points = points
	get_tree().get_root().add_child(points_popup)
	points_popup.set_as_toplevel(true)
	points_popup.position = global_position


# Call this when this enemy is really destroyed, so the level knows what's up.
func destroy()->void:
	emit_signal("destroyed")


func _set_captured(value:bool)->void:
	captured = value
	if captured:
		_anim_player.play("captured")
		
		# Store info for later restoration if uncaptured
		_previous_x = _velocity.x
		_previous_layer = collision_layer
		_previous_mask = collision_mask
		
		# Stop horizontal movement
		_velocity.x = 0
		
		# Captured enemies don't collide with anything
		collision_mask = 0
		collision_layer = 0
	else:
		_anim_player.stop()
		_anim_player.play("RESET")
		_velocity.x = _previous_x
		
		# Restore collision settings
		collision_layer = _previous_layer
		collision_mask = _previous_mask
	
