shader_type canvas_item;

uniform sampler2D color_ramp;

void fragment()
{
	float col = texture(SCREEN_TEXTURE, UV).r;
	COLOR.rgb = texture(color_ramp, vec2(col, 0.0)).rgb;
	
}