class_name Objet
extends RigidBody2D



# Variable d'état

@export var iteminfo:Item
@onready var itemTexture = get_node("ObjetTexture")
@onready var collider = get_node("CollisionObjet")
var isTaken = false
var isPushed = false
var isDestroyed = false

var isTakable = false
var isPushable = false
var isDestroyable = false

# Variable du chien

@onready var dog = $"../ChienSaucisse"
var dog_mouth_pos = Vector2(0,0)	

func _ready():
	# On charge les informations de l'objet
	load_resource()



func PickUp() :
	print("press")
	if isTakable :
		dog.itemTaken(iteminfo)
		self.queue_free()
	
		
func load_resource() :
	self.isTakable = iteminfo.isTakable
	self.isPushable = iteminfo.isPushable
	self.isDestroyable = iteminfo.isDestroyable
	#Set sprite
	self.itemTexture.texture = iteminfo.icon
