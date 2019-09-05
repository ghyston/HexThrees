void main()
{
    //@todo: there are some better way to get center pos
    vec2 dekartPos = v_tex_coord - vec2(0.5, 0.5);
    float r = sqrt(dekartPos.y * dekartPos.y + dekartPos.x * dekartPos.x);
    
    //@todo: interpolate between start and end color (probably, not in shader)
    float angle = acos(dekartPos.y / r);
    if(dekartPos.x < 0.0)
        angle = 6.28 - angle;
    
    vec3 outClr = angle > uPos ?
        uBgColor : uBlockedColor;
    gl_FragColor = vec4(vec3(outClr), 1.0);
}

