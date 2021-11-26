extends Level

func _get_spawner_data()->Array:
	return [
		1.0,
		{
			0: [ _GREEN_SLIME, _RIGHT],
			1: [ _GREEN_SLIME, _LEFT],
		},
		1.0,
		{
			0: [ _GREEN_SLIME, _LEFT],
			1: [ _GREEN_SLIME, _RIGHT],
		},
		1.0,
		{
			0: [ _GREEN_SLIME, _RIGHT],
			1: [ _GREEN_SLIME, _LEFT],
		},
		1.0,
		{
			0: [ _GREEN_SLIME, _LEFT],
			1: [ _GREEN_SLIME, _RIGHT],
		},
		3.0,
		1.0,
		{
			0: [ _GREEN_SLIME, _RIGHT],
			1: [ _GREEN_SLIME, _RIGHT],
		},
		1.0,
		{
			0: [ _GREEN_SLIME, _LEFT],
			1: [ _GREEN_SLIME, _LEFT],
		},
		1.0,
		{
			0: [ _GREEN_SLIME, _RIGHT],
			1: [ _GREEN_SLIME, _RIGHT],
		},
		1.0,
		{
			0: [ _GREEN_SLIME, _LEFT],
			1: [ _GREEN_SLIME, _LEFT],
		}
	]
