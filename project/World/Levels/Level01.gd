extends "../Level.gd"

func _get_spawner_data():
	return [
		1.0,
		{
			0: [_GREEN_SLIME, _RIGHT],
			1: [_GREEN_SLIME, _LEFT],
		},
		3.0,
		{
			0: [_BLUE_SLIME, _RIGHT],
			1: [_BLUE_SLIME, _LEFT]
		}
	]
