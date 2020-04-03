void main() {
	int N = 10;
	
	float stripeL = u_path_length / N; // lenth of stripe in points
	float currentPos = mod(v_path_distance, stripeL); // current position in stripe in points
	float currentRelativePos = currentPos / stripeL;
	
	gl_FragColor = currentRelativePos > 0.5 ?
		float4(1.0, 0.7, 0.0, 1.0) :
		float4(0.0, 0.0, 0.0, 1.0);
}
