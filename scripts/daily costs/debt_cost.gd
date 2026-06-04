class_name DebtCost
extends DailyCost

class DebtInfo:
	var payments: int
	var amount: int
	var total_amount: int
	var deadline: Dictionary[String, int]

func _init() -> void:
	name = "Debt"
	tooltip = true
	var info: DebtInfo
	
	if !RunData.cost_states.has("debt"):
		info = DebtInfo.new()
		info.total_amount = 50
		info.amount = info.total_amount
		info.payments = 5
		info.deadline = {
			"day": 5,
			"week": 3
		}
		
		RunData.cost_states["debt"] = info
	else:
		info = RunData.cost_states["debt"]
	
	
	if _calculate_absolute_day(RunData.current_day, RunData.current_week) >= _calculate_absolute_day(info.deadline.day, info.deadline.week):
		optional = false
	else:
		optional = true

func should_appear() -> bool:
	var data = RunData.cost_states["debt"] as DebtInfo
	
	return RunData.current_week == 3 and data.amount > 0

func calculate_cost() -> int:
	var data = RunData.cost_states["debt"] as DebtInfo

	if !optional:
		return data.amount

	return ceil(float(data.total_amount) / data.payments)

func on_pay():
	var data = RunData.cost_states["debt"] as DebtInfo

	data.amount = max(
		0,
		data.amount - calculate_cost()
	)

func get_description() -> String:
	var data = RunData.cost_states["debt"] as DebtInfo
	
	return "Remaining: $%s\nInstallment: $%s\nDeadline: Week %s, Day %s" % [
		data.amount,
		calculate_cost(),
		data.deadline.week,
		data.deadline.day
	]

func _calculate_absolute_day(day: int, week: int) -> int:
	return day + (max(0, week-1) * 5)
