extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("chat")
	return personnage.regarder_objet_present("chat")
