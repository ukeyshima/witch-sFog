precision mediump float;
uniform float iTime;
uniform vec2 iResolution;
#define PI 3.141592

float random1(vec3 p){
    return fract(sin(dot(p.xyz,vec3(12.9898,46.2346,78.233)))*43758.5453123)*2.0-1.0;
}

float random2(vec3 p){
    return fract(sin(dot(p.xyz,vec3(73.6134,21.6712,51.5781)))*51941.3781931)*2.0-1.0;
}

float random3(vec3 p){
    return fract(sin(dot(p.xyz,vec3(39.1831,85.3813,16.2981)))*39183.4971731)*2.0-1.0;
}

float perlinNoise(vec3 p){
    vec3 i1=floor(p);    
    vec3 i2=i1+vec3(1.0,0.0,0.0);
    vec3 i3=i1+vec3(0.0,1.0,0.0);
    vec3 i4=i1+vec3(1.0,1.0,0.0);
    vec3 i5=i1+vec3(0.0,0.0,1.0);
    vec3 i6=i1+vec3(1.0,0.0,1.0);
    vec3 i7=i1+vec3(0.0,1.0,1.0);
    vec3 i8=i1+vec3(1.0,1.0,1.0);
    vec3 f1=vec3(random1(i1),random2(i1),random3(i1));
    vec3 f2=vec3(random1(i2),random2(i2),random3(i2));
    vec3 f3=vec3(random1(i3),random2(i3),random3(i3));
    vec3 f4=vec3(random1(i4),random2(i4),random3(i4));
    vec3 f5=vec3(random1(i5),random2(i5),random3(i5));
    vec3 f6=vec3(random1(i6),random2(i6),random3(i6));
    vec3 f7=vec3(random1(i7),random2(i7),random3(i7));
    vec3 f8=vec3(random1(i8),random2(i8),random3(i8));
    vec3 k1=p-i1;
    vec3 k2=p-i2;
    vec3 k3=p-i3;
    vec3 k4=p-i4;
    vec3 k5=p-i5;
    vec3 k6=p-i6;
    vec3 k7=p-i7;
    vec3 k8=p-i8;
    vec3 j=fract(p);
    j=j*j*(3.0-2.0*j);
	return mix(mix(mix(dot(f1,k1),dot(f2,k2),j.x),mix(dot(f3,k3),dot(f4,k4),j.x),j.y),mix(mix(dot(f5,k5),dot(f6,k6),j.x),mix(dot(f7,k7),dot(f8,k8),j.x),j.y),j.z)*0.95+0.05;
}

float octavePerlinNoise(vec3 p){
    float value=0.0;
    float maxValue=0.0;
    for(float i=0.0;i<5.0;i++){
        value+=pow(0.5,i)*perlinNoise(vec3(p.x*pow(2.0,i),p.y*pow(2.0,i),p.z*pow(2.0,i)));
        maxValue+=pow(0.5,i);
    }
    return value/maxValue;
}

vec3 rayMarching(vec2 p) {
    vec3 cPos = vec3(0.0, 0.0, iTime/5.0);
    vec3 cDir = vec3(0.0, 0.0, 1.0);
    vec3 cUp = vec3(sin(iTime/30.0), cos(iTime/30.0), 0.0);
    float depth = 1.0;    
    vec3 cSide = cross(cDir, cUp);
    vec3 ray = normalize(cSide * p.x + cUp * p.y + cDir * depth);
    vec3 rPos = cPos;    
    vec3 color = vec3(50.0,0.0,0.0);
    for (float i = 0.0; i < 5.0; i++) {
        color+=vec3(1.0/octavePerlinNoise(rPos));
        color=mix(color,mod(color,0.5),0.5);        
        rPos+=ray*2.0;
    }
  return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p =
      (fragCoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);
    vec3 color = rayMarching(p);
    fragColor =vec4(color,1.0);
}