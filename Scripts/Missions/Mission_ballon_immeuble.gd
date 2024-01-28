extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("ballon immeuble")
	return personnage.regarder_objet_present("ballon_immeuble")
