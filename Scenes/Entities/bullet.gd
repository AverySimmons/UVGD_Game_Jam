extends CharacterBody2D

var direction : Vector2 = Vector2.RIGHT
var speed : float = 200

func _physics_process(delta):
	velocity = speed * direction * delta
	move_and_slide()
