extends CharacterBody2D

@export var SPEED = 300.0
@export var EXTENSION_SPEED = 4 # px
@export var SHRINKING_SPEED = 12 # px
@onready var timer : Timer = $Chargement
@onready var zoneFrappe : Area2D = $ZoneDeFrappe
@onready var PosTete : Marker2D = $PositionFrappe
@onready var zoneBarking : Area2D = $Barking
@onready var sprite: Sprite2D = $Sprite2D
@onready var a_tree: AnimationTree = $AnimationTree
@onready var c_shape: CollisionShape2D = $CollisionShape2D
@onready var zonePickUp : Area2D = $ZoneDePick
@onready var objetBouche : Sprite2D = $PivotObjet/ObjetBouche

const normal_size: Vector2 = Vector2(32, 24)
const normal_position: Vector2 = Vector2(0, -8)

# Variable Item

var objetGenerique : PackedScene = preload("res://Scenes/objet.tscn")
var iteminfo : Item = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turning_left: bool = false
var old_turning_left: bool = false
var extended: bool = false
enum extending_direction {LEFT, RIGHT, UP, DOWN}
var ed: int = -1

func _ready():
	a_tree.set("parameters/conditions/idle", is_on_floor() and (velocity.x == 0))
	a_tree.set("parameters/conditions/extending", Input.is_action_pressed("extend"))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and ed == -1:
		velocity.y += gravity * delta
		
	if Input.is_action_pressed("extend"):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if ed == -1:
			var horizontal: float = Input.get_axis("ui_left", "ui_right")
			var vertical: float = Input.get_axis("ui_down", "ui_up")
			ed = get_extending_direction(horizontal, vertical)
		else:
			extension(ed)
			
	elif ed != -1:
		ed = shrinkage(ed)
		
	elif Input.is_action_just_released("charger") and not timer.is_stopped():
		var f : float = timer.time_left	
		timer.stop()
		frapper(f)

	elif Input.is_action_pressed("charger") :
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	else :
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			turning_left = (direction < 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Update the character's rotation to match the direction of movement.
	if turning_left != old_turning_left:
		rotate_dog()
	old_turning_left = turning_left
	move_and_slide()


# get the direction in which the dog extends
func get_extending_direction(horizontal: float, vertical: float) -> int:
	if horizontal > 0:
		return extending_direction.RIGHT
	elif horizontal < 0:
		return extending_direction.LEFT
	elif vertical > 0:
		return extending_direction.UP
	elif vertical < 0:
		return extending_direction.DOWN
	else:
		return -1
		
# extends the dog in the right direction
func extension(ed: int) -> void:
	match ed:
		extending_direction.RIGHT:
			c_shape.shape.size.x += EXTENSION_SPEED
			c_shape.position.x += EXTENSION_SPEED / 2
		extending_direction.LEFT:
			c_shape.shape.size.x += EXTENSION_SPEED
			c_shape.position.x -= EXTENSION_SPEED / 2
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
			c_shape.position.y -= EXTENSION_SPEED / 2
			c_shape.shape.size.y += EXTENSION_SPEED
			
# shrink the dog in the right direction
func shrinkage(ed: int) -> int:
	var v: bool = false
	match ed:
		extending_direction.RIGHT:
			c_shape.shape.size.x -= SHRINKING_SPEED
			c_shape.position.x -= SHRINKING_SPEED / 2
			position.x += SHRINKING_SPEED * 2
		extending_direction.LEFT:
			c_shape.shape.size.x -= SHRINKING_SPEED
			c_shape.position.x += SHRINKING_SPEED / 2
			position.x -= SHRINKING_SPEED * 2
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
			c_shape.position.y += SHRINKING_SPEED / 2
			c_shape.shape.size.y -= SHRINKING_SPEED 
			position.y -= SHRINKING_SPEED * 2
			v = true
	if v and c_shape.shape.size.y <= normal_size.y:
		c_shape.position = normal_position
		c_shape.shape.size = normal_size
		return -1
	elif !v and c_shape.shape.size.x <= normal_size.x:
		c_shape.position = normal_position
		c_shape.shape.size = normal_size
		return -1
	else:
		return ed

func _input(event):
	if event.is_action_pressed("charger"):
		timer.start()
#	elif event.is_action_pressed("bark"):
#		for bodies : PhysicsBody2D in zoneBarking.get_overlapping_bodies():
#			if bodies is RigidBody2D :
#				print("wesh")
#				bodies.apply_central_impulse(Vector2(3.0, -30.0)*40)
	elif event.is_action_pressed("interact"):
		if iteminfo == null :
			PickUpOrOuaf()
		else :
			Drop()


func frapper(f : float):
	var puissance: float = 1/ (1 + exp((1-3*(timer.wait_time - f))))
	for objet : PhysicsBody2D in zoneFrappe.get_overlapping_bodies() :
		if objet is RigidBody2D :
			var vector : Vector2 = (objet.global_position - PosTete.global_position).normalized()
			objet.apply_central_impulse((vector + Vector2(0.0, -puissance).normalized()).normalized() * puissance * 1000)


func frapperFin():
	frapper(0.0)

func PickUpOrOuaf() :
	print("pickuporouaf")
	var aPickUp : bool = false
	for objet : PhysicsBody2D in zonePickUp.get_overlapping_bodies() :
		if objet is RigidBody2D :
			if objet.isTakable :
				objet.PickUp()
				aPickUp = true
				print("pick")
				break
	if (!aPickUp):
		for perso : PhysicsBody2D in zoneBarking.get_overlapping_bodies() :
			print("ouaf")
			perso.se_faire_aboyer()

func itemTaken(infoitem) :
	iteminfo = infoitem
	objetBouche.texture = iteminfo.icon
	
func Drop() :
	if iteminfo != null :
		var item = objetGenerique.instantiate()
		item.iteminfo = iteminfo
		item.global_position = objetBouche.global_position
		get_parent().add_child(item)
		iteminfo = null
		objetBouche.texture = null
		print("drop")

func rotate_dog():
	# Rotate colliders
	zoneFrappe.scale.x *= -1
	zoneBarking.scale.x *= -1
	zonePickUp.scale.x *= -1
	objetBouche.get_parent().scale.x *= -1
	# Rotate sprite
	sprite.flip_h = turning_left

	
