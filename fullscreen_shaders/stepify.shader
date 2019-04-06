shader_type canvas_item;

void fragment()
{
	float steps = 5.0;
	vec3 col = texture(SCREEN_TEXTURE, UV).rgb;
	col = floor(col*steps)/steps;
	COLOR.rgb = col;
}