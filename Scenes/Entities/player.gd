extends CharacterBody2D

@onready var hurtbox = $Hurtbox
@onready var attack_particles = $ReflectParticles
@onready var animation_player = $BasicAnimationPlayer
@onready var sprite = $Sprite2D

const MAX_X_VEL : float = 250
const RUN_ACC : float = MAX_X_VEL / 0.3
const IDLE_DEACC : float = MAX_X_VEL / 0.2
const TURN_ACC : float = RUN_ACC + IDLE_DEACC

const AIR_RUN_ACC : float = MAX_X_VEL / 0.6
const AIR_IDLE_DEACC : float = MAX_X_VEL / 2
const AIR_TURN_ACC : float = AIR_RUN_ACC + AIR_IDLE_DEACC

const MAX_Y_VEL : float = 300
const GRAVITY : float = 450
const JUMP_GRAVITY : float = 380

const JUMP_VEL : float = 300

const BUFFER_JUMP_WINDOW : float = 0.1
const COYOTE_JUMP_WINDOW : float = 0.15

const ATTACK_COOLDOWN : float = 0.2

const LAUNCH_VEL : Vector2 = Vector2(360, 400)

const INVINCIBILITY_WINDOW : float = 0.1

var x_input : float = 0
var jump_just_pressed : bool = false
var jump_pressed : bool = false
var action_just_pressed : bool = false

var jumping = false
var coyote_jump_ready = false

var buffer_jump_timer : float = 0
var coyote_jump_timer : float = 0

var attack_cooldown_timer : float = 0

const RUN_SOUND_COOLDOWN = 0.3
var run_sound_timer = 0

var invincibility_timer : float = 0

func _ready():
	GD.player = self

func _physics_process(delta):
	get_inputs()
	calc_physics(delta)
	check_actions()
	move_and_slide()
	update_animations()
	tick_timers(delta)

func get_inputs():
	x_input = Input.get_axis("left", "right")
	jump_just_pressed = Input.is_action_just_pressed("jump")
	jump_pressed = Input.is_action_pressed("jump")
	action_just_pressed = Input.is_action_just_pressed("action")

func calc_physics(delta):
	if x_input != 0 and abs(velocity.x) > MAX_X_VEL / 1.2 and is_on_floor() and run_sound_timer <= 0:
		$RunningSound.pitch_scale = randf_range(0.8, 1.2)
		$RunningSound.play()
		run_sound_timer = RUN_SOUND_COOLDOWN
	
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
	$JumpSound.pitch_scale = randf_range(0.8,1.2)
	$JumpSound.play()
	jumping = true
	coyote_jump_ready = false
	buffer_jump_timer = 0
	coyote_jump_timer = 0

func check_actions():
	if action_just_pressed and attack_cooldown_timer <= 0:
		do_attack()
		attack_cooldown_timer = ATTACK_COOLDOWN

func do_attack():
	var dir = get_local_mouse_position().normalized()
	hurtbox.rotation = Vector2.RIGHT.angle_to(dir)
	$Hurtbox/CollisionPolygon2D/AttackSound.play()
	$AttackAnimationPlayer.play("attack")

func tick_timers(delta):
	coyote_jump_timer -= delta
	buffer_jump_timer -= delta
	attack_cooldown_timer -= delta
	run_sound_timer -= delta
	invincibility_timer -= delta

func update_animations():
	var animation_name
	
	if is_on_floor():
		if abs(velocity.x) > MAX_X_VEL / 1.2:
			animation_name = "GroundFast"
		elif velocity.x == 0:
			animation_name = "GroundIdle"
		else:
			animation_name = "GroundSlow"
	else:
		if velocity.y > 50:
			if abs(velocity.y) > MAX_Y_VEL / 1.2:
				if abs(velocity.x) > MAX_X_VEL / 1.2:
					animation_name = "AirFFallFast"
				elif velocity.x == 0:
					animation_name = "AirFFall"
				else:
					animation_name = "AirFFallSlow"
			else:
				if abs(velocity.x) > MAX_X_VEL / 1.2:
					animation_name = "AirSFallFast"
				elif velocity.x == 0:
					animation_name = "AirSFall"
				else:
					animation_name = "AirSFallSlow"
		elif velocity.y < -50:
			if abs(velocity.y) > MAX_Y_VEL / 1.2:
				if abs(velocity.x) > MAX_X_VEL / 1.2:
					animation_name = "AirFJumpFast"
				elif velocity.x == 0:
					animation_name = "AirFJump"
				else:
					animation_name = "AirFJumpSlow"
			else:
				if abs(velocity.x) > MAX_X_VEL / 1.2:
					animation_name = "AirSJumpFast"
				elif velocity.x == 0:
					animation_name = "AirSJump"
				else:
					animation_name = "AirSJumpSlow"
		else:
			if abs(velocity.x) > MAX_X_VEL / 1.2:
				animation_name = "AirFast"
			elif velocity.x == 0:
				animation_name = "AirIdle"
			else:
				animation_name = "AirSlow"
	
	if animation_player.current_animation != animation_name:
		animation_player.play(animation_name)
	
	if (sprite.scale.x > 0 and velocity.x < 0) or (sprite.scale.x < 0 and velocity.x > 0):
		sprite.scale.x *= -1

func _on_hurtbox_area_entered(area):
	$ReflectParticles/ReflectSound.play()
	GD.scene_manager.player_reflect_trigger()
	var dir = (area.global_position - global_position).normalized()
	attack_particles.position = dir * 21
	attack_particles.rotation = Vector2.RIGHT.angle_to(dir)
	attack_particles.emitting = true
	invincibility_timer = INVINCIBILITY_WINDOW
	if not is_on_floor():
		var launch_dir = Vector2.RIGHT.rotated(hurtbox.rotation) * -1
		#if (velocity.x > 0 and launch_dir.x > 0) or (velocity.x < 0 and launch_dir.x < 0):
			#velocity.x += LAUNCH_VEL.x * launch_dir.x
		#else:
			#velocity.x = launch_dir.x * LAUNCH_VEL.x
		#velocity.y = LAUNCH_VEL.y * launch_dir.y
		velocity = LAUNCH_VEL * launch_dir
		jumping = false

func _on_hitbox_body_entered(body):
	if body.is_in_group("Bullets"):
		body.collision()
	if invincibility_timer <= 0:
		GD.scene_manager.player_death()
