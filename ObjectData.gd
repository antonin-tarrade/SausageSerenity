extends Resource
class_name Item
@export var id = "" 
@export var icon:Texture2D

@export var isTakable = false
@export var isPushable = false
@export var isDestroyable = false

@export var collisionShape : Shape2D = null
@export var positionShape = Vector2(0,0)
