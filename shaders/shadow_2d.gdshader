shader_type canvas_item;

uniform vec2 light_dir = vec2(1.0, 1.0);
uniform int samples = 16;
uniform float upscale = 5;

uniform bool useAtlas = false;

uniform vec2 clampX;
uniform vec2 clampY;

vec2 atlas_uv(vec2 uv) {
	uv.x = clamp(uv.x, clampX.x, clampX.y);
	uv.y = clamp(uv.y, clampY.x, clampY.y);
	return uv;
}

vec2 get_uv(vec2 uv) {
	vec2 center = vec2(
        (clampX.x + clampX.y) * 0.5,
        (clampY.x + clampY.y) * 0.5
    );
	
	float relative_upscale = 1. / upscale;
	
	uv = (uv - center) / relative_upscale + center;
	
	if (useAtlas) {
		uv = atlas_uv(uv);
	}
	
	return uv;
}

void fragment() {
	vec2 uv = get_uv(UV);

    float shadow = 0.0;

    for (int i = 1; i <= samples; i++) {
        float t = float(i) / float(samples);

        vec2 offset = light_dir * t;

        shadow = max(
            shadow,
            texture(TEXTURE, get_uv(UV - offset)).a
        );
    }

    vec4 shadow_col = vec4(0, 0, 0, shadow);

    COLOR = shadow_col;
}