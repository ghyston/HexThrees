void main()
{
    float step = 0.05;
    float count = 5.0;
    vec4 result = vec4(0.0);
    
    // s(n) = (n * (n + 1)) / 2
    float sum = count * (count + 1.0) / 2.0;
    
    for (float i = -count; i < count; i++)
    {
        vec2 tex_coord = v_tex_coord;
        tex_coord.x += i * step;
        vec4 sample = texture2D(u_texture, tex_coord);
        float coeff = (count - abs(i)) / sum;
        
        result += sample * coeff;
    }
    
    gl_FragColor = result;
}

