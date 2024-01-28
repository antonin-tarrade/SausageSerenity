extends StaticBody2D


@onready var dog = $"../../../../ChienSaucisse"
@onready var perso = $".."
@onready var node_principal = $"../.."
signal ouaf

func se_faire_aboyer():
	ouaf.emit()
	

func get_isTakable() -> bool :
	return perso.isTakable

func PickUp() :
	if perso.isTakable :
		dog.humanTaken(node_principal)
		node_principal.visible = false
