void main() {
	float normalisedPosition = v_path_distance / u_path_length;
	gl_FragColor = vec4(normalisedPosition, normalisedPosition, 0.0, 1.0);
}
