extends Node

var packages_manager: PackagesManager
var ui_manager: UIManager

var current_timer: Timer

var current_costs: Array[DailyCost]

var daily_costs: Array[Callable] = [
	func(): return FoodCost.new(),
	func(): return MaintenaceCost.new(),
	func(): return BrokenPackagesCost.new(),
	func(): return LatePackagesCost.new(),
]

var player: PlayerController

signal on_timer_end
signal on_money_updated

signal on_day_end
signal on_day_start 

const GOAL_SCENE = preload("res://scenes/goal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the minimum size for the current window
	on_timer_end.connect(end_day)
	get_window().min_size = Vector2i(640, 360)

func give_money(reward: int):
	RunData.money = RunData.money + reward
	on_money_updated.emit()

func end_day():
	on_day_end.emit()
	RunData.current_day += 1
	calculate_costs()
	
	for fee in current_costs:
		give_money(-fee.amount)
	
	if RunData.money < 0:
		ui_manager.show_game_over_screen()
		RunData.current_day = 1
		RunData.money = 0
	else:
		ui_manager.show_end_day_popup()

func start_day():
	RunData.day_broken_packages = 0
	RunData.day_late_packages = 0
	SceneManager.instance.load_game_scene()
	on_day_start.emit()

func reset():
	RunData.current_day = 1
	RunData.money = 0
	UpgradesManager.current_upgrades.clear()

func calculate_costs():
	current_costs.clear()
	
	for fee in daily_costs:
		var _cost = fee.call() as DailyCost
		
		if _cost.should_appear():
			current_costs.append(_cost)
		elif _cost.can_appear() and randi_range(0,1) == 1:
			current_costs.append(_cost)
