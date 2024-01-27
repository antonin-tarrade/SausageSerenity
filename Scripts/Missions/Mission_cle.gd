extends Node

func verifier(personnage : Personnage) -> bool :
	print("cle")
	var objets_autour = personnage.regarder_autour_objets()
	
	for obj in objets_autour :
		if (obj.get_id() == "cle"):
			return true
	return false
