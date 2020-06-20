#version 420

uniform mat4 m_view;
uniform vec4 l_dir;

in Data {
	vec4 positionTE;
	vec3 normalTE;
	//vec3 l_dir;
	//vec4 color;
	//float height;
	//vec2 tc;
	//vec3 eye;
} DataIn;

out vec4 outputF;

void main()
{
	vec3 ln = normalize(vec3(m_view * -l_dir));
	vec3 nn = normalize(DataIn.normalTE);
	float intensity = max(dot(ln, nn), 0.0);
	intensity = 1.0;
	

	float scale = 0.1;

	//vec3 n = normalize(DataIn.normal);
	//float intensity = max(0.0, dot(n, DataIn.l_dir));

	float a = clamp((nn.y - 0.6)* 5 + 0.5, 0, 1);

	vec4 water = vec4(0.0, 0.0, 1.0, 1.0);
	vec4 relva = vec4(0.25, 0.87, 0.1, 1.0);
	vec4 neve = vec4(0.75, 0.75, 0.75, 1.0);

	vec4 terra = vec4(0.78, 0.45, 0.1, 1.0);

	
	if (DataIn.positionTE.y < 0.0) {
		//cOut.xyz = uncharted2Tonemap(roca.xyz);
		outputF = water * intensity;
	} else {
		float hscaled = DataIn.positionTE.y * 2.0;
		float hi = int(hscaled);
		float hfrac = hscaled - float(hi);
		if (hscaled > 78.0) {
			outputF = neve * intensity;
            //outputF.xyz = mix(mix(terra, neve, hfrac), mix(terra, neve, hfrac), hfrac).xyz * intensity; // blends between the two colours 
        } else {
			if (hscaled > 50.0 && hscaled < 78.0) {
				outputF = relva * intensity;
				//outputF.xyz = mix(mix(terra, terra, hfrac), mix(terra, neve, hfrac), hfrac).xyz * intensity;
			} else {
				outputF.xyz = terra.xyz * intensity;
			}
		}
	}
}