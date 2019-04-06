shader_type canvas_item;

void fragment()
{
	highp float scalef = 320.0;
	highp float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	highp vec2 scale = vec2(scalef, scalef * aspect_ratio);
	COLOR.rgb = texture(SCREEN_TEXTURE, floor(UV*scale)/scale).rgb;
}