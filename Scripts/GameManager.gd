class_name GameManager extends Node2D

@export var nbMissions : int = 11
var nbMissionsFinies : int = 0

func _on_mission_fini():
	nbMissionsFinies += 1

func get_pourcentage_fini() -> float :
	return nbMissionsFinies/nbMissions
