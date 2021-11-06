extends KinematicBody2D

const _Orb := preload("res://Player/Orb/Orb.tscn")

export var speed := 350

var direction := Vector2.ZERO

func _physics_process(delta):
	var collision := move_and_collide(direction * speed * delta)
	if collision and collision.collider.is_in_group("enemies"):
		var enemy : KinematicBody2D = collision.collider
		var orb : KinematicBody2D = _Orb.instance()
		orb.set_as_toplevel(true)
		orb.global_position = collision.position
		get_parent().add_child(orb)
		orb.capture(enemy)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
