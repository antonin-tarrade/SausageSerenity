extends CharacterBody2D

@export var SPEED = 300.0
@export var EXTENSION_SPEED = 1 # px
@export var SHRINKING_SPEED = 2 # px
@onready var timer : Timer = $Chargement
@onready var zoneFrappe : Area2D = $ZoneDeFrappe
@onready var PosTete : Marker2D = $PositionFrappe
@onready var zoneBarking : Area2D = $Barking
@onready var sprite: Sprite2D = $Sprite2D
@onready var a_tree: AnimationTree = $AnimationTree
@onready var c_shape: CollisionShape2D = $CollisionShape2D
@onready var c_rect: ColorRect = $ColorRect

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turning_left: bool = false
enum extending_direction {LEFT, RIGHT, UP, DOWN}
var ed: int = 0

func _ready():
	a_tree.set("parameters/conditions/idle", is_on_floor() and (velocity.x == 0))
	a_tree.set("parameters/conditions/extending", Input.is_action_pressed("extend"))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_pressed("extend"):
		if ed == 0:
			var horizontal: float = Input.get_axis("ui_left", "ui_right")
			var vertical: float = Input.get_axis("ui_down", "ui_up")
			ed = get_extending_direction(horizontal, vertical)
		else:
			extension(ed)
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
		return 0



# extends the dog in the right direction
func extension(ed: int) -> void:
	match ed:
		extending_direction.RIGHT:
			print("right")
			c_shape.shape.size.x += EXTENSION_SPEED
			c_rect.size.x += EXTENSION_SPEED
		extending_direction.LEFT:
			print("left")
			c_shape.shape.size.x += EXTENSION_SPEED
			c_rect.size.x += EXTENSION_SPEED
			c_shape.position.x -= EXTENSION_SPEED
			c_rect.size.x -= EXTENSION_SPEED


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
