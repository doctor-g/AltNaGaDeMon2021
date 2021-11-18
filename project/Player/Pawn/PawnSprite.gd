extends AnimatedSprite

export var index := 0 setget _set_index

func _set_index(value:int)->void:
	index = value
	if index==1:
		# Make a copy of the frames so that the other pawn uses its own version.
		frames = frames.duplicate()
		
		# Use the "p3" images which are in the "P2" folder.
		for anim_name in frames.get_animation_names():
			var number_of_frames := frames.get_frame_count(anim_name)
			for i in range(0, number_of_frames):
				var texture := frames.get_frame(anim_name, i)
				var path = texture.resource_path
				var new_texture = path.replace("p1", "p3").replace("P1", "P2")
				frames.set_frame(anim_name, i, load(new_texture))
