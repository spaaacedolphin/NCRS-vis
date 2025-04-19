shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float axis_width = 0.0003;
float on_x_axis(vec2 uv){	//I mean x-axis in "Simulation Coordinate", not to be confused w/ godot or uv coordiante
	return uv.y*float(abs(uv.x-0.5)<=axis_width);
}
float on_y_axis(vec2 uv){	//Same goes for y-axis
	return uv.x*float(abs(uv.y-0.5)<=axis_width);
}

uniform float unit = 0.02;
uniform float offset = 0.001;
float on_line(vec2 uv){
	uv -= vec2(0.5,0.5);
	vec2 q = cos((PI/unit)*uv);
	q = floor( q*q + offset );
	return clamp(q.x+q.y,0,1);
}

float fade(float r){
	r = clamp(r,0,0.5);
	return pow(cos(PI*r),2);
}

const vec2 center = vec2(0.5,0.5);
vec3 grid(vec2 uv){
	float r = distance(uv,center);
	float mask = fade(r);
	float t = mask * on_line(uv);
	return vec3(t);
}

uniform float max_color = 0.7;
uniform float max_alpha = 1.0;
void fragment() {
	vec3 color = vec3(on_x_axis(UV),on_y_axis(UV),0);
	color += float(length(color)==0.0)*grid(UV);
	color *= max_color;
	ALBEDO = color;
	EMISSION = color;
	ALPHA = clamp( color.b + float(color.b==0.0)*clamp(color.r+color.g,0,1) ,0,max_alpha);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
