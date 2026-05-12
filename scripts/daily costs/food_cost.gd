class_name FoodCost
extends DailyCost

func _init() -> void:
	name = "Food"
	amount = 15

func should_appear() -> bool:
	return true
