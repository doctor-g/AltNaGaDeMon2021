shader_type canvas_item;

uniform float fade_percent = 0.0;

void fragment() {
	if (1.0 - UV.y >= fade_percent)
		COLOR = texture(TEXTURE, UV);
	else
		COLOR = vec4(0,0,0,0);
}