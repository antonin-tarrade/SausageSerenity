extends Resource
class_name Item
@export var id = "" 
@export var icon:Texture2D

@export var isTakable = false
@export var isPushable = false
@export var isDestroyable = false

@export var collisionShape : Shape2D = null
@export var positionShape = Vector2(0,0)

# only for destroyable objects
@export var icon_destroyed_1: Texture2D
@export var icon_destroyed_2: Texture2D
@export var icon_destroyed_3: Texture2D

# object which appears when self is destroyed
@export var does_spawn_object: bool = false
@export var object: Item = null 
