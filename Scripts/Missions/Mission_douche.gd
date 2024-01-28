extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("douche")
	return personnage.regarder_objet_present("douche")
