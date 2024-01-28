extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var animation_douche : AnimatedSprite2D = $Douche
	animation_douche.play("douche_coulante")


