extends Sprite2D

signal lettrerecu

func verifier(personnage : Personnage) -> bool :
	print("attendre romantique")
	if personnage.regarder_objet_present("lettre") :
		lettrerecu.emit()
		return true
	return false
	
