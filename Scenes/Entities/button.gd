extends StaticBody2D

@export var on = false

@onready var animation_player = $AnimationPlayer

const CANT_HIT_WINDOW = 0.1

var cant_hit_timer = 0

func _ready():
	if on:
		animation_player.play("On")

func _physics_process(delta):
	cant_hit_timer -= delta

func _on_area_2d_area_entered(_area):
	if cant_hit_timer <= 0:
		$TriggerSound.play()
		on = not on
		if on:
			animation_player.play("On")
		else:
			animation_player.play("Off")
		cant_hit_timer = CANT_HIT_WINDOW
