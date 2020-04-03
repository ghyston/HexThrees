void main() {
	
	int N = 6;
	
	float stripeL = u_path_length / N; // lenth of stripe in points
	float currentPos = mod(v_path_distance, stripeL); // current position in stripe in points
	float currentRelativePos = currentPos / stripeL;
	
	float intensivity = cos(abs(currentRelativePos - uPos) * 6.28);
	
	gl_FragColor = float4(max(0.5 + 2.0 * (u_appear - 1.0)  + intensivity * 2.0, 0.0));
}
