extends Node

@onready var particles = $Particles
@onready var bullets = $Bullets
@onready var player = $Player
@onready var camera = $Camera2D

func _physics_process(delta):
	var t = create_tween()
	t.tween_property(camera, "position", player.position + Vector2(player.velocity.x /4, player.velocity.y/10), 0.2)
