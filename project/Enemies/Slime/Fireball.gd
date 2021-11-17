extends RigidBody2D

# Remove this fireball when it falls off-screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
