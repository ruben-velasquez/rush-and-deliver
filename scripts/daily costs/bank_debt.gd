class_name BankDebtCost
extends DebtCost

func _init() -> void:
	debt_id = "bank_cost"
	debt_name = "Bank Debt"
	debt_info = DebtInfo.new()
	
	debt_info.total_amount = 70
	debt_info.amount = 70
	debt_info.payments = 5
	debt_info.appear_week = 4
	debt_info.deadline.week = 4
	debt_info.deadline.day = 5
	
	super()
