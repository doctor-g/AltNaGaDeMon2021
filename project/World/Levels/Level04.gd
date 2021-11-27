extends Level

func _get_spawner_data()->Array:
	return [
		1.0,
		{
			0: [ _GREEN_SLIME, _RIGHT],
			1: [ _PINK_SLIME, _LEFT],
		},
		2.0,
		{
			0: [ _PINK_SLIME, _LEFT],
			1: [ _GREEN_SLIME, _RIGHT],
		},
		2.0,
		{
			0: [ _BLUE_SLIME, _RIGHT],
			1: [ _BLUE_SLIME, _LEFT],
		},
		2.0,
		{
			0: [ _BLUE_SLIME, _LEFT],
			1: [ _BLUE_SLIME, _RIGHT],
		},
		3.5,
		2.0,
		{
			0: [ _GREEN_SLIME, _LEFT],
			1: [ _PINK_SLIME, _RIGHT],
		},
		2.0,
		{
			0: [ _PINK_SLIME, _RIGHT],
			1: [ _GREEN_SLIME, _LEFT],
		},
		2.0,
		{
			0: [ _BLUE_SLIME, _RIGHT],
			1: [ _BLUE_SLIME, _LEFT],
		},
		2.0,
		{
			0: [ _BLUE_SLIME, _LEFT],
			1: [ _BLUE_SLIME, _RIGHT],
		},
	]
