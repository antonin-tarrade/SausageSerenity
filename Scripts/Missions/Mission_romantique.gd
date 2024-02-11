extends Sprite2D

var recu : bool = false

func verifier(_personnage : Personnage) -> bool :
	print("romantique")
	return recu
	


func _on_mission_attendre_romantique_lettrerecu():
	recu = true;
