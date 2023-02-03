shader_type canvas_item;

uniform vec4 base_color: source_color;
uniform sampler2D noise: hint_default_white;
uniform float rotation;

void fragment() {
	float value = texture(noise, vec2(UV.y,UV.x*.5)).r * .7 + .2;
	COLOR.rgb = base_color.rgb*value+ vec3(.1)*(rotation > PI ? UV.y: 1.0-UV.y);
}
