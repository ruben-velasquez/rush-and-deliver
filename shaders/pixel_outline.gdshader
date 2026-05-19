shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform bool include_corners;

void fragment() {
	if(COLOR.a < 1.) {
		vec2 pixel_size = TEXTURE_PIXEL_SIZE * 2.;
		
		bool valid_side = 
			texture(TEXTURE, UV + vec2(0, pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(0, -pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(pixel_size.x, 0)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-pixel_size.x, 0)).a > 0.0;
		
		bool valid_corner = 
			texture(TEXTURE, UV + vec2(pixel_size.x, pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-pixel_size.x, -pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(pixel_size.x, -pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-pixel_size.x, pixel_size.y)).a > 0.0;
		
		if(valid_side || (valid_corner && include_corners)) {
			COLOR.rgb = outline_color;
			COLOR.a = 1.0;
		}
	}
}