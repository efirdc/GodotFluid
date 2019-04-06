shader_type canvas_item;

uniform float timestep;
uniform float dissipation;

uniform sampler2D velocity;

vec2 get_velocity(vec2 p) {return texture(velocity, p).xy * 2.0 - 1.0;}
vec4 to_norm (vec4 v) {return v * 2.0 - 1.0;}
vec2 to_col (vec2 v) {return v * 0.5 + 0.5;}

void fragment()
{
	float velocity_range = 10.0;
	vec2 advection_scale = timestep * SCREEN_PIXEL_SIZE;
	float maccormack_amount = 1.0;
	
	vec2 p1 = UV;
	vec2 v1 = to_norm(texture(velocity, p1)).xy * velocity_range;
	
	vec2 p2 = UV - v1 * advection_scale;
	vec2 v2 = to_norm(texture(velocity, p2)).xy * velocity_range;
	
	vec2 p3 = UV + v2 * advection_scale;
	vec2 v3 = to_norm(texture(velocity, p3)).xy * velocity_range;
	
	vec2 v_new = v2 + 0.5 * (v1 - v3) * maccormack_amount;
	
	vec2 pos = p2 / SCREEN_PIXEL_SIZE - 0.5;
	vec2 f = fract(pos);
	vec2 i = floor(pos);
	
	vec2 c1 = to_norm(texture(velocity, (i + vec2(0.5, 0.5)) * SCREEN_PIXEL_SIZE)).xy* velocity_range;
	vec2 c2 = to_norm(texture(velocity, (i + vec2(1.5, 0.5)) * SCREEN_PIXEL_SIZE)).xy* velocity_range;
	vec2 c3 = to_norm(texture(velocity, (i + vec2(0.5, 1.5)) * SCREEN_PIXEL_SIZE)).xy* velocity_range;
	vec2 c4 = to_norm(texture(velocity, (i + vec2(1.5, 1.5)) * SCREEN_PIXEL_SIZE)).xy* velocity_range;
	
	vec2 min_c = min(min(min(c1, c2), c3), c4);
	vec2 max_c = max(max(max(c1, c2), c3), c4);
	
	v_new = max(min(v_new, max_c), min_c);
	
	v_new *= dissipation;
	
    COLOR.rgb = vec3(to_col(v_new/velocity_range), 0.5);
}