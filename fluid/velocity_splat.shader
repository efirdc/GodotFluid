shader_type canvas_item;

uniform vec4 color : hint_color;
uniform vec2 point;
uniform float radius;

float gauss(vec2 p, float r)
{
    return exp(-dot(p, p) / r);
}


void fragment()
{
    
    vec2 coord = point * SCREEN_PIXEL_SIZE - UV;
    float splat = gauss(coord / SCREEN_PIXEL_SIZE, radius);
	
	vec3 base = texture(SCREEN_TEXTURE, UV).rgb * 2.0 - 1.0;
	vec3 col = splat * (color.rgb * 2.0 - 1.0);
	
	
    COLOR.rgb = (base + col) * 0.5 + 0.5;
}