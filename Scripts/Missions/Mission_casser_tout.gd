extends Sprite2D

var nbObjetCasse : int = 0
var nbObjet : int = 3 

func verifier(personnage : Personnage) -> bool :
	print("faut tout casser")
	#verifier si objet casse (id = "toutcasser")
	return (nbObjetCasse==3)

func _on_objet_casse():
	nbObjetCasse += 1
