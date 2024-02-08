class_name Objet
extends RigidBody2D

# Variable d'état

@export var Packed_destroyed_part: PackedScene
@export var iteminfo:Item
@export var max_v: float = 300.0
@onready var itemTexture = get_node("ObjetTexture")
@onready var collider = get_node("CollisionObjet")
var isTaken = false
var isPushed = false
var isDestroyed = false

var isTakable = false
var isPushable = false
var isDestroyable = false

var destroyed_parts = []

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

func destroy():
	destroyed.emit()
	for i in range(0, 3):
		var destroyed_part: RigidBody2D = Packed_destroyed_part.instantiate()
		destroyed_part.get_node("Sprite").texture = destroyed_parts[i]
		get_parent().add_child(destroyed_part)
		destroyed_part.position = position + Vector2(5*i, 5*i) 
	self.queue_free()

func load_resource() :
	self.isTakable = iteminfo.isTakable
	self.isPushable = iteminfo.isPushable
	self.isDestroyable = iteminfo.isDestroyable
	#Set sprite
	self.itemTexture.texture = iteminfo.icon
	self.id = iteminfo.id
	print(self.id)
	print(iteminfo.positionShape)
	collider["shape"] = iteminfo.collisionShape
	collider["position"] = iteminfo.positionShape
	
	if isDestroyable:
		destroyed_parts.append(iteminfo.icon_destroyed_1)
		destroyed_parts.append(iteminfo.icon_destroyed_2)
		destroyed_parts.append(iteminfo.icon_destroyed_3)
	
func _physics_process(_delta):
	
	if isDestroyable and sqrt(linear_velocity.dot(linear_velocity)) >= max_v:
		destroy()

