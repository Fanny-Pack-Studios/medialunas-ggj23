shader_type canvas_item;
render_mode blend_add;

uniform sampler2D mask_texture: hint_default_white;
uniform vec4 color:source_color;

void fragment() {
	float alpha = 1.0-fract(.1*UV.x+TIME*.5);
	float mask = texture(mask_texture, fract(UV)).r;
	COLOR= vec4(color.rgb,alpha*mask);
}
