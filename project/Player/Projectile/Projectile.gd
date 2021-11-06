extends KinematicBody2D

export var speed := 350

var direction := Vector2.ZERO

func _physics_process(delta):
	#warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
