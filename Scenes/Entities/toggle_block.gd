extends StaticBody2D

@export var switches : Array[Node] = []
@export var on = false
@export var inversed = false

@onready var animation_player = $AnimationPlayer

func _ready():
	if on:
		animation_player.play("On")

func _physics_process(delta):
	var switch_on = true
	for switch in switches:
		if switch.on == inversed:
			switch_on = false
			break
	
	if switch_on and not on:
		animation_player.play("On")
		on = true
	elif not switch_on and on:
		animation_player.play("Off")
		on = false
