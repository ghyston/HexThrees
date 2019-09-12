void main()
{
    float steps = 2.0;
    float lineW = 0.2;
    float smoothW = 0.03;
    
    float f = fract(steps * (v_tex_coord.x - v_tex_coord.y));
    if (f >= 0.5) //@todo: ask Nike, is it possible to optimise
        f = 1.0 - f;
    float smoothResult = smoothstep(lineW, lineW + smoothW, f);
    
    /*if(smoothResult > 0.5 && uPos > v_tex_coord.y)
        gl_FragColor = vec4(uBlockedLineColor, 1.0);
    else if (smoothResult < 0.5 && uPos < (1.0 - v_tex_coord.y))
        gl_FragColor = vec4(uBlockedColor, 1.0);
    else
        gl_FragColor = vec4(uBgColor, 1.0);*/
    
    /*float posMultiplier = uPos *
        ((smoothResult > 0.5) ?
         v_tex_coord.y :
         (1.0 - v_tex_coord.y));*/
    
    vec3 resultClr = mix(uBlockedLineColor, uBlockedColor, smoothResult);
    
    
    gl_FragColor = vec4(mix(uBgColor, resultClr, uPos), 1.0);
}
