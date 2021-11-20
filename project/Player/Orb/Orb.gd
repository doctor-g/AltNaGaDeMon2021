extends KinematicBody2D

const _NUMBER_OF_POINTS := 30
const _TWEEN_TIME := 0.2
const _PLAYER_LAYER := 1
const _ROTATION_SPEED := 600 # degrees per second

const _WARNING_COLOR := Color.yellow

enum Direction { NONE, LEFT, RIGHT, DOWN_THEN_RIGHT, DOWN_THEN_LEFT }

export var speed := 600

# How many bounces before the orb disappears
export var max_bounces := 4

var color

# The player who formed the orb
var player

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO
var _kicked := false
var _bounces := 0

var _direction = Direction.NONE

var _captured_enemy : KinematicBody2D = null

# These allow us to store values that can be restored if the enemy is released
var _enemy_parent : Node2D = null

onready var _enemy_overlap_area := $EnemyOverlapArea
onready var _anim_player := $AnimationPlayer
onready var _appear_sound := $AppearSound
onready var _kick_sound := $KickSound


func _ready():
	assert(player!=null, "Player must be specified")
	color = player.color
	_appear_sound.play()


func _draw():
	var radius = $CollisionShape2D.shape.radius
	draw_arc(Vector2.ZERO, radius, 0, TAU, _NUMBER_OF_POINTS, color, 4)


func _physics_process(delta):
	if not _kicked:
		_velocity.y += _gravity
		_velocity = move_and_slide(_velocity, Vector2.UP)
		
	# Handle having been kicked already
	else:
		_velocity.y += _gravity
		_captured_enemy.rotation_degrees += _ROTATION_SPEED * delta \
											* (-1 if _velocity.x < 0 else 1)
		_velocity = move_and_slide(_velocity, Vector2.UP)

		if is_on_wall() and (_direction==Direction.LEFT or _direction==Direction.RIGHT):
			_kick_sound.play()
			_bounces += 1
			if _bounces >= max_bounces:
				_destroy()
			else:
				_direction = Direction.DOWN_THEN_LEFT \
					if _direction == Direction.RIGHT else Direction.DOWN_THEN_RIGHT
		
		elif is_on_floor() and _direction==Direction.DOWN_THEN_LEFT:
			_direction = Direction.LEFT
			_velocity.x = -speed
		
		elif is_on_floor() and _direction==Direction.DOWN_THEN_RIGHT:
			_direction = Direction.RIGHT
			_velocity.x = speed
		
	# Whether kicked or not, if we hit an orb, destroy this orb
	# and the other
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		var collider : Node2D = collision.collider
		if collider.is_in_group("orbs"):
			_destroy()
			collider._destroy()


func _destroy():
	# Damaging the captured enemy should create an increase in player score.
	_captured_enemy.damage(player)
	queue_free()


func kick(direction:Vector2)->void:
	_kick_sound.play()
	
	_kicked = true
	_enemy_overlap_area.monitoring = true
	set_collision_mask_bit(_PLAYER_LAYER, false)
	_velocity.x = speed * direction.x
	
	_direction = Direction.LEFT if direction.x < 0 else Direction.RIGHT
	
	# Stop the animation player so we don't expire.
	# Also make sure the color is right and redraw,
	# since it can be animated.
	_anim_player.stop(true)
	color = player.color
	update()


func capture(enemy:KinematicBody2D)->void:
	assert(not enemy.captured, "Enemy already captured!")
	_captured_enemy = enemy
	
	# Store values that can be used if this enemy is dropped (uncaptured)
	_enemy_parent = enemy.get_parent()
	
	enemy.captured = true
	# Reparent the enemy to the orb
	var enemy_position := enemy.global_position
	_enemy_parent.remove_child(enemy)
	add_child(enemy)
	enemy.global_position = enemy_position

	# Tween the captured enemy's position to the center of the orb
	var tween := Tween.new()
	add_child(tween)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(enemy, "position", \
		enemy.position, Vector2.ZERO, _TWEEN_TIME, \
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()


func toggle_color():
	color = _WARNING_COLOR if color==player.color else player.color
	update() # Force redraw


# When this sensor is active and runs into an enemy,
# that means the orb was kicked, and we should damage
# the enemy we hit
func _on_EnemyOverlapArea_body_entered(body:Node2D):
	if body.has_method("damage"):
		body.damage(player)


func _on_AnimationPlayer_animation_finished(_anim_name):
	# Restore parent while keeping position
	var pos = _captured_enemy.global_position
	remove_child(_captured_enemy)
	_enemy_parent.add_child(_captured_enemy)
	_captured_enemy.global_position = pos
	_captured_enemy.captured = false

	# Clear instance variables. Maybe not necessary, but it
	# seems like it should help the garbage collector.
	_captured_enemy = null
	_enemy_parent = null
	
	queue_free()
