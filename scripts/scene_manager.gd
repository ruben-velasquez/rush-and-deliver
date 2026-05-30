extends Node2D
class_name SceneManager

const MAIN_MENU_SCENE: PackedScene = preload("res://scenes/main_menu.tscn")
const GAME_SCENE: PackedScene = preload("res://scenes/main.tscn")
const PAYMENT_SCENE: PackedScene = preload("res://scenes/payment_menu.tscn")
const SHOP_SCENE: PackedScene = preload("res://scenes/upgrade_menu.tscn")

static var instance: SceneManager

func _ready():
	instance = self

func reload_scene():
	get_tree().reload_current_scene()
	
func load_scene(scene):
	get_tree().change_scene_to_file(scene)

func load_game_scene():
	RunData.run_state = RunData.RunState.GAME
	get_tree().change_scene_to_packed(GAME_SCENE)

func load_payment_scene():
	RunData.run_state = RunData.RunState.PAYMENT
	get_tree().change_scene_to_packed(PAYMENT_SCENE)

func load_main_menu_scene():
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)

func resume_game():
	if RunData.run_state == RunData.RunState.PAYMENT:
		load_payment_scene()
	elif RunData.run_state == RunData.RunState.GAME:
		load_game_scene()
	elif RunData.run_state == RunData.RunState.SHOP:
		load_shop_scene()

func load_shop_scene():
	RunData.run_state = RunData.RunState.SHOP
	get_tree().change_scene_to_packed(SHOP_SCENE)
