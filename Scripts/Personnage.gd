
class_name Personnage extends Sprite2D

@export var anim_triste: String
@export var anim_heureux: String
@export var nom : String = ""
@export var isTakable : bool = false
@onready var requete : Sprite2D = $"../Requete"
@onready var missions : Array[Node] = ($"../Requete/Missions").get_children()
@onready var current_mission : int = 0
@onready var static_body : StaticBody2D = $PersonnageBody
@onready var animation = $AnimationPlayer
var zonedetectionobj : Area2D
var zonedetectionperso : Area2D

# Gestion joie
@export var nbMissions : int = 11
var augmentation_joie : float = 1/nbMissions
@onready var decors : Node = %Decor/Background


enum ETATS {
	triste,
	parle,
	heureux
}

var etat : ETATS

func _ready():

	etat = ETATS.triste
	animation.current_animation = anim_triste
	zonedetectionobj = $ZoneDeDetectionObjets
	zonedetectionperso = $ZoneDeDetectionPersos
	requete.visible = false
	for mission in missions:
		mission.visible = false
		if mission.has_method("init") :
			mission.init(self)
	if isTakable :
		devenir_objet()
	


func _on_aboiement():
	if (etat != ETATS.heureux):
		verifier_requete()
		if (etat == ETATS.triste) :
			parler()
		
func _on_rendu_heureux():
	etat = ETATS.heureux
	animation.current_animation = anim_heureux
	self.material.set_shader_parameter("isSad",false)
	var taux_joie = decors.material.get_shader_parameter("taux_joie")
	decors.material.set_shader_parameter("taux_joie",taux_joie + augmentation_joie)

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

func activer_collision():
	static_body.set_collision_layer_value(1,true)

func desactiver_collision():
	static_body.set_collision_layer_value(1,false)
	
func devenir_objet():
	static_body.set_collision_layer_value(2,true)
	#static_body["input_pickable"] = true;
	


func set_etat(et):
	etat = et
	

