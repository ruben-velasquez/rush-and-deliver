class_name FoodCost
extends DailyCost

func _init() -> void:
	name = "Food"

func should_appear() -> bool:
	return true

func calculate_cost() -> int:
	if RunData.current_week == 1:
		return 12
	elif RunData.current_week == 2:
		return 15
	elif RunData.current_week == 3:
		return 18
	else:
		return 22
