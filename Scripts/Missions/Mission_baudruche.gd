extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("baudruche")
	return personnage.regarder_objet_present("baudruche")
	
