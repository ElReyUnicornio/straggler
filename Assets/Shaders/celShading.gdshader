shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

uniform vec4 albedo : source_color;
uniform sampler2D color_gradient;
uniform bool enable_fresnel = true;
uniform sampler2D fresnel_gradient;

varying mat4 modelview_matrix;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void vertex() {
    modelview_matrix = MODELVIEW_MATRIX;
	
}

void fragment() {
	vec3 transformedNormal = normalize(NORMAL * mat3(modelview_matrix));
	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);
	
	//verifies if the normals are fliped
	vec3 viewDir = normalize(VIEW);
    float dotProduct = dot(NORMAL, viewDir);
    if (dotProduct < 0.0) {
        basic_fresnel = fresnel(4.0, -NORMAL, VIEW);
    }
	
	if (!enable_fresnel) basic_fresnel = 0.0;
	
	ALBEDO = albedo.rgb + (basic_fresnel * texture(fresnel_gradient, vec2(basic_fresnel, 0.0)).rgb * 1.0);
}

void light() {
	vec3 light_dir = normalize(LIGHT);
	float dotproduct = clamp(dot(NORMAL, light_dir), -0.9, 0.9);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec4 shaded = texture(color_gradient, vec2(sample, 0.0));
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}
