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
    vec3 base = texture(SCREEN_TEXTURE, UV).rgb;
    vec2 coord = point * SCREEN_PIXEL_SIZE - UV;
    float splat = gauss(coord / SCREEN_PIXEL_SIZE, radius);
    COLOR.rgb = mix(base, color.rgb, splat);
}