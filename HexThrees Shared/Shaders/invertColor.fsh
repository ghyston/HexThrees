void main()
{
    vec4 tex = texture2D(u_texture, v_tex_coord);
    gl_FragColor = vec4(1.0 - tex.x, 1.0 - tex.y, 1.0 - tex.z, 1.0);
}
