extends Sprite2D

var vaseRempli : bool = false

func verifier(personnage : Personnage) -> bool :
	return vaseRempli

func _on_fleur_dans_vase():
	vaseRempli = true
