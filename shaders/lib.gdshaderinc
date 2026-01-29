// Pass in the VERTEX_ID in the vertex shader of a label
// and then assign the result of this function to a varying.
// It will then give the correct UV map for each character.
vec2 label_uv_from_index(int vertex_id) {
  return vec2(float(vertex_id>>1), float((6>>vertex_id)&1));
}

vec2 rotate_uv(vec2 uv, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(
		cosa * uv.x - sina * uv.y,
		cosa * uv.y + sina * uv.x 
	) + pivot;
}