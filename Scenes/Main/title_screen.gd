extends Sprite2D


func _on_play_button_button_down():
	GD.scene_manager.start_game()


func _on_play_button_mouse_entered():
	$HoverSound.play()
