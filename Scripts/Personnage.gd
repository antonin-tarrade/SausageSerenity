
class_name Personnage extends Sprite2D

@export var nom : String = ""
var requete : Sprite2D
@onready var missions : Array[Node] = ($"../Requete/Missions").get_children()
@onready var current_mission : int = 0
var animtree : AnimationTree
var zonedetectionobj : Area2D
var zonedetectionperso : Area2D


enum ETATS {
	triste,
	parle,
	heureux
}

var etat : ETATS

func _ready():

	etat = ETATS.triste
	requete = $"../Requete"
	zonedetectionobj = $ZoneDeDetectionObjets
	zonedetectionperso = $ZoneDeDetectionPersos
	animtree = $AnimationTree
	requete.visible = false
	for mission in missions:
		mission.visible = false
	


func _on_aboiement():
	if (etat != ETATS.heureux):
		verifier_requete()
		if (etat == ETATS.triste) :
			parler()
		
func _on_rendu_heureux():
	etat = ETATS.heureux
	self.material.set_shader_parameter("isSad",false)

func regarder_autour_objets():
	var listeobj = []
	for obj in zonedetectionobj.get_overlapping_bodies():
		if obj is RigidBody2D :
			listeobj.append(obj)
	return listeobj

func regarder_objet_present(nom:String) -> bool :
	var objets_autour = regarder_autour_objets()
	for obj in objets_autour :
		if (obj.get_id() == nom):
			return true
	return false
	
func regarder_autour_persos():
	return zonedetectionperso.get_overlapping_bodies()

func verifier_requete():
	var b = await missions[current_mission].verifier(self)
	if (b):
		missions[current_mission].visible = false;
		requete.visible = false
		if current_mission + 1 < missions.size():
			current_mission += 1
			parler()
		else :
			_on_rendu_heureux()

func parler():
	requete.visible = true;
	missions[current_mission].visible = true;
	await get_tree().create_timer(3.0).timeout
	requete.visible = false
	missions[current_mission].visible = false;
	if (etat == ETATS.parle) :
		etat = ETATS.triste

func set_etat(et):
	etat = et
	
