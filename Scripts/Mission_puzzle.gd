extends Sprite2D

var nbPiecesTrouvees : int = 0
var nbPieces : int = 2

func init():
	frame = 8

func verifier(personnage : Personnage) -> bool :
	print("puzzle")
	var objets_autour = personnage.regarder_autour_objets()
	for obj in objets_autour:
		if (obj.get_id() == "puzzle"):
			obj.queue_free()
			nbPiecesTrouvees += 1
	if nbPiecesTrouvees == nbPieces :
		return true
	else :
		return false
