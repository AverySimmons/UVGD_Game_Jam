extends Node

var cur_level : Node

func _ready():
	GD.scene_manager = self
	cur_level = $TestLevel

func player_death():
	print("!")
