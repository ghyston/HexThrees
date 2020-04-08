
void main()
{
	vec4 selfColor = texture2D(u_texture, v_tex_coord);
	
	vec2 coordLeft = v_tex_coord;
	coordLeft.x = max(0.0, coordLeft.x - 0.1);
	vec4 colorLeft = texture2D(u_texture, coordLeft);
	
	vec2 coordRight = v_tex_coord;
	coordRight.x = min(1.0, coordLeft.x + 0.1);
	vec4 colorRight = texture2D(u_texture, coordLeft);
	
	if(colorLeft.a != selfColor.a && colorRight.a != selfColor.a)
	{
		gl_FragColor = vec4(1.0, 0.0, 0.0, 0.0);
	}
	else
	{
		gl_FragColor = vec4(0.0, 1.0, 0.0, 0.0);
	}
	
	//gl_FragColor = selfColor;
    //vec4 defaultShading = SKDefaultShading();
    //@todo: better mix by components
    //float defaultBW = (defaultShading.r + defaultShading.g + defaultShading.b) / 5.0;
    //gl_FragColor = v_tex_coord.y < uPos ?
      //  defaultShading :
        //vec4(defaultBW, defaultBW, defaultBW, 1.0);
}

