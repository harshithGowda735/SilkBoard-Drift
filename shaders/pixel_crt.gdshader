shader_type canvas_item;

uniform float scan_alpha : hint_range(0.0, 0.35) = 0.14;
uniform float wipe_progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 block = floor(UV * vec2(24.0, 14.0));
	float threshold = fract(sin(dot(block, vec2(12.9898, 78.233))) * 43758.5453);
	if (wipe_progress > 0.0 && threshold < wipe_progress) {
		COLOR = vec4(0.07, 0.06, 0.11, 1.0);
	} else {
		float line = mod(floor(FRAGCOORD.y), 2.0);
		COLOR = vec4(0.0, 0.0, 0.0, line * scan_alpha);
	}
}
