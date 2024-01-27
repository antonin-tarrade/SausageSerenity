extends CharacterBody2D

@export var SPEED = 300.0
@export var EXTENSION_SPEED = 4 # px
@export var SHRINKING_SPEED = 12 # px
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

@onready var c_shape: CollisionShape2D = $CollisionShape2D

@onready var normal_size: Vector2 = c_shape.shape.size
@onready var normal_position: Vector2 = c_shape.position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turning_right: bool = true
var extended: bool = false
enum extending_direction {LEFT, RIGHT, UP, DOWN}
var ed: int = -1


func _ready():
	body_side.region_rect = Rect2(0,0,0,32)
	body_side.region_rect = Rect2(0,0,32,0)

func _physics_process(delta):
	
	for tree in all_tree : 
		tree.set("parameters/conditions/idle", is_on_floor() and (velocity.x == 0) and !Input.is_action_pressed("extend"))
		tree.set("parameters/conditions/is_moving", velocity.x != 0)
	
	if not is_on_floor() and ed == -1:
		velocity.y += gravity * delta
		print("gravite")
		
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
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			turning_right = (direction > 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	head.flip_h = turning_right
	back.flip_h = turning_right
	
	
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
			extend_animation_side()
			if !turning_right : turning_right = true
			c_shape.shape.size.x += EXTENSION_SPEED
			c_shape.position.x += EXTENSION_SPEED / 2
		extending_direction.LEFT:
			extend_animation_side()
			if turning_right : turning_right = false
			c_shape.shape.size.x += EXTENSION_SPEED
			c_shape.position.x -= EXTENSION_SPEED / 2
		extending_direction.DOWN:
			print("not yet implemented")
		extending_direction.UP:
			extend_animation_up()
			c_shape.position.y -= EXTENSION_SPEED / 2
			c_shape.shape.size.y += EXTENSION_SPEED
			
			
			
			
func extend_animation_side():
	for tree in all_tree :
		tree.set("parameters/conditions/extending_side", true)
			
			
			
func extend_animation_up():
	for tree in all_tree :
		tree.set("parameters/conditions/extending_up", true)
	
			
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
