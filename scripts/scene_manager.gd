extends Node2D
class_name SceneManager

func _ready():
	GameManager.scene_manager = self

func reload_scene():
	get_tree().reload_current_scene()
	
func load_scene(scene):
	get_tree().change_scene_to_file(scene)
