shader_type canvas_item;

uniform vec4 base_color: source_color;
uniform sampler2D noise: hint_default_white;
uniform float rotation;

void fragment() {
	vec2 uv = vec2(texture(TEXTURE,UV).g, 0.0);
	float value = texture(noise, vec2(UV.y,0.0)).r * .7 + .2;
	COLOR.rgb = base_color.rgb*value+ vec3(.1)*(rotation > PI ? 1.0-uv.x: uv.x);
}
