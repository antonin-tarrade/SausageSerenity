extends Sprite2D

var nbObjetCasse : int = 0
@export var objets : Array[Objet] = []

func verifier(personnage : Personnage) -> bool :
	print("faut tout casser")
	nbObjetCasse = 0
	for obj in objets:
		if obj.isDestroyed:
			nbObjetCasse += 1
	return (nbObjetCasse==objets.size())

