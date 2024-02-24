extends StaticBody2D

@export var on = false

@onready var animation_player = $AnimationPlayer

func _ready():
	if on:
		animation_player.play("On")

func _on_area_2d_area_entered(_area):
	$TriggerSound.play()
	on = not on
	if on:
		animation_player.play("On")
	else:
		animation_player.play("Off")
