﻿#ifdef GL_ES
precision highp float;
#endif

varying vec2 vPosition;
varying vec2 vUV;

uniform float numberOfBricksHeight;
uniform float numberOfBricksWidth;

float rand(vec2 n) {
	return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 4; i++) {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= 0.5;
	}
	return total;
}

float round(float number){
	return sign(number)*floor(abs(number) + 0.5);
}

void main(void)
{
	vec3 brick = vec3(0.77, 0.47, 0.40);
	vec3 joint = vec3(0.72, 0.72, 0.72);

	float brickW = 1.0 / numberOfBricksWidth;
	float brickH = 1.0 / numberOfBricksHeight;
	float jointWPercentage = 0.01;
	float jointHPercentage = 0.05;

	vec3 color = brick;


	float yi = vUV.y / brickH;
	float nyi = round(yi);

	float xi = vUV.x / brickW;

	if (mod(floor(yi), 2.0) == 0.0){
		xi = xi - 0.5;
	}

	float nxi = round(xi);



	if (yi < nyi + jointHPercentage && yi > nyi - jointHPercentage){
		color = mix(joint, vec3(0.37, 0.25, 0.25), (yi - nyi) / jointHPercentage + 0.2);
	}
	else if (xi < nxi + jointWPercentage && xi > nxi - jointWPercentage){
		color = mix(joint, vec3(0.44, 0.44, 0.44), (xi - nxi) / jointWPercentage + 0.2);
	}
	else {
		float momo = mod(floor(yi) + floor(xi), 3.0);

		if (momo == 0.0)
			color = mix(color, vec3(0.33, 0.33, 0.33), 0.3);
		else if (momo == 2.0)
			color = mix(color, vec3(0.11, 0.11, 0.11), 0.3);


		//color = mix(color, vec3(0.1, 0.1, 0.1), fbm(vUV * 64.0));
	}


	gl_FragColor = vec4(color, 1.0);
}