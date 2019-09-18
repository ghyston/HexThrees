void main()
{
    vec4 defaultShading = SKDefaultShading();
    //@todo: better mix by components
    float defaultBW = (defaultShading.r + defaultShading.g + defaultShading.b) / 5.0;
    gl_FragColor = v_tex_coord.y < uPos ?
        defaultShading :
        vec4(defaultBW, defaultBW, defaultBW, 1.0);
}

