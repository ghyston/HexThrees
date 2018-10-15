void main()
{
    float thinStep = 0.1;
    float lineW = 0.1;
    
    bool isVerticallyOnLine = mod(v_tex_coord.x, thinStep) / thinStep < lineW;
    bool isHorizontallyOnLine = mod(v_tex_coord.y, thinStep) / thinStep < lineW;
    
    float r = isVerticallyOnLine || isHorizontallyOnLine ? 1.0 : 0.0;
    gl_FragColor = vec4(r, r, r, 0.5);
    //u_texture[v_tex_coord]
    // ;
}
