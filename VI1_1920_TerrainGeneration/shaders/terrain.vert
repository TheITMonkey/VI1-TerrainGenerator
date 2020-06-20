#version 430

//uniform mat4 m_pvm;
//uniform mat3 m_normal;
//uniform mat4 m_view;
//uniform vec4 l_dir;
uniform vec4 camera_pos;
uniform int texSize;

uniform sampler2D heightmap;

in vec4 position;
in vec4 normal;
//in vec2 texCoord0;


out Data {
	vec4 positionV;
	vec4 normalV;
	//vec3 l_dir;
	//vec4 color;
	//float height;
	//vec2 tc;
	//vec3 eye;
} DataOut;

void main()
{
	vec3 cam = floor(camera_pos.xyz);
	vec4 work_pos = vec4(position.x + cam.x, position.y, position.z + cam.z, 1.0);
	
	
	// GETTING VALUES FROM THE TEXTURE
	ivec2 texPos = ivec2(floor(work_pos).xz);
	if (texPos.x >= texSize) {
		int dv = texPos.x / texSize;
		int md = int(mod(texPos.x, texSize));
		texPos.x = abs(int(mod(dv, 2)) * (texSize - 1) - md);
	} else {
		if (texPos.x < 0) {
			int dv = (-texPos.x) / texSize;
			int md = int(mod((-texPos.x), texSize));
			texPos.x = abs((int(mod(dv, 2))) * (texSize - 1) - md);
		}
	}
	if (texPos.y >= texSize) {
		int dv = texPos.y / texSize;
		int md = int(mod(texPos.y, texSize));
		texPos.y = abs(int(mod(dv, 2)) * (texSize - 1) - md);
	} else {
		if (texPos.y < 0) {
			int dv = (-texPos.y) / texSize;
			int md = int(mod((-texPos.y), texSize));
			texPos.y = abs((int(mod(dv, 2))) * (texSize - 1) - md);
		}
	}
	vec4 ht = texelFetch(heightmap, texPos, 0);
	float heightValue = ht.x;
	vec3 normalValue = ht.yzw;
	//float ht = imageLoad(heightmap, ivec3(work_pos.xz, 0)).x;
	//float h = mod(abs((work_pos.x * work_pos.z) + work_pos.x + work_pos.z), 8);
	DataOut.positionV = vec4(work_pos.x, heightValue, work_pos.z, 1.0);
	
	//DataOut.color = vec4(0.8, 0.2, 0.2, 1.0);
	//DataOut.tc = texCoord0;
	DataOut.normalV = vec4(normalize(normalValue), 0.0);
	//DataOut.normalV = normalize(m_normal * normalValue);
	//DataOut.l_dir = vec3(normalize(- (m_view * l_dir)));
	//DataOut.height = new_pos.y;
	//gl_Position = m_pvm * new_pos;
}