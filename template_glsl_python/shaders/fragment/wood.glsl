#version 330

out vec4 fragColor;

uniform vec2 resolution;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.98,78.233)))
                * 29.55);//43908.5453); //27.01; //29.55;
}

float hash(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float hash_noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( hash( i + vec2(0.0,0.0) ), 
                     hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ), 
                     hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

float perlin(vec2 uv){
    float f = 0.0;
    uv *= 1.0;
    mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );
	f  = 0.5000*hash_noise( uv ); uv = m*uv;
	f += 0.2500*hash_noise( uv ); uv = m*uv;
	f += 0.1250*hash_noise( uv ); uv = m*uv;
	f += 0.0625*hash_noise( uv ); uv = m*uv;
    f = 0.5 + 0.9*f;
    //f *= smoothstep( 0.0, 0.005, abs(p.x-0.6) );
    return f;
}


// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( random( i + vec2(0.0,0.0) ),
                     random( i + vec2(1.0,0.0) ), u.x),
                mix( random( i + vec2(0.0,1.0) ),
                     random( i + vec2(1.0,1.0) ), u.x), u.y);
}

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

float lines(in vec2 pos, float b){
    float scale = 4.2;
    pos *= scale;
    float line = abs(sin(pos.x*3.1415+noise(pos)));
    vec2 pos_lighter_lines = pos*2.;
    line += abs(sin(pos_lighter_lines.x*3.1415+(noise(pos*10.)/2.)))/1.3;
    vec2 pos_lightest_lines = pos*12.;
    line += abs(sin(pos_lightest_lines.x*3.1415+(noise(pos*20.)/2.)))/4.;
    return line;
}


void main() {
    vec2 uv = gl_FragCoord.xy/resolution.xy;
    uv.x *= resolution.y/resolution.x;
   
    vec2 pos = uv.xy*vec2(1.,4.);
    
    float pattern = pos.y;

    pos = rotate2d( noise(pos) ) * pos;

    pattern = lines(pos,0.5);
    
    vec3 light_brown = vec3(204./255., 139./255., 84./255.);
    vec3 brown = vec3(77./255., 38./255., 19./255.);
    float perlin_noise = perlin(gl_FragCoord.xy/resolution.xy);
    
    vec3 color = mix(vec3(77./255., 38./255., 19./255.)*perlin_noise, 
    vec3(124./255., 77./255., 38./255.)*perlin_noise, pattern);
   
    // Output to screen
    fragColor = vec4(color,1.);
    
}