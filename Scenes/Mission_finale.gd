extends Sprite2D

func verifier(personnage : Personnage) -> bool :
	print("mission finale")
	if personnage.gm.get_pourcentage_fini() >= 0.98 :
		personnage.gm.fin_ultime()
		return true
	return false

