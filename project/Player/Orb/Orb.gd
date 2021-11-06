extends KinematicBody2D

const _NUMBER_OF_POINTS := 30
const _TWEEN_TIME := 0.2

export var speed := 600

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO
var _kicked := false
var _moving_right := false

func _draw():
	var radius = $CollisionShape2D.shape.radius
	draw_arc(Vector2.ZERO, radius, 0, TAU, _NUMBER_OF_POINTS, Color.aliceblue, 4)


func _physics_process(_delta):
	if not _kicked:
		# Moving "zero" here to ensure we get the collision info
		var collision = move_and_collide(Vector2.ZERO)
		
		# Check if the orb was kicked by a player
		if collision and collision.collider.is_in_group("players"):
			_kicked = true
			collision_mask = 0x1
			print(str(get_collision_mask_bit(1)))
			_velocity.x = speed
			if collision.position.x > global_position.x:
				_moving_right = false
				_velocity.x *= -1
			else:
				_moving_right = true
	else:
		_velocity.y += _gravity
		_velocity = move_and_slide(_velocity, Vector2.UP)
		if is_on_wall():
			_moving_right = not _moving_right
			_velocity.x = speed if _moving_right else -speed


func capture(enemy:KinematicBody2D)->void:
	enemy.collision_mask = 0
	enemy.collision_layer = 8
	enemy.captured = true
	
	# Need to store the position because reparenting
	var enemy_position := enemy.global_position
	enemy.get_parent().remove_child(enemy)
	add_child(enemy)
	enemy.global_position = enemy_position

	# Tween the captured enemy's position to the center of the orb
	var tween := Tween.new()
	add_child(tween)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(enemy, "global_position", \
		enemy.global_position, global_position, _TWEEN_TIME, \
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()
