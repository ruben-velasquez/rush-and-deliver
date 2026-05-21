class_name FoodCost
extends DailyCost

func _init() -> void:
	name = "Food"
	amount = 10

func should_appear() -> bool:
	return true

func calculate_cost() -> int:
	return min(amount + (RunData.get_days_passed()-1)*2, 21)
