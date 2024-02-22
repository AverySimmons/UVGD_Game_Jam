extends Node2D

@export var min_degree : float = PI/2
@export var max_defree : float = PI/2

@export var shoot_cooldown : float = 1
@export var shoot_timer : float = 1

const MAX_TURN_SPEED : float = PI
const TURN_ACC : float = MAX_TURN_SPEED / 0.2
const TURN_DEACC : float = MAX_TURN_SPEED / 0.1
const TURN_SWITCH_DIR_ACC : float = TURN_ACC + TURN_DEACC

func _physics_process(delta):
	if can_see_player():
		do_rotate(delta)
		check_shoot(delta)
	else:
		apply_friction(delta)

func can_see_player():
	pass

func do_rotate(delta):
	pass

func check_shoot(delta):
	pass

func apply_friction(delta):
	pass
