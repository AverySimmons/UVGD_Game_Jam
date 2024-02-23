extends Node2D

@export var shoot_cooldown : float = 1
@export var shoot_timer : float = 1

@export var bullet_vel : float = 150

@onready var bullet_scene = preload("res://Scenes/Entities/bullet.tscn")

@onready var bullet_spawn_point = $BulletSpawnPoint.global_position
@onready var shoot_direction = (bullet_spawn_point - global_position).normalized()

func _physics_process(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_cooldown

func shoot():
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = bullet_spawn_point
	new_bullet.direction = shoot_direction
	new_bullet.speed = bullet_vel
	GD.scene_manager.cur_level.bullets.add_child(new_bullet)
	$AnimationPlayer.play("Shoot")
