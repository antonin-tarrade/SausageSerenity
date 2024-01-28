extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sprite.modulate.a8 = sprite.modulate.a8 - 1
	if sprite.modulate.a8 <= 1:
		queue_free()
