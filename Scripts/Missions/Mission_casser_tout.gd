extends Sprite2D

var nbObjetCasse : int = 0
var nbObjet : int = 3 

func verifier(personnage : Personnage) -> bool :
	return (nbObjetCasse==3)

func _on_objet_casse():
	nbObjetCasse += 1
