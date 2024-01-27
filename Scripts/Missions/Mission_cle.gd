extends Node

func verifier(personnage : Personnage) -> bool :
	print("cle")
	return personnage.regarder_objet_present("cle")
