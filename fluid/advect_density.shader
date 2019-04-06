shader_type canvas_item;

uniform float timestep;
uniform float dissipation;

uniform sampler2D velocity;
uniform sampler2D advected;


vec3 bilinear_texture(sampler2D tex, vec2 uv, vec2 tex_size) 
{
    vec2 pos = uv / tex_size - 0.5;
	vec2 f = fract(pos);
	vec2 i = floor(pos);
	
	vec3 tl = texture(tex, (i + vec2(0.5, 0.5)) * tex_size).rgb;
	vec3 tr = texture(tex, (i + vec2(1.5, 0.5)) * tex_size).rgb;
	vec3 bl = texture(tex, (i + vec2(0.5, 1.5)) * tex_size).rgb;
	vec3 br = texture(tex, (i + vec2(1.5, 1.5)) * tex_size).rgb;
	
	return mix( mix(tl, tr, f.x), mix(bl, br, f.x), f.y);
}

void fragment()
{
	
	vec2 p = UV - timestep * SCREEN_PIXEL_SIZE * (texture(velocity, UV).xy * 2.0 - 1.0);
	vec3 vel = (bilinear_texture(advected, p, SCREEN_PIXEL_SIZE)) * dissipation;
    COLOR.rgb = vel;
}