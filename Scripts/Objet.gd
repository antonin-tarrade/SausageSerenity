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

signal destroyed

var id : String = ""

# Variable du chien

@onready var dog = $"../../ChienSaucisse"
var dog_mouth_pos = Vector2(0,0)

func _ready():
	# On charge les informations de l'objet
	load_resource()
	dog.objetsnode = get_parent()


func get_id() -> String :
	return id

func get_isTakable() -> bool :
	return isTakable

func PickUp() :
	print("press")
	if isTakable :
		if dog != null:
			print("dog null")
			dog.itemTaken(iteminfo)
			self.queue_free()

func detruire():
	if isDestroyable:
		isDestroyed = true;
		print("detruit")
		self.visible = false
		

func load_resource() :
	self.isTakable = iteminfo.isTakable
	self.isPushable = iteminfo.isPushable
	self.isDestroyable = iteminfo.isDestroyable
	#Set sprite
	self.itemTexture.texture = iteminfo.icon
	self.id = iteminfo.id


func _on_body_entered(body):
	print("what")
	if isDestroyed:
		print("detruit et touché sol")
		destroyed.emit()
		queue_free()
