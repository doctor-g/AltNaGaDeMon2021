extends "Level.gd"

func _run():
	var Slime := _GREEN_SLIME
	yield(get_tree().create_timer(1.0), "timeout")
	
	_spawners[0].spawn(Slime, true)
	_spawners[1].spawn(Slime, false)
	yield(get_tree().create_timer(3.0), "timeout")
	
	_spawners[0].spawn(Slime, true, true)
	_spawners[1].spawn(Slime, false, true)
