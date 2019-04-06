shader_type canvas_item;

uniform sampler2D vorticity;

uniform float timestep;
uniform float epsilon;
uniform vec2 curl;


void fragment()
{
	float vl = texture(vorticity, UV - vec2(1,0) * SCREEN_PIXEL_SIZE).x * 2.0 - 1.0;
	float vr = texture(vorticity, UV + vec2(1,0) * SCREEN_PIXEL_SIZE).x * 2.0 - 1.0;
	float vb = texture(vorticity, UV - vec2(0,1) * SCREEN_PIXEL_SIZE).x * 2.0 - 1.0;
	float vt = texture(vorticity, UV + vec2(0,1) * SCREEN_PIXEL_SIZE).x * 2.0 - 1.0;
	float vc = texture(vorticity, UV).x * 2.0 - 1.0;
	
	vec2 force = 0.5 / TEXTURE_PIXEL_SIZE * vec2(abs(vt) - abs(vb), abs(vr) - abs(vl));
	float len_sq = max(epsilon, dot(force, force));
	force *= inversesqrt(len_sq) * curl * vc;
	force.y *= -1.0;
	
	vec2 velc = texture(SCREEN_TEXTURE, UV).xy * 2.0 - 1.0;
	
	COLOR.xy = (velc + timestep * force) * 0.5 + 0.5;
	COLOR.z = 0.5;

}