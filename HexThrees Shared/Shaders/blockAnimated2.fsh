void main()
{
    float steps = 2.0;
    float lineW = 0.2;
    float smoothW = 0.03;
    
    
    float f = fract(steps * (v_tex_coord.x - v_tex_coord.y));
    if (f >= 0.5) //@todo: ask Nike, is it possible to optimise
        f = 1.0 - f;
    float smoothResult = smoothstep(lineW, lineW + smoothW, f);
    //vec3 resultClr = mix(uBlockedLineColor, uBlockedColor, smoothResult);
    //gl_FragColor = vec4(mix(uBgColor, resultClr, aPos), 1.0);
    
    float upSpeed = 0.5;
    float doSpeed = 1.8;
    float yUp = aPos * (upSpeed - 1.0) * v_tex_coord.x - aPos + 1.0;
    float yDo = aPos * (doSpeed - 1.0) * v_tex_coord.x + aPos;
    
    float isUp = v_tex_coord.y > yUp ? 1.0 : 0.0;
    float isDo = v_tex_coord.y < yDo ? 1.0 : 0.0;
    
    //@todo: replace conditions with equations and move constants to precompiled variables!
    if(isUp == 1.0 && smoothResult < 0.5)
    {
        gl_FragColor = vec4(mix(uBlockedLineColor, uBgColor, smoothResult), 1.0);
    }
    else if (isDo == 1.0 && smoothResult > 0.5)
    {
        gl_FragColor = vec4(mix(uBgColor, uBlockedColor, smoothResult), 1.0);
    }
    else
    {
        gl_FragColor = vec4(uBgColor, 1.0);
    }
}
