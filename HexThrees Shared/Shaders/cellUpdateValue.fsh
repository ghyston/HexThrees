void main()
{
	
	float dx = v_tex_coord.x - uStart.x;
	float dy = v_tex_coord.y - uStart.y;
	float current = pow(dx, 2) + pow(dy, 2);
	
	gl_FragColor = current > uPos ?
		vec4(uOldColor, 1.0) :
		vec4(uNewColor, 1.0);
}

