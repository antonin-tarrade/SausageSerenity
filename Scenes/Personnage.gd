extends Sprite2D

var nom : String = ""
var requete : Sprite2D
var animtree : AnimationTree

enum ETATS {
	triste,
	parle,
	heureux
}

var etat : ETATS

func _ready():
	etat = ETATS.triste
	requete = $Requete
	animtree = $AnimationTree
	requete.visible = false
	_on_aboiement()

func _process(_delta):
	pass

func _on_aboiement():
	if (etat != ETATS.parle) :
		parler()
		
func _on_rendu_heureux():
	etat = ETATS.heureux
	print("avant " + str(self.material.get_shader_parameter("shader_parameter/isColored")))
	var estcolore = false
	self.material.set_shader_parameter("shader_parameter/isColored",estcolore)
	print("apres " + str(self.material.get_shader_parameter("shader_parameter/isColored")))

	
	
func parler():
	requete.visible = true;
	await get_tree().create_timer(3.0).timeout
	requete.visible = false
	if (etat == ETATS.parle) :
		etat = ETATS.triste
	
	_on_rendu_heureux()
