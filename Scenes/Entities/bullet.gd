extends CharacterBody2D

@onready var particle_scene = preload("res://Scenes/Helper/bullet_explosion.tscn")
@onready var no_sound_particle_scene = preload("res://Scenes/Helper/no_sound_bullet_explosion.tscn")

var direction : Vector2 = Vector2.RIGHT
var speed : float = 150

var currently_overlapping = false

func _physics_process(delta):
	velocity = speed * direction
	var col_data = move_and_collide(velocity * delta)
	if col_data:
		if col_data.get_collider().is_in_group("bullets"):
			col_data.get_collider().collision()
		var new_particle = particle_scene.instantiate()
		new_particle.global_position = global_position
		GD.scene_manager.cur_level.particles.add_child(new_particle)
		collision()
	
	if $Reflection.get_overlapping_areas():
		if not currently_overlapping:
			var new_particle = no_sound_particle_scene.instantiate()
			new_particle.global_position = global_position
			GD.scene_manager.cur_level.particles.add_child(new_particle)
			direction = Vector2.RIGHT.rotated(GD.player.hurtbox.rotation)
			speed *= 2
			currently_overlapping = true
	else:
		currently_overlapping = false

func collision():
	await get_tree().physics_frame
	queue_free()
