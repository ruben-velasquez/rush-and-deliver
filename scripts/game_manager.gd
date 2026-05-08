extends Node

var scene_manager: SceneManager
var packages_manager: PackagesManager
var ui_manager: UIManager

var current_day: int = 1
var current_score: int = 0
var current_timer: Timer

class DailyCost:
	var name: String
	var amount: int

var daily_costs: Array[DailyCost] = [
	(func () -> DailyCost:
	var _a = DailyCost.new()
	_a.name = "Food"
	_a.amount = 15
	return _a
	).call()
]

var player: PlayerController

signal on_timer_end
signal on_score_updated

const GOAL_SCENE = preload("res://scenes/goal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the minimum size for the current window
	on_timer_end.connect(end_day)
	get_window().min_size = Vector2i(640, 360)

func add_score(reward: int):
	current_score = current_score + reward
	on_score_updated.emit()

func end_day():
	current_day += 1
	
	for fee in daily_costs:
		add_score(-fee.amount)
	
	if current_score < 0:
		current_day = 1
		current_score = 0
		ui_manager.show_game_over_screen()
	else:
		ui_manager.show_end_day_popup()

func next_day():
	scene_manager.reload_scene()

func reset():
	current_day = 1
	current_score = 0
	scene_manager.reload_scene()
