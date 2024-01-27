extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("rose")
	personnage.regarder_objet_present("rose")
	return false

