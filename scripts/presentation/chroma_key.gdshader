shader_type canvas_item;
// Apenas os dois atlas de personagens usam fundo de recorte magenta.
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float key = smoothstep(0.25, 0.55, min(tex.r, tex.b) - tex.g);
	COLOR.a *= (1.0 - key);
}
