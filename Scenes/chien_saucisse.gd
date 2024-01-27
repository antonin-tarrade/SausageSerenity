extends CharacterBody2D

@export var SPEED = 300.0
@export var EXTENSION_SPEED = 4 # px
@export var SHRINKING_SPEED = 12 # px
@export var timer : Timer 
@onready var sprite: Sprite2D = $Sprite2D
@onready var a_tree: AnimationTree = $AnimationTree
@onready var c_shape: CollisionShape2D = $CollisionShape2D

const normal_size: Vector2 = Vector2(32, 24)
const normal_position: Vector2 = Vector2(0, -8)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turning_left: bool = false
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
		
	elif Input.is_action_just_released("charger") and not timer.is_stopped():
		var f : float = timer.time_left	
		timer.stop()
		frapper(f)

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
		
		
func frapper(f : float):
	print(timer.wait_time - f)
	
	
func frapperFin():
	print(5.0)
