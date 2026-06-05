class_name FuelCost
extends DailyCost

func _init() -> void:
	name = "Fuel"
	amount = 5

func should_appear() -> bool:
	return RunData.current_day == 3
