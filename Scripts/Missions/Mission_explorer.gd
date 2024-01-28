extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("explorateur")
	# verifier position du joueur pour voir si bien sur le toit ( à 2 doigt d'y mettre un objet invisible)
	return personnage.regarder_objet_present("exploration")
	
