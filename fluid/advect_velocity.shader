shader_type canvas_item;

uniform float timestep;
uniform float dissipation;

uniform sampler2D velocity;

// Bilinear interpolation using centers of 4 cells in a texture
vec2 bilinear_texture(sampler2D tex, vec2 pos, vec2 gridsize) 
{
    vec2 p = pos / gridsize - 0.5;
	vec2 f = fract(p);
	vec2 i = floor(p);
	
	// centers of top left, top right, bottom left, and bottom right cells
	vec2 tl = texture(tex, (i + vec2(0.5, 0.5)) * gridsize).xy;
	vec2 tr = texture(tex, (i + vec2(1.5, 0.5)) * gridsize).xy;
	vec2 bl = texture(tex, (i + vec2(0.5, 1.5)) * gridsize).xy;
	vec2 br = texture(tex, (i + vec2(1.5, 1.5)) * gridsize).xy;
	
	return mix( mix(tl, tr, f.x), mix(bl, br, f.x), f.y);
}

void fragment()
{
	
	vec2 p = UV - timestep * SCREEN_PIXEL_SIZE * (texture(velocity, UV).xy * 2.0 - 1.0);
	vec2 vel = (bilinear_texture(velocity, p, SCREEN_PIXEL_SIZE) * 2.0 - 1.0) * dissipation;
    COLOR.rgb = vec3(vel * 0.5 + 0.5, 0.5);
}