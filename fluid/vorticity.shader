shader_type canvas_item;

uniform sampler2D velocity;

void fragment()
{
	float vl = texture(velocity, UV - vec2(1,0) * SCREEN_PIXEL_SIZE).y;
	float vr = texture(velocity, UV + vec2(1,0) * SCREEN_PIXEL_SIZE).y;
	float vb = texture(velocity, UV - vec2(0,1) * SCREEN_PIXEL_SIZE).x;
	float vt = texture(velocity, UV + vec2(0,1) * SCREEN_PIXEL_SIZE).x;
	COLOR.rg = vec2(vr-vl-vt+vb) * 0.5 / TEXTURE_PIXEL_SIZE + 0.5;
}