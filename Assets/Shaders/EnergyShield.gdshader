shader_type spatial;
render_mode depth_draw_never, shadows_disabled, specular_disabled, ambient_light_disabled, unshaded, cull_front;

uniform mat4 model_view;

group_uniforms Shield_Color;
uniform float _shield_intensity : hint_range(0.25, 5.0, 0.05) = 2.0;

group_uniforms Shield_Hex;
uniform float scale = 15.0;
uniform float line_speed = 0.5;
uniform float ripple_speed = 1.564;

uniform vec4 line_color : source_color = vec4( 0.2, 1.0, 1.0, 1.0 );
uniform vec4 ripple_color : source_color = vec4( 0.6, 0.7, 1.0, 0.7 );
uniform vec4 surface_color : source_color = vec4( 0.01, 0.18, 0.7, 0.4 );

uniform float sphere_size = 2.0;

uniform vec3 pos1 = vec3( 0.0, 0.0, 0.0 );
uniform vec3 pos2 = vec3( 10000, 10000, 10000 );
uniform vec3 pos3 = vec3( 10000, 10000, 10000 );
uniform vec3 pos4 = vec3( 10000, 10000, 10000 );
uniform vec3 pos5 = vec3( 10000, 10000, 10000 );
uniform vec3 pos6 = vec3( 10000, 10000, 10000 );

varying vec3 world_vertex;

float hex_cells(vec3 position) {
    float x = position.x * scale;
    float y = mod(floor(x), 2.0) * 0.5 + (position.y * scale / 1.25);
    vec2 base_chip = abs(vec2(0.5) - mod(vec2(x, y), 1.0));
    return abs(max(base_chip.x * 1.5 + base_chip.y, base_chip.y * 2.0) - 1.0);
}

float saturate(float x) {
  return max(0, min(1, x));
}

float ComputeFresnel(vec3 norm, vec3 view_dir, float intensity) {
	// dot product between mesh normals and view direction
	float fresnel = saturate(1.0 - dot(norm, view_dir));
	// modulate fresnel intensity
	fresnel = pow(fresnel, intensity);
	return fresnel;
}

void vertex( )
{
	world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment( )
{
	vec3 position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    float hex = hex_cells(world_vertex);

	vec3 final_line_color = clamp( line_color.rgb + ( fract( length( UV * scale * 0.5 ) + TIME * line_speed ) * 2.0 - 1.0 ), vec3( 0.0 ), vec3( 1.0 ) );

	float ripple = float( abs( hex - mod( -TIME * ripple_speed, 1.0 ) ) * 5.0 < 0.2 );

	vec4 final = mix(
		mix(
			surface_color,
			ripple_color,
			ripple
		)
	,	vec4( final_line_color, 1.0 )
	,	float( hex < 0.02 )
	);
	
	float min_dist = min(
		length( pos1 - world_vertex )
	,	min(
		length( pos2 - world_vertex )
	,	min(
		length( pos3 - world_vertex )
	,	min(
		length( pos4 - world_vertex )
	,	min(
		length( pos5 - world_vertex )
	,	length( pos6 - world_vertex )
	)))));
	
	float f = ComputeFresnel(NORMAL, VIEW, _shield_intensity);
	vec3 viewDir = normalize(VIEW);
	float dotProduct = dot(NORMAL, viewDir);
    if (dotProduct < 0.0) {
        f = ComputeFresnel(-NORMAL, VIEW, _shield_intensity);
    }
	ALBEDO = final.rgb;
	ALPHA = f + clamp( final.a * sphere_size - min_dist, 0.0, 1.0 );
}