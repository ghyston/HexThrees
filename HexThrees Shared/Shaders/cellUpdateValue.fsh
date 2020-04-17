void main()
{
	
	float dx = v_tex_coord.x - aStart.x;
	float dy = v_tex_coord.y - aStart.y;
	float current = pow(dx, 2) + pow(dy, 2);
	
	gl_FragColor = current > aPos ?
		vec4(aOldColor, 1.0) :
		vec4(aNewColor, 1.0);
}

