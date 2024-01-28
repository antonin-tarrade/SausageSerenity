extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("attendre romantique")
	# plus complexe car on veut que la meuf envoie un mot doux à l'autre donc que ce soit l'autre qui envoie un signal quand elle a reçu la lettre
	return personnage.regarder_objet_present("lettre")
	
