extends Sprite2D

var vaseRempli : bool = false

func init():
	frame = 3

func verifier(personnage : Personnage) -> bool :
	return vaseRempli

func _on_fleur_dans_vase():
	vaseRempli = true
