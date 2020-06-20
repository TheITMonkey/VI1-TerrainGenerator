#version 410

layout(triangles, fractional_odd_spacing, ccw) in;

uniform	mat4 m_pvm;
uniform	mat3 m_normal;
uniform int texSize;

uniform sampler2D heightmap;

//uniform float alpha = 0.75;

in Data{
	vec4 positionTC;
	vec4 normalTC;
} DataIn[];

out Data {
	vec4 positionTE;
	vec3 normalTE;
} DataOut;
//out vec3 normalTE;

void main()
{
	vec4 P1 = DataIn[0].positionTC;
	vec4 P2 = DataIn[1].positionTC;
	vec4 P3 = DataIn[2].positionTC;
	vec4 n1 = DataIn[0].normalTC;
	vec4 n2 = DataIn[1].normalTC;
	vec4 n3 = DataIn[2].normalTC;
	
	float u = gl_TessCoord.x;
	float v = gl_TessCoord.y;
	float w = 1 - u - v;
	
	vec4 Puv = P1*w + P2*u + P3*v;
	vec4 Proj1 = Puv - (dot(Puv-P1, n1)) * n1;
	vec4 Proj2 = Puv - (dot(Puv-P2, n2)) * n2;
	vec4 Proj3 = Puv - (dot(Puv-P3, n3)) * n3;
	
	float alpha = 0.75;
				
	vec4 res =  (1 - alpha) * Puv  + alpha * (Proj1 * w + Proj2 * u + Proj3 * v);
	
	// GETTING VALUES FROM THE TEXTURE
	ivec2 texPos = ivec2(floor(res).xz);
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
	
	DataOut.positionTE = vec4(res.x, heightValue, res.z, 1.0);
	//DataOut.normalTE = normalize(m_normal * normalValue);
	DataOut.normalTE = normalize(normalValue);
	// normalTE = normalize(normalMatrix * vec3(n1*w + n2*u + n3*v));
	
	gl_Position = m_pvm * DataOut.positionTE;
}