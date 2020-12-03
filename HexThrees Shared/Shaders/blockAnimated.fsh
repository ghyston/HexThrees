void main()
{
    float steps = 7.0;
    
    float temp1 = v_tex_coord.x * steps;
    float temp2 = v_tex_coord.y * steps;
    
    float hline = abs(fract(temp1 + temp2) - 0.5) / fwidth(temp1 + temp2);
    float vline = abs(fract(temp1 - temp2) - 0.5) / fwidth(temp1 - temp2);
    
    float hcolor = 1.0 - min(hline, 1.0);
    float vcolor = 1.0 - min(vline, 1.0);
    
    //@todo: test playback reversed
    vec3 bgClr = uBgColor + (uBlockedColor - uBgColor) * uPos;
    float coef = (2.0 * (1.0 - uPos));
    
    bool isLine =
        (vcolor > 0.0 && (v_tex_coord.x + v_tex_coord.y) > coef) ||
        (hcolor > 0.0 && ((1.0 - v_tex_coord.x) + v_tex_coord.y) > coef);
    
    gl_FragColor = vec4(isLine ? uBlockedLineColor : bgClr, 1.0);
}
