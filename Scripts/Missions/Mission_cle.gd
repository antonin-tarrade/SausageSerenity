extends Node

func init(personnage : Personnage):
	personnage.activer_collision()

func verifier(personnage : Personnage) -> bool :
	print("cle")
	if personnage.regarder_objet_present("cle"):
		personnage.desactiver_collision()
		return true
	else :
		return false
