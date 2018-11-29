shader_type canvas_item;
uniform float speed: hint_range(0.0, 1.0) = 2.0;

uniform float min_red: hint_range(0.0, 1.0) = 0.3;
uniform float max_red: hint_range(0.0, 1.0) = 0.7;

void fragment() {
    COLOR = vec4(min_red + (max_red - min_red) * abs(sin(speed * TIME)), 0.0, 0.0, 1.0);
}