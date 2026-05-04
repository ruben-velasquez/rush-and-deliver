extends Node

var scene_manager: SceneManager
var packages_manager: PackagesManager

var current_day: int = 1
var current_score: int = 0
var current_timer: Timer

var packages: Array[Package]
var currentPackage: int = 0

var player: PlayerController

signal on_timer_end
signal on_score_updated
signal on_swap_package

const GOAL_SCENE = preload("res://scenes/goal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the minimum size for the current window
	get_window().min_size = Vector2i(640, 360)

func AddScore(reward: int):
	current_score = current_score + reward
	on_score_updated.emit()

func next_day():
	current_day += 1
	scene_manager.reload_scene()
