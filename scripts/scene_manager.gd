extends Node2D
class_name SceneManager

const GAME_SCENE: PackedScene = preload("res://scenes/main.tscn")

static var instance: SceneManager

func _ready():
	instance = self

func reload_scene():
	get_tree().reload_current_scene()
	
func load_scene(scene):
	get_tree().change_scene_to_file(scene)

func load_game_scene():
	get_tree().change_scene_to_packed(GAME_SCENE)
