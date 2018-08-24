void main()
{
    float step = fract(u_time * SPEED) * 0.05;
    vec4 result = vec4(0.0);
    
    for (float i = -COUNT; i < COUNT; i++)
    {
        vec2 tex_coord = v_tex_coord;
        tex_coord.x += i * step;
        vec4 sample = texture2D(u_texture, tex_coord);
        float coeff = (COUNT - abs(i)) / SUM;
        
        result += sample * coeff;
    }
    
    gl_FragColor = result;
}

