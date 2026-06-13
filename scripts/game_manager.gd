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
	func(): return BankDebtCost.new(),
	func(): return FuelCost.new(),
	func(): return MedicineCost.new(),
	func(): return RentCost.new(),
	func(): return InternetBillCost.new(),
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
	calculate_costs()
	on_day_end.emit()
	
	SceneManager.instance.load_payment_scene()

func pay_costs():
	for fee in current_costs:
		if !fee.active: 
			fee.on_skip()
			continue
		fee.on_pay()
		give_money(-fee.calculate_cost())

# Called when we start a new game
func start_run():
	reset()
	
	for event in RunData.run_events:
		if event.introEvent and !event.triggered:
			SceneManager.instance.load_event_scene(event)
			return
	
	start_day()

# Trigger a new day in the game
func start_day():
	RunData.runStarted = true
	
	if(RunData.current_day >= 5):
		RunData.current_day = 1
		RunData.current_week += 1
	else:
		RunData.current_day += 1
	
	RunData.day_summary.append(RunData.SummaryEntry.new())
	RunData.day_summary[0].title = "Packages Reward"
	RunData.day_summary[0].money_movement = 0
	
	RunData.day_broken_packages = 0
	RunData.day_late_packages = 0
	SceneManager.instance.load_game_scene()
	on_day_start.emit()

func reset():
	RunData.stats = RunStats.new()
	RunData.run_state = RunData.RunState.GAME
	RunData.current_day = 0
	RunData.current_week = 1
	RunData.money = 0
	
	RunData.day_broken_packages = 0
	RunData.day_late_packages = 0
	RunData.runStarted = false
	
	RunData.cost_states.clear()
	RunData.run_costs.clear()
	RunData.day_summary.clear()
	
	RunData.run_events = RunData.default_run_events()
	
	RunData.player_health = RunData.stats.max_player_health
	UpgradesManager.current_upgrades.clear()

func player_died():
	reset()
	ui_manager.show_game_over_screen()

func calculate_costs():
	current_costs.clear()
	
	for fee in get_costs_pool():
		var _cost = fee.call() as DailyCost
		
		if _cost.should_appear():
			current_costs.append(_cost)
		elif _cost.can_appear() and randi_range(0,1) == 1:
			current_costs.append(_cost)

func get_estimated_costs() -> int:
	var total = 0
	for fee in get_costs_pool():
		var _cost = fee.call() as DailyCost
		
		if _cost.should_appear() and !_cost.optional:
			total += _cost.calculate_cost()
	return total

func get_costs_pool() -> Array[Callable]:
	return daily_costs + RunData.run_costs
