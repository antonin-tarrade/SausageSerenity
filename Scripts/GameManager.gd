class_name GameManager extends Node2D

@export var nbMissions : float = 11.0
var nbMissionsFinies : float = 0.0
var avancement: int = 0
@onready var audio_player = $"../AudioStreamPlayer"
@onready var musique_0 = load("res://Musiques/chien_saucisse_lvl0.mp3")
@onready var musique_1 = load("res://Musiques/chien_saucisse_lvl1.mp3")
@onready var musique_2 = load("res://Musiques/chien_saucisse_lvl2.mp3")
@onready var musique_3 = load("res://Musiques/chien_saucisse_lvl3.mp3")

func _ready():
	%LayerFin.visible = false
	audio_player.stream = musique_0
	audio_player.play() 
	
	
func _process(_delta):
	if Input.is_action_pressed("quitter"):
		get_tree().quit(0)

func _on_mission_fini():
	nbMissionsFinies += 1.0
	var pourcent = get_pourcentage_fini()
	if pourcent > avancement*0.25:
		avancement += 1
		play_music(avancement)

func get_pourcentage_fini() -> float :
	return nbMissionsFinies/nbMissions

func fin_ultime():
	%LayerFin.visible = true
	%LayerFin.activate_anim()
	
func play_music(advancement: int) -> void:
	match advancement:
		1:
			audio_player.stream = musique_1
		2:
			audio_player.stream = musique_2
		3:
			audio_player.stream = musique_3
	audio_player.play()
