#version 330

out vec4 fragColor;

uniform vec2 resolution;
uniform float time;

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
    vec3 col = 0.5 + 0.5*cos(time+uv.xyx+vec3(0,2,4));
    fragColor = vec4(col, 1.0);
}