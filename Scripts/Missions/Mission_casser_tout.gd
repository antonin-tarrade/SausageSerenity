extends Sprite2D

var nbObjetCasse : int = 0
@export var objets : Array[Objet] = []

func init(_personnage : Personnage) :
	for obj in objets:
		obj.destroyed.connect(_on_casser)

func verifier(_personnage : Personnage) -> bool :
	print("faut tout casser")
	return (nbObjetCasse==objets.size())
	
func _on_casser():
	nbObjetCasse += 1
