extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("ballon appart")
	var objets_autour = personnage.regarder_autour_objets()
	for obj in objets_autour :
		if (obj.get_id() == "ballon_appart"):
			return true
	return false
