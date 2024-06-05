shader_type spatial;
render_mode world_vertex_coords;

varying vec3 world_position;

void vertex()
{
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	COLOR = vec4(1.0,1.0,1.0,1.0);
	
}

void fragment() {
	mat4 LocalToWorld = VIEW_MATRIX * MODEL_MATRIX;
	vec3 worldPos = (LocalToWorld * vec4(VERTEX, 1.0)).xyz;
	vec3 vertexPosWS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    // Calcula la distancia entre la posición del fragmento y la posición del vértice en el espacio del mundo
    float distance_threshold = 2.0; // Umbral de distancia para determinar si estamos cerca de un vértice
    float distance_to_vertex = distance(worldPos, vertexPosWS);

    // Si la distancia al vértice es menor que el umbral, dibuja un punto
    if (distance_to_vertex < distance_threshold) {
        ALBEDO = vec3(1.0, 1.0, 1.0); // Color blanco
        ALPHA = 1.0; // Opacidad completa
    } else {
        ALBEDO = vec3(1.0, 0.0, 0.0);
    }
}
