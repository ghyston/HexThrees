
void main()
{
    float steps = 7.0;
    
    float temp1 = v_tex_coord.x * steps;
    float temp2 = v_tex_coord.y * steps;
    
    float hline = abs(fract(temp1 + temp2) - 0.5) / fwidth(temp1 + temp2);
    float vline = abs(fract(temp1 - temp2) - 0.5) / fwidth(temp1 - temp2);
    
    //@todo: review, do we need this and how to optimise it
    float hcolor = 1.0 - min(hline, 1.0);
    float vcolor = 1.0 - min(vline, 1.0);
    
    bool isLine = (hcolor+vcolor > 0.0);
    
    gl_FragColor = vec4(isLine ? uBlockedLineColor : uBlockedColor, 1.0);
}
