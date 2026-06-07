class_name LoanUpgrade
extends Upgrade

func _init() -> void:
	name = "Loan Upgrade"
	id = "loan"
	base_price = 2
	is_special = true

func on_purchase():
	GameManager.give_money(40)
	
	var debt_info = DebtCost.DebtInfo.new()
	
	debt_info.total_amount = 60
	debt_info.amount = debt_info.total_amount
	debt_info.payments = 5
	debt_info.appear_week = RunData.current_week
	
	debt_info.deadline.day = RunData.current_day
	debt_info.deadline.week = RunData.current_week + 1
	
	RunData.run_costs.append(func(): return DebtCost.new("Loan Debt", "loan_debt_upg", debt_info))

func get_description() -> String:
	return "Receive $40 immediately.\nRepay $60 in 5 days."

func can_appear() -> bool:
	return RunData.current_week < 4
