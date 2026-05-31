shader_type canvas_item;

uniform vec2 light_dir = vec2(1.0, 1.0);
uniform int samples = 16;
uniform float upscale = 5.0;

uniform bool useAtlas = false;

uniform float height: hint_range(1, 32.0);

uniform vec2 texture_size = vec2(0., 0.);
uniform vec2 region_offset = vec2(0, 0);
uniform vec2 region_size = vec2(0, 0);

vec4 get_region() {
	vec4 region = vec4(0);
	
	region.r = region_offset.x / texture_size.x;
	region.g = (region_offset.x + region_size.x) / texture_size.x;
	
	region.b = region_offset.y / texture_size.y;
	region.a = (region_offset.y + region_size.y) / texture_size.y;
	
	return region;
}

vec2 get_uv(vec2 uv, vec4 region_limits) {
	vec2 center = vec2(
        (region_limits.r + region_limits.g) * 0.5,
        (region_limits.b + region_limits.a) * 0.5
    );
	
	float relative_upscale = 1. / upscale;
	
	return (uv - center) / relative_upscale + center;
}

void fragment() {
	vec4 region_limits = get_region();
	vec2 base_uv = get_uv(UV, region_limits);

	float shadow = 0.0;

	for (int i = 1; i <= samples; i++) {
		float t = float(i) / float(samples);
		vec2 offset = light_dir * TEXTURE_PIXEL_SIZE * t * height;
		vec2 sample_uv = base_uv - offset;
		
		float sample_in_bounds = step(region_limits.r, sample_uv.x) * 
		                         step(sample_uv.x, region_limits.g) * 
		                         step(region_limits.b, sample_uv.y) * 
		                         step(sample_uv.y, region_limits.a);
		
		float mask = mix(1.0, sample_in_bounds, float(useAtlas));
		float sample_alpha = texture(TEXTURE, sample_uv).a * mask;

		shadow = max(shadow, sample_alpha);
	}

	vec4 shadow_col = vec4(0.0, 0.0, 0.0, shadow);
	COLOR = shadow_col;
}
