class_name DebtCost
extends DailyCost

class DebtInfo:
	var payments: int
	var amount: int
	var total_amount: int
	var deadline: Dictionary[String, int]
	var appear_week: int

var debt_name = "Debt"
var debt_id = "debt"
var debt_info: DebtInfo

func _init() -> void:
	name = debt_name
	tooltip = true
	
	if !RunData.cost_states.has(debt_id):
		if debt_info:
			RunData.cost_states[debt_id] = debt_info
		else:
			RunData.cost_states[debt_id] = _default_debt_info()
	
	debt_info = RunData.cost_states[debt_id]
	
	if _calculate_absolute_day(RunData.current_day, RunData.current_week) >= _calculate_absolute_day(debt_info.deadline.day, debt_info.deadline.week):
		optional = false
	else:
		optional = true

func should_appear() -> bool:
	var data = RunData.cost_states[debt_id] as DebtInfo
	
	return RunData.current_week == data.appear_week and data.amount > 0

func calculate_cost() -> int:
	var data = RunData.cost_states[debt_id] as DebtInfo

	if !optional:
		return data.amount

	return ceil(float(data.total_amount) / data.payments)

func on_pay():
	var data = RunData.cost_states[debt_id] as DebtInfo

	data.amount = max(
		0,
		data.amount - calculate_cost()
	)

func get_description() -> String:
	var data = RunData.cost_states[debt_id] as DebtInfo
	
	return "Remaining: $%s\nInstallment: $%s\nDeadline: Week %s, Day %s" % [
		data.amount,
		calculate_cost(),
		data.deadline.week,
		data.deadline.day
	]

func _calculate_absolute_day(day: int, week: int) -> int:
	return day + (max(0, week-1) * 5)

func _default_debt_info() -> DebtInfo:
	var info: DebtInfo = DebtInfo.new()
	
	info.total_amount = 50
	info.amount = info.total_amount
	info.payments = 5
	info.appear_week = 3
	
	info.deadline = {
		"day": 5,
		"week": 3
	} 
	
	return info
