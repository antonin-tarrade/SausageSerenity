extends CharacterBody2D

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
@onready var sprite: Sprite2D = $Sprite2D
@onready var a_tree: AnimationTree = $AnimationTree
@onready var c_polygon: CollisionPolygon2D = $CollisionPolygon2D
# 0 bottom-left
# 1 bottom-right
# 2 top-right
# 3 top-left
@onready var normal_polygon: PackedVector2Array = c_polygon.polygon
@onready var normal_position: Vector2 = c_polygon.position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turning_left: bool = false
var extended: bool = false
var max_ex: bool = false
enum extending_direction {LEFT, RIGHT, UP, DOWN}
var ed: int = -1
var old_e: float = 0.0
var x: int = 0
var old_s: float = 0.0
var y: int = 0

func _ready():
	a_tree.set("parameters/conditions/idle", is_on_floor() and (velocity.x == 0))
	a_tree.set("parameters/conditions/extending", Input.is_action_pressed("extend"))

func _physics_process(delta):
	
	# Add the gravity.
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
			turning_left = (direction < 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	sprite.flip_h = turning_left
	
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
	var e: float = math_extension(step*x)
	var mov = e - old_e
	match ed:
		extending_direction.RIGHT:
			c_polygon.polygon[1].x += mov
			c_polygon.polygon[2].x += mov
			camera.position.x += mov
		extending_direction.LEFT:
			c_polygon.polygon[0].x -= mov
			c_polygon.polygon[3].x -= mov
			camera.position.x -= mov
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
			c_polygon.polygon[2].y -= mov
			c_polygon.polygon[3].y -= mov
			camera.position.y -= mov
	if length(c_polygon.polygon) >= MAX_EXTENSION or height(c_polygon.polygon) >= MAX_EXTENSION:
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
			c_polygon.polygon[0].x += mov
			c_polygon.polygon[3].x += mov
			c_polygon.position.x -= mov
			camera.position.x -= mov
			position.x += mov
		extending_direction.LEFT:
			c_polygon.polygon[1].x -= mov
			c_polygon.polygon[2].x -= mov
			c_polygon.position.x += mov
			camera.position.x += mov
			position.x -= mov
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
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
		max_ex = false
		return -1
	elif !v and length(c_polygon.polygon) <= length(normal_polygon):
		c_polygon.polygon = normal_polygon
		c_polygon.position = normal_position
		max_ex = false
		return -1
	else:
		return ed

func _input(event):
	if event.is_action_pressed("charger"):
		timer.start()
	elif event.is_action_pressed("bark"):
		for bodies : PhysicsBody2D in zoneBarking.get_overlapping_bodies():
			if bodies is RigidBody2D :
				print("wesh")
				bodies.apply_central_impulse(Vector2(3.0, -30.0)*40)


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
