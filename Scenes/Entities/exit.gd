extends Area2D

func _on_body_entered(body):
	GD.scene_manager.next_level()
