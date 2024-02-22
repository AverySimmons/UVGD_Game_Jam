extends CharacterBody2D

const MAX_X_VEL : float = 300
const RUN_ACC : float = MAX_X_VEL / 0.2
const IDLE_DEACC : float = MAX_X_VEL / 0.15
const TURN_ACC : float = RUN_ACC + IDLE_DEACC

const AIR_RUN_ACC : float = MAX_X_VEL / 0.3
const AIR_IDLE_DEACC : float = MAX_X_VEL / 0.22
const AIR_TURN_ACC : float = AIR_RUN_ACC + AIR_IDLE_DEACC

const MAX_Y_VEL : float = 500
const GRAVITY : float = 500
const JUMP_GRAVITY : float = 400

const JUMP_VEL : float = 300

const BUFFER_JUMP_WINDOW : float = 0.1
const COYOTE_JUMP_WINDOW : float = 0.15

var x_input : float = 0
var jump_just_pressed : bool = false
var jump_pressed : bool = false
var action_just_pressed : bool = false

var jumping = false
var coyote_jump_ready = false

var buffer_jump_timer : float = 0
var coyote_jump_timer : float = 0

func _physics_process(delta):
	get_inputs()
	calc_physics(delta)
	tick_timers(delta)
	move_and_slide()

func get_inputs():
	x_input = Input.get_axis("left", "right")
	jump_just_pressed = Input.is_action_just_pressed("jump")
	jump_pressed = Input.is_action_pressed("jump")
	action_just_pressed = Input.is_action_just_pressed("action")

func calc_physics(delta):
	if x_input == 0:
		velocity.x = move_toward(velocity.x, 0, (IDLE_DEACC if is_on_floor() else AIR_IDLE_DEACC) * delta)
	elif check_turning():
		velocity.x = move_toward(velocity.x, MAX_X_VEL * x_input, (TURN_ACC if is_on_floor() else AIR_TURN_ACC) * delta)
	elif abs(velocity.x) <= MAX_X_VEL:
		velocity.x = move_toward(velocity.x, MAX_X_VEL * x_input, (RUN_ACC if is_on_floor() else AIR_RUN_ACC) * delta)
	
	if jumping: 
		if velocity.y >= 0:
			jumping = false
		elif not jump_pressed:
			velocity.y *= 0.6
			jumping = false
	
	velocity.y = move_toward(velocity.y, MAX_Y_VEL, (JUMP_GRAVITY if jumping else GRAVITY) * delta)
	
	if not is_on_floor() and coyote_jump_ready:
		coyote_jump_timer = COYOTE_JUMP_WINDOW
		coyote_jump_ready = false
	elif is_on_floor():
		coyote_jump_ready = true
	
	if is_on_floor() and buffer_jump_timer > 0:
		do_jump()
	elif jump_just_pressed:
		if is_on_floor() or coyote_jump_timer > 0:
			do_jump()
		else:
			buffer_jump_timer = BUFFER_JUMP_WINDOW

func check_turning():
	return (velocity.x > 0 and x_input < 0) or (velocity.x < 0 and x_input > 0)

func do_jump():
	velocity.y -= JUMP_VEL
	jumping = true
	coyote_jump_ready = false
	buffer_jump_timer = 0
	coyote_jump_timer = 0

func tick_timers(delta):
	coyote_jump_timer -= delta
	buffer_jump_timer -= delta
