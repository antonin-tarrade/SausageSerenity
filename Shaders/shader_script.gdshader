shader_type canvas_item;

uniform float taux_joie = 0.0;

void fragment() {
	vec4 c = COLOR;
	float cgris = (c.r + c.g + c.b)/3.0;
	COLOR = (1.-taux_joie)*vec4(cgris,cgris,cgris,1.) + c*taux_joie;
	
}