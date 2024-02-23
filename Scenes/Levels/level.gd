extends Node

@onready var bullets = $Bullets
@onready var player = $Player
@onready var camera = $Camera2D

func _physics_process(delta):
	var t = create_tween()
	t.tween_property(camera, "position", player.position, 0.2)
