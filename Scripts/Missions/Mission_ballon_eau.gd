extends Sprite2D

@export var ballon : Objet = null
var touche : bool = false

func init(_personnage : Personnage) :
	ballon.connect("destroyed",_on_destroyed)

func verifier(_personnage : Personnage) -> bool :
	print("ballon eau")
	return touche

func _on_destroyed():
	print("heeeeeeeeeeeeeere mission")
	pass
