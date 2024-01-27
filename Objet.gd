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

@onready var dog = get_node("../chiensaucisse")
var dog_mouth_pos = Vector2(0,0)	

func _ready():
	# On charge les informations de l'objet
	load_resource()



func on_taken_action_pressed() :
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



func _on_chiensaucisse_action_pressed():
	pass # Replace with function body.
