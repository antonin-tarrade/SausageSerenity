extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("rose")
	return personnage.regarder_objet_present("rose")

