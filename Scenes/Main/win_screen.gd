extends Sprite2D

func _ready():
	$TimeLabel.text = "Time Spent: " + str(round(GD.scene_manager.speedrun_time * 1000) / 1000)
	$DeathLabel.text = "Deaths: " + str(GD.scene_manager.deaths)

func _on_play_button_button_down():
	GD.scene_manager.start_game()


func _on_play_button_mouse_entered():
	$HoverSound.play()
