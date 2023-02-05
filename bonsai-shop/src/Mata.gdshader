shader_type canvas_item;

void fragment() {
	vec4 tex = texture(TEXTURE,UV);
	COLOR = vec4(tex.rgb,max(1.0-length(UV)*.2,tex.a));
}
