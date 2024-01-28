extends StaticBody2D


@onready var dog = $"../../../../ChienSaucisse"
@onready var perso = $".."
signal ouaf

func se_faire_aboyer():
	ouaf.emit()
	

func get_isTakable() -> bool :
	return perso.isTakable

func PickUp() :
	if perso.isTakable :
		dog.humanTaken(perso)
		perso.visible = false
