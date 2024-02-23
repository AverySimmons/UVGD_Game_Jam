extends CharacterBody2D

var direction : Vector2 = Vector2.RIGHT
var speed : float = 150

var currently_overlapping = false

func _physics_process(delta):
	velocity = speed * direction
	var col_data = move_and_collide(velocity * delta)
	if col_data:
		if col_data.get_collider().is_in_group("bullets"):
			col_data.get_collider().collision()
		collision()
	
	if $Reflection.get_overlapping_areas():
		if not currently_overlapping:
			direction = Vector2.RIGHT.rotated(GD.player.hurtbox.rotation)
			currently_overlapping = true
	else:
		currently_overlapping = false

func collision():
	queue_free()
