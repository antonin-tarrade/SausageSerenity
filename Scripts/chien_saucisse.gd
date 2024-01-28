extends CharacterBody2D

var icon_pied = preload("res://Dessins/mec.png")

@onready var zonePickUp : Area2D = $ZoneDePick
@onready var objetBouche : Sprite2D = $Head/PivotObjet/ObjetBouche
@export var SPEED = 200.0
@export var EXTENSION_SPEED = 4 # px
@export var SHRINKING_SPEED = 6 # px
@export var MAX_EXTENSION = 150 # px
@export var alpha = 0.2
@export var step = 0.2
@export var beta = 0.7
@onready var camera : Camera2D = $Camera2D
@onready var timer : Timer = $Chargement
@onready var zoneFrappe : Area2D = $ZoneDeFrappe
@onready var PosTete : Marker2D = $PositionFrappe
@onready var zoneBarking : Area2D = $Barking
@onready var head: Sprite2D = $Head
@onready var back: Sprite2D = $Back
@onready var body_side: Sprite2D = $BodySide
@onready var body_up: Sprite2D = $BodyUp
@onready var head_tree: AnimationTree = $AnimationTree
@onready var back_tree: AnimationTree = $AnimationTree2
@onready var all_tree: Array[AnimationTree] = [head_tree,back_tree]
@onready var c_polygon: CollisionPolygon2D = $CollisionPolygon2D
# 0 bottom-left
# 1 bottom-right
# 2 top-right
# 3 top-left
@onready var normal_polygon: PackedVector2Array = c_polygon.polygon
@onready var normal_position: Vector2 = c_polygon.position
@onready var object_up_pos = Vector2(2,-12)
@onready var object_side_pos = Vector2(-12,-3)



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turning_right: bool = false
var old_turning_right = false
var extended: bool = false
var max_ex: bool = false
enum extending_direction {LEFT, RIGHT, UP, DOWN}
var ed: int = -1
var old_e: float = 0.0
var x: int = 0
var old_s: float = 0.0
var y: int = 0
# Variable Item

var objetGenerique : PackedScene = preload("res://Scenes/objet.tscn")
var iteminfo : Item = null
var humaninfo = null
var objetsnode = null
@onready var walldetect = $WallDetect/ColWall
var HaveWallTouched = false

@onready var head_position = head.position
@onready var back_position = back.position
@onready var body_up_position = body_side.position
@onready var body_side_position = body_up.position

@onready var is_extended = false


func _ready():
	body_side.region_rect = Rect2(0,0,0,32)
	body_up.region_rect = Rect2(0,0,32,0)
	
func _physics_process(delta):
	
	for tree in all_tree : 
		tree.set("parameters/conditions/idle", is_on_floor() and (velocity.x == 0) and !is_extended)
		tree.set("parameters/conditions/is_moving", velocity.x != 0)
	if is_on_floor() and !is_extended : objetBouche.position = object_side_pos
	if not is_on_floor() and ed == -1:
		velocity.y += gravity * delta
		
	if Input.is_action_pressed("extend") and not is_on_ceiling() and not is_on_wall() and !max_ex and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if ed == -1:
			var horizontal: float = Input.get_axis("ui_left", "ui_right")
			var vertical: float = Input.get_axis("ui_down", "ui_up")
			ed = get_extending_direction(horizontal, vertical)
		else:
			max_ex = extension()
			x += 1
			
	elif ed != -1:
		if x != 0:
			x = 0
			old_e = 0.0
		ed = shrinkage()
		y += 1
		for tree in all_tree :
			tree.set("parameters/conditions/extending_side", false)
			tree.set("parameters/conditions/extending_up", false)
				
		
	elif Input.is_action_just_released("charger") and not timer.is_stopped():
		var f : float = timer.time_left	
		timer.stop()
		frapper(f)

	elif Input.is_action_pressed("charger") :
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	else :
		
		if y != 0:
			y = 0
			old_s = 0
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			turning_right = (direction > 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	if turning_right != old_turning_right:
		rotate_dog()
	old_turning_right = turning_right
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
func extension() -> bool:
	is_extended = true
	var e: float = math_extension(step*x)
	var mov = e - old_e
	match ed:
		extending_direction.RIGHT:
			for tree in all_tree :
				tree.set("parameters/conditions/extending_side", true)
			head.position.x += mov
			body_side.region_rect.size[0] = abs(head.position.x - back.position.x) + 10
			body_side.position.x = (head.position.x + back.position.x)/2
			if !turning_right : turning_right = true
			c_polygon.polygon[1].x += mov
			c_polygon.polygon[2].x += mov
			move_detector(c_polygon.polygon[1], c_polygon.polygon[2])
			camera.position.x += mov
		extending_direction.LEFT:
			for tree in all_tree :
				tree.set("parameters/conditions/extending_side", true)
			head.position.x -= mov
			body_side.region_rect.size[0] = abs(head.position.x - back.position.x) + 10
			body_side.position.x = (head.position.x + back.position.x)/2
			if turning_right : turning_right = false
			c_polygon.polygon[0].x -= mov
			c_polygon.polygon[3].x -= mov
			move_detector(c_polygon.polygon[0], c_polygon.polygon[3])
			camera.position.x -= mov
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
			objetBouche.position = object_up_pos;
			for tree in all_tree :
				tree.set("parameters/conditions/extending_up", true)
			head.position.y -= mov
			body_up.region_rect.size[1] = abs(head.position.y - back.position.y) + 10 
			if turning_right : 
				body_up.position.x = -1
			else :
				body_up.position.x = 0
			body_up.position.y = (head.position.y + back.position.y)/2
			c_polygon.polygon[2].y -= mov
			c_polygon.polygon[3].y -= mov
			move_detector(c_polygon.polygon[2], c_polygon.polygon[3])
			camera.position.y -= mov
	if length(c_polygon.polygon) >= MAX_EXTENSION or height(c_polygon.polygon) >= MAX_EXTENSION or HaveWallTouched :
		HaveWallTouched = false

		return true
		
	else:
		old_e = e
		return false
			
			
			
			

# shrink the dog in the right direction
func shrinkage() -> int:
	var v: bool = false
	var s: float = math_shrinkage(step*y)
	var mov = EXTENSION_SPEED
	match ed:
		extending_direction.RIGHT:
			head.position.x -= mov
			body_side.region_rect.size[0] = abs(head.position.x - back.position.x) + 10
			body_side.position.x = (head.position.x + back.position.x)/2
			c_polygon.polygon[0].x += mov
			c_polygon.polygon[3].x += mov
			c_polygon.position.x -= mov
			camera.position.x -= mov
			position.x += mov
		extending_direction.LEFT:
			head.position.x += mov
			body_side.region_rect.size[0] = abs(head.position.x - back.position.x) + 10
			body_side.position.x = (head.position.x + back.position.x)/2
			c_polygon.polygon[1].x -= mov
			c_polygon.polygon[2].x -= mov
			c_polygon.position.x += mov
			camera.position.x += mov
			position.x -= mov
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
			head.position.y += mov
			body_up.region_rect.size[1] = abs(head.position.y - back.position.y) + 10 
			body_up.position.y = (head.position.y + back.position.y)/2
			if turning_right : 
				body_up.position.x = -1
			else :
				body_up.position.x = 0
			
			c_polygon.polygon[0].y -= mov
			c_polygon.polygon[1].y -= mov
			c_polygon.position.y += mov
			camera.position.y += mov
			position.y -= mov
			v = true
	old_s = s
	if v and height(c_polygon.polygon) <= height(normal_polygon):
		c_polygon.polygon = normal_polygon
		c_polygon.position = normal_position
		head.position = head_position
		back.position = back_position
		body_side.region_rect = Rect2(0,0,0,32)
		body_up.region_rect = Rect2(0,0,32,0)
		is_extended = false
		max_ex = false
		return -1
	elif !v and length(c_polygon.polygon) <= length(normal_polygon):
		c_polygon.polygon = normal_polygon
		c_polygon.position = normal_position
		head.position = head_position
		back.position = back_position
		body_side.region_rect = Rect2(0,0,0,32)
		body_up.region_rect = Rect2(0,0,32,0)
		is_extended = false
		max_ex = false
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
		if iteminfo == null and humaninfo == null:
			PickUpOrOuaf()
		else :
			all_tree[1].set("parameters/conditions/mouth_open", false)
			all_tree[1].set("parameters/conditions/mouth_closed", true)
			Drop()
			


func frapper(f : float):
	var puissance: float = 1/ (1 + exp((1-3*(timer.wait_time - f))))
	for objet : PhysicsBody2D in zoneFrappe.get_overlapping_bodies() :
		if objet is RigidBody2D :
			var vector : Vector2 = (objet.global_position - PosTete.global_position).normalized()
			objet.apply_central_impulse((vector + Vector2(0.0, -puissance).normalized()).normalized() * puissance * 1000)


func frapperFin():
	frapper(0.0)
	
func length(v_array: PackedVector2Array) -> float:
	return v_array[1].x - v_array[0].x

func height(v_array: PackedVector2Array) -> float:
	return v_array[1].y - v_array[2].y
	
func math_extension(z: float) -> float:
	return MAX_EXTENSION*(1 - exp(-alpha*z))
	
func math_shrinkage(z: float) -> float:
	return exp(beta*z)


func PickUpOrOuaf() :
	var aPickUp : bool = false
	for objet : PhysicsBody2D in zonePickUp.get_overlapping_bodies() :
		if objet.has_method("get_isTakable") :
			print("objet a pickup potentiellement")
			if objet.get_isTakable() :
				objet.PickUp()
				aPickUp = true
				all_tree[1].set("parameters/conditions/mouth_open", true)
				all_tree[1].set("parameters/conditions/mouth_closed", false)
				
				break
	if (!aPickUp):
		for perso : PhysicsBody2D in zoneBarking.get_overlapping_bodies() :
			print(perso)
			if perso.has_method("se_faire_aboyer"):
				perso.se_faire_aboyer()

func itemTaken(infoitem) :
	print("item taken")
	iteminfo = infoitem
	objetBouche.texture = iteminfo.icon

func humanTaken(human) :
	print("human taken")
	humaninfo = human
	objetBouche.texture = icon_pied
	
func Drop() :
	if iteminfo != null :
		var item = objetGenerique.instantiate()
		item.iteminfo = iteminfo
		item.global_position = objetBouche.global_position
		#get_parent().get_child(3).add_child(item)
		objetsnode.add_child(item)
		iteminfo = null
		print("drop")
	if humaninfo != null :
		humaninfo.global_position = global_position + Vector2(0, -27)
		humaninfo.visible = true
		humaninfo = null

	objetBouche.texture = null
		

func rotate_dog():
	# Rotate colliders
	zoneFrappe.scale.x *= -1
	zoneBarking.scale.x *= -1
	zonePickUp.scale.x *= -1
	objetBouche.get_parent().scale.x *= -1
	# Rotate sprite
	head.flip_h = turning_right
	back.flip_h = turning_right
	
	
	
func move_detector(point1,point2):
	var milieu = (to_global(point1) + to_global(point2))/2
	walldetect.global_position = milieu


func _on_wall_detect_body_entered(body):
	if body != self :
		HaveWallTouched=true

