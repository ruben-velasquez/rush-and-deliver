extends Node

enum RunState {
	EVENT,
	PAYMENT,
	SHOP,
	GAME
}

class SummaryEntry:
	var title: String
	var money_movement: int
	var appear_bottom: bool = false

var run_events: Array[RunEvent] = default_run_events()

var day_summary: Array[SummaryEntry] = []

var run_state: RunState = RunState.GAME

var run_costs: Array[Callable] = []

var runStarted: bool = false

var money := 0
var current_week := 1
var current_day := 0

var day_late_packages := 0
var day_broken_packages := 0

var player_health := 5

var stats: RunStats = RunStats.new()

var cost_states: Dictionary[String, Variant] = {}

func get_days_passed() -> int: return current_day + (current_week-1)*5

func default_run_events() -> Array[RunEvent]: return [
	ContractEvent.new()
]
