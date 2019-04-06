shader_type canvas_item;

uniform sampler2D divergence;

float sample_pressure(sampler2D tex, vec2 pos, float default_p)
{
	vec2 p = texture(tex, pos).rg;
	
	return mix(p.r * 2.0 - 1.0, default_p, p.g);
}

void fragment()
{
	
	float l = (texture(SCREEN_TEXTURE, SCREEN_UV - vec2(1,0) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	float r = (texture(SCREEN_TEXTURE, SCREEN_UV + vec2(1,0) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	float b = (texture(SCREEN_TEXTURE, SCREEN_UV - vec2(0,1) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	float t = (texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0,1) * SCREEN_PIXEL_SIZE).r * 2.0 - 1.0);
	
	float c = (texture(divergence, UV).x * 2.0 - 1.0) ;
	
	COLOR.rgb = vec3((l+r+b+t - c) * 0.25) * 0.5 + 0.5;
}