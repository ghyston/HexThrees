void main()
{
	vec4 texture = texture2D(u_texture, v_tex_coord);
	
	if(texture.r > 0.5) {
		texture.a = 0.0;
		texture.r = 0.0;
		texture.g = 0.0;
		texture.b = 0.0;
	}
	else {
		texture.a = 0.7;
	}
		
	
	gl_FragColor = texture;
}

