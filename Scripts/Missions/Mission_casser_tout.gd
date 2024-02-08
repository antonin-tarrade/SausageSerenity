extends Sprite2D

var nbObjetCasse : int = 0
@export var objets : Array[Objet] = []

func init(personnage : Personnage) :
	for obj in objets:
		obj.destroyed.connect(_on_casser)

func verifier(personnage : Personnage) -> bool :
	print("faut tout casser")
	#nbObjetCasse = 0
	#for obj in objets:
	#	if obj.isDestroyed:
	#		nbObjetCasse += 1
	return (nbObjetCasse==objets.size())
	
func _on_casser():
	nbObjetCasse += 1
