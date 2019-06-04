
void main()
{
    float normalisedPosition = v_path_distance / u_path_length;
    vec3 outClr = normalisedPosition > uPos ?
        uClrLeft : uClrRight;
    outClr = outClr * (0.4 * v_tex_coord.y + 0.6);
    gl_FragColor = vec4(outClr, 1.0);
}
