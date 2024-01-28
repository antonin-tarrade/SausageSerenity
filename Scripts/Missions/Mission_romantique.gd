extends Sprite2D

var recu : bool = false

func verifier(personnage : Personnage) -> bool :
	print("romantique")
	# plus complexe car on veut que la meuf envoie un mot doux à l'autre donc que ce soit l'autre qui envoie un signal quand elle a reçu la lettre
	return recu
	


func _on_mission_attendre_romantique_lettrerecu():
	recu = true;
