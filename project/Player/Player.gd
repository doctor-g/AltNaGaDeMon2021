extends KinematicBody2D

# Emitted when the player is dead and the death animation is complete
signal dead

const _PROJECTILE := preload("res://Player/Projectile/Projectile.tscn")

export var speed := 250
export var jump_strength := 780

var start_invincible := false

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _velocity := Vector2.ZERO
var _dead := false

onready var _sprite := $AnimatedSprite
onready var _anim_player := $AnimationPlayer
onready var _damageable_area := $DamageableArea
onready var _invincibility_timer := $InvincibilityTimer

func _ready():
	if start_invincible:
		_invincibility_timer.start()
		_sprite.modulate = Color(1,1,1,0.4)
		_damageable_area.monitoring = false
		

func _physics_process(_delta):
	if _dead:
		return
	
	_velocity.y += _gravity
	
	if Input.is_action_pressed("duck"):
		_sprite.play("duck")
		_velocity.x = 0
		
		# Allow jumping down through tiles
		if Input.is_action_just_pressed("jump"):
			# Note that for non-one-way tiles, the physics engine will
			# simply push the player back out of the collision, so we
			# do not need a raycast or anything here.
			position.y += 1
	else:
		_process_movement_input()
	
	_velocity = move_and_slide(_velocity, Vector2.UP)
	for i in range(0, get_slide_count()):
		var collision := get_slide_collision(i)
		if collision.collider.is_in_group("enemies"):
			queue_free()


func _process_movement_input()->void:
	var direction := Input.get_action_strength("move_right") \
						 - Input.get_action_strength("move_left")
	_velocity.x = speed * direction
	if _velocity.x != 0:
		_sprite.flip_h = _velocity.x < 0
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_velocity.y -= jump_strength
	
	if not is_on_floor():
		_sprite.play("jump")
	else:
		_sprite.play("walk" if _velocity.x != 0 else "idle")
	
	if Input.is_action_just_pressed("fire"):
		var projectile := _PROJECTILE.instance()
		projectile.direction = Vector2.LEFT if _sprite.flip_h else Vector2.RIGHT
		projectile.position = $ProjectileLaunchPoint.global_position
		get_parent().add_child(projectile)


# This is called when an enemy crosses into the damageable area of the player.
func _on_DamageableArea_body_entered(_body):
	_dead = true
	_sprite.stop()
	$StandingCollision.set_deferred("disabled", true)
	$DamageableArea/CollisionShape2D.set_deferred("disabled", true)
	_anim_player.play("dead")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="dead":
		emit_signal("dead")


func _on_InvincibilityTimer_timeout():
	_sprite.modulate = Color.white
	_damageable_area.monitoring = true
