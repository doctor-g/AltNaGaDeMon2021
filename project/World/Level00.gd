extends "Level.gd"

func _run():
	yield(get_tree().create_timer(1.0), "timeout")
	
	_spawners[0].spawn(_GREEN_SLIME, true)
	_spawners[1].spawn(_PINK_SLIME, false)
	yield(get_tree().create_timer(3.0), "timeout")
	
	_spawners[0].spawn(_PINK_SLIME, true)
	_spawners[1].spawn(_GREEN_SLIME, false)
	
	_spawning_complete = true
	for spawner in _spawners:
		spawner.expire()