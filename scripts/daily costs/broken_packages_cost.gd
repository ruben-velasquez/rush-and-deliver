class_name BrokenPackagesCost
extends DailyCost

func _init() -> void:
	name = "Broken packages"
	amount = 2

func calculate_cost() -> int:
	return amount * RunData.day_broken_packages * min(RunData.current_day, 5) 

func should_appear() -> bool:
	return RunData.day_broken_packages > 0

func get_name() -> String:
	return "%s (%s)" % [name, RunData.day_broken_packages]
