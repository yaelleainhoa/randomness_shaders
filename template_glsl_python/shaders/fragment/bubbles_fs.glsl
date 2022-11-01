#version 330

out vec4 fragColor;

uniform vec2 resolution;
uniform int nb_circles;
uniform vec3 circles[100];



void main() {
    vec2 uv = (gl_FragCoord.xy- 0.5 * resolution.xy)/resolution.y;
    vec3 light_brown = vec3(204./255., 139./255., 84./255.);
    vec3 brown = vec3(77./255., 38./255., 19./255.);
    vec3 col = vec3(0.);
    for(int i=0; i<nb_circles; i++){
        if (distance(uv, circles[i].xy)<circles[i].z){
            float dist = distance(uv, circles[i].xy)/circles[i].z;
            col = vec3(1.-dist);
            break;
        }
    }
    fragColor = vec4(col, 1.0);
}