shader_type canvas_item;

//uniform bool actif_droite = true;
//uniform bool actif_gauche = false;
uniform float pourcentage = 0;

void vertex() {
	VERTEX.x = VERTEX.x - VERTEX.y * pourcentage + 10.0*pourcentage;
	//if (actif_droite) {
	//	VERTEX.x = VERTEX.x - VERTEX.y;
	//} 
	//if (actif_gauche) {
	//	VERTEX.x = VERTEX.x + VERTEX.y;
	//}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
