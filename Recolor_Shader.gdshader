shader_type canvas_item;

uniform vec4 new_color: source_color;

void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
	// Find only blue pixels
	if (curr_color.rga == vec3(0,0,1)  && curr_color.b > 0.0) {
		COLOR.rgb = new_color.rgb* curr_color.b;
	}
		
}
