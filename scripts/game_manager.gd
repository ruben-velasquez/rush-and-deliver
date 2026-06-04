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
	func(): return DebtCost.new(),
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
	calculate_costs()
	
	SceneManager.instance.load_payment_scene()

func pay_costs():
	for fee in current_costs:
		if !fee.active: continue
		fee.on_pay()
		give_money(-fee.calculate_cost())

func start_day():
	if(RunData.current_day >= 5):
		RunData.current_day = 1
		RunData.current_week += 1
	else:
		RunData.current_day += 1
	
	RunData.day_broken_packages = 0
	RunData.day_late_packages = 0
	SceneManager.instance.load_game_scene()
	on_day_start.emit()

func reset():
	RunData.stats = RunStats.new()
	RunData.run_state = RunData.RunState.GAME
	RunData.current_day = 1
	RunData.current_week = 1
	RunData.money = 0
	
	RunData.day_broken_packages = 0
	RunData.day_late_packages = 0
	
	RunData.cost_states.clear()
	
	RunData.player_health = RunData.stats.max_player_health
	UpgradesManager.current_upgrades.clear()

func player_died():
	reset()
	ui_manager.show_game_over_screen()

func calculate_costs():
	current_costs.clear()
	
	for fee in daily_costs:
		var _cost = fee.call() as DailyCost
		
		if _cost.should_appear():
			current_costs.append(_cost)
		elif _cost.can_appear() and randi_range(0,1) == 1:
			current_costs.append(_cost)

func get_estimated_costs() -> int:
	var total = 0
	for fee in daily_costs:
		var _cost = fee.call() as DailyCost
		
		if _cost.should_appear() and !_cost.optional:
			total += _cost.calculate_cost()
	return total
