extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("ballon appart")
	return personnage.regarder_objet_present("ballon_appart")
