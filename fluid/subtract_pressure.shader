shader_type canvas_item;

uniform sampler2D pressure;
uniform sampler2D velocity;

void fragment()
{
	float x0 = (texture(pressure, UV - vec2(1,0) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	float x1 = (texture(pressure, UV + vec2(1,0) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	float y0 = (texture(pressure, UV - vec2(0,1) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	float y1 = (texture(pressure, UV + vec2(0,1) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	
	vec2 pressure_gradient = (vec2(x1, y1) - vec2(x0, y0)) * 0.5;
	vec2 old_velocity = texture(velocity, UV).xy ;
	
	COLOR.rgb = vec3((old_velocity - pressure_gradient), 0.5);
}