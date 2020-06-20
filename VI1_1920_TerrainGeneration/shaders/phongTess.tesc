#version 410

layout(vertices = 3) out;

in Data {
	vec4 positionV;
	vec4 normalV;
} DataIn[];

out Data {
	vec4 positionTC;
	vec4 normalTC;
} DataOut[];

uniform float olevel = 1;
uniform float ilevel = 1;

void main() {
	DataOut[gl_InvocationID].positionTC = DataIn[gl_InvocationID].positionV;
	DataOut[gl_InvocationID].normalTC = DataIn[gl_InvocationID].normalV;
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = olevel;
		gl_TessLevelOuter[1] = olevel;
		gl_TessLevelOuter[2] = olevel;
		gl_TessLevelInner[0] = ilevel;
	}
}