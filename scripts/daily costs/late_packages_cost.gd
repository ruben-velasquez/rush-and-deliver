class_name LatePackagesCost
extends DailyCost

func _init() -> void:
	name = "Late packages"
	amount = 2

func calculate_cost() -> int:
	return amount * RunData.day_late_packages

func should_appear() -> bool:
	return RunData.day_late_packages > 0
