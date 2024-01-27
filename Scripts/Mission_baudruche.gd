extends Sprite2D

func init():
	frame = 2
	
func verifier(personnage : Personnage) -> bool :
	print("baudruche")
	var objets_autour = personnage.regarder_autour_objets()
	
	for obj in objets_autour :
		if (obj.get_id() == "baudruche"):
			return true
	return false
