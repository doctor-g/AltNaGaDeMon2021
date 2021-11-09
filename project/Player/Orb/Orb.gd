extends KinematicBody2D

const _NUMBER_OF_POINTS := 30
const _TWEEN_TIME := 0.2
const _PLAYER_LAYER := 1

const _WARNING_COLOR := Color.yellow

export var speed := 600

# How many bounces before the orb disappears
export var max_bounces := 4

var color

# The player who formed the orb
var player

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO
var _kicked := false
var _moving_right := false
var _bounces := 0

var _captured_enemy : KinematicBody2D = null

# These allow us to store values that can be restored if the enemy is released
var _enemy_parent : Node2D = null
var _enemy_layer : int
var _enemy_mask : int

onready var _enemy_overlap_area := $EnemyOverlapArea
onready var _anim_player := $AnimationPlayer


func _ready():
	assert(player!=null, "Player must be specified")
	color = player.color


func _draw():
	var radius = $CollisionShape2D.shape.radius
	draw_arc(Vector2.ZERO, radius, 0, TAU, _NUMBER_OF_POINTS, color, 4)


func _physics_process(_delta):
	if not _kicked:
		# Moving "zero" here to ensure we get the collision info
		# warning-ignore:return_value_discarded
		move_and_slide(Vector2.ZERO, Vector2.UP)
		
		# Check if the orb was kicked by a player		
		for i in range(0,get_slide_count()):
			var collision := get_slide_collision(i)
			if collision.collider.is_in_group("players"):
				_kicked = true
				_enemy_overlap_area.monitoring = true
				set_collision_mask_bit(_PLAYER_LAYER, false)
				_velocity.x = speed
				
				# Stop the animation player so we don't expire.
				# Also make sure the color is right and redraw,
				# since it can be animated.
				_anim_player.stop(true)
				color = player.color
				update()
				
				# Adjust direction based on if this was hit from left or right
				if collision.position.x > global_position.x:
					_moving_right = false
					_velocity.x *= -1
				else:
					_moving_right = true

	# Handle having been kicked already
	else:
		_velocity.y += _gravity
		_velocity = move_and_slide(_velocity, Vector2.UP)
		
		# Bounce off of walls
		if is_on_wall():
			_bounces += 1
			if _bounces >= max_bounces:
				# Reward the player whose orb is expiring
				player.score += 100
				queue_free()
			else:
				_moving_right = not _moving_right
				_velocity.x = speed if _moving_right else -speed


func capture(enemy:KinematicBody2D)->void:
	assert(not enemy.captured, "Enemy already captured!")
	_captured_enemy = enemy
	_enemy_parent = enemy.get_parent()
	_enemy_layer = enemy.collision_layer
	_enemy_mask = enemy.collision_mask
	
	enemy.collision_mask = 0
	enemy.collision_layer = 0
	enemy.captured = true
	
	# Need to store the position because reparenting
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
func _on_EnemyOverlapArea_body_entered(body):
	body.damage(player)


func _on_AnimationPlayer_animation_finished(_anim_name):
	# Restore parent while keeping position
	var pos = _captured_enemy.global_position
	remove_child(_captured_enemy)
	_enemy_parent.add_child(_captured_enemy)
	_captured_enemy.global_position = pos
	_captured_enemy.captured = false
	
	# Restore collision settings
	_captured_enemy.collision_layer = _enemy_layer
	_captured_enemy.collision_mask = _enemy_mask
	
	# Clear instance variables. Maybe not necessary, but it
	# seems like it should help the garbage collector.
	_captured_enemy = null
	_enemy_parent = null
	
	queue_free()
