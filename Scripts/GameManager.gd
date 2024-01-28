class_name GameManager extends Node2D

@export var nbMissions : float = 11.0
var nbMissionsFinies : float = 0.0

func _on_mission_fini():
	nbMissionsFinies += 1.0

func get_pourcentage_fini() -> float :
	return nbMissionsFinies/nbMissions
