extends Node

@onready var level_transition = $LevelTransition

@onready var levels = [
	preload("res://Scenes/Levels/level0.tscn"),
]

@onready var win_screen_scene = preload("res://Scenes/Main/win_screen.tscn")
@onready var death_particle_scene = preload("res://Scenes/Helper/death_particles.tscn")

@onready var cur_level : Node = $TitleScreen

var level_num = 0

var deaths = 0
var speedrun_time = 0

var music_ind = randi_range(0,2)
var looping = false

func _ready():
	GD.scene_manager = self
	await level_transition.levelStart(cur_level.get_node("PlayButton").global_position + Vector2(114,40))
	$TitleScreenMusic.play()

func _physics_process(delta):
	speedrun_time += delta

func start_game():
	$TitleScreenMusic.stop()
	$UISelectSound.play()
	var pos = cur_level.get_node("PlayButton").global_position + Vector2(114,40)
	await level_transition.levelEnd(pos)
	remove_child(cur_level)
	deaths = 0
	speedrun_time = 0
	if not looping:
		$MusicRotation.get_children()[music_ind].play()
	await load_level()

func player_death():
	$DeathSound.play()
	deaths += 1
	cur_level.player.visible = false
	var new_death_particle = death_particle_scene.instantiate()
	new_death_particle.global_position = cur_level.player.global_position
	cur_level.particles.add_child(new_death_particle)
	await remove_level()
	await load_level()

func next_level():
	$NextLevelSound.play()
	await remove_level()
	level_num += 1
	if level_num == len(levels):
		looping = true
		var win_screen = win_screen_scene.instantiate()
		cur_level = win_screen
		add_child(win_screen)
		level_num = 0
		await level_transition.levelStart(cur_level.get_node("PlayButton").global_position + Vector2(114,40))
	else:
		await load_level()

func remove_level():
	level_transition.global_position = cur_level.camera.global_position
	await level_transition.levelEnd(cur_level.player.global_position)
	remove_child(cur_level)

func load_level():
	var new_level = levels[level_num].instantiate()
	cur_level = new_level
	add_child(new_level)
	level_transition.global_position = cur_level.camera.global_position
	await level_transition.levelStart(cur_level.player.global_position)

func player_reflect_trigger():
	var t = get_tree().create_timer(0.1)
	get_tree().paused = true
	await t.timeout
	get_tree().paused = false


func _on_song_finished():
	music_ind = (music_ind + 1) % 3
	$MusicRotation.get_children()[music_ind].play()
