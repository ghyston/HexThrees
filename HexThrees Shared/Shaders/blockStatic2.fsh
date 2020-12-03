

void main()
{
    float steps = 2.0;
    float lineW = 0.2;
    float smoothW = 0.03;
    
    float f = fract(steps * (v_tex_coord.x - v_tex_coord.y));
    if (f >= 0.5) //@todo: ask Nike, is it possible to optimise
        f = 1.0 - f;
    float coeff = smoothstep(lineW, lineW + smoothW, f);
    
    gl_FragColor = vec4(mix(uBlockedLineColor, uBlockedColor, coeff), 1.0);
}
