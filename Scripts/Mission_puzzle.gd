extends Sprite2D

func init():
	frame = 8

func verifier(personnage : Personnage) -> bool :
	print("puzzle")
	await get_tree().create_timer(2.0).timeout
	return true
