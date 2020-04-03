void main() {
	
	int N = 10;
	
	float stripeL = u_path_length / N; // lenth of stripe in points
	float currentPos = mod(v_path_distance, stripeL); // current position in stripe in points
	float currentRelativePos = currentPos / stripeL + uPos;
	
	gl_FragColor = float4(currentRelativePos > 0.3 ? 1.0 : 0.0);
}
