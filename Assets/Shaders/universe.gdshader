shader_type spatial;

varying mediump vec3 pos;

group_uniforms Gradient_Colors;

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform vec4 color3 : source_color;
uniform vec4 color4 : source_color;

group_uniforms Cel_Shading;

uniform sampler2D fresnel_gradient;
uniform sampler2D color_gradient;

group_uniforms Stars;

uniform float stars_intensity : hint_range(0.0, 1.0);
uniform float star_density : hint_range(1.0, 100.0) = 25.0;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void vertex() {
}

vec3 hash(vec3 x) {
    x = vec3(dot(x, vec3(127.1, 311.7, 74.7)),
             dot(x, vec3(269.5, 183.3, 246.1)),
             dot(x, vec3(113.5, 271.9, 124.6)));
    return fract(sin(x) * 43758.5453123);
}

vec3 voronoi(in vec3 x) {
    vec3 p = floor(x);
    vec3 f = fract(x);

    float id = 0.0;
    vec2 res = vec2(100.0);
    for (int k = -1; k <= 1; k++)
        for (int j = -1; j <= 1; j++)
            for (int i = -1; i <= 1; i++) {
                vec3 b = vec3(float(i), float(j), float(k));
                vec3 r = vec3(b) - f + hash(p + b);
                float d = dot(r, r);
                if (d < res.x) {
                    id = dot(p + b, vec3(1.0, 57.0, 113.0));
                    res = vec2(d, res.x);
                } else if (d < res.y) {
                    res.y = d;
                }
            }
    return vec3(sqrt(res), abs(id));
}

void fragment() {
	vec3 EYEDIR = normalize(vec3(VERTEX));
    vec3 sky_color = vec3(0.0, 0.0, 0.0);

	pos = VIEW;
	vec4 gradient1 = mix(color2, color1, pos.x);
	vec4 gradient2 = mix(color4, color3, pos.x);
	vec4 gradient2D = mix(gradient1, gradient2, pos.y);
	
	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);
	sky_color = gradient2D.rgb + (basic_fresnel * texture(fresnel_gradient, vec2(basic_fresnel, 0.0)).rgb * 1.0);

    if (stars_intensity > 0.0) {
        vec2 stars = voronoi(EYEDIR * star_density).xz;
        float star_brightness = smoothstep(
            0.050 + ((1.0 + sin(TIME + stars.y)) / 2.0) * 0.05, 0.0, stars.x
        ) * stars_intensity;
        sky_color += star_brightness;
    }

    ALBEDO = sky_color;
}

void light() {
	float dotproduct = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec4 shaded = texture(color_gradient, vec2(sample, 0.0));
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}
