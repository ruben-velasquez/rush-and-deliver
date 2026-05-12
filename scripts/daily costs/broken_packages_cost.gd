class_name BrokenPackagesCost
extends DailyCost

func _init() -> void:
	name = "Broken packages"
	amount = 2

func calculate_cost() -> int:
	return amount * RunData.day_broken_packages

func should_appear() -> bool:
	return RunData.day_broken_packages > 0
