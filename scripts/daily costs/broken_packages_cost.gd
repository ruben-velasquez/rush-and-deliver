class_name BrokenPackagesCost
extends DailyCost

func _init() -> void:
	name = "Broken packages"

func calculate_cost() -> int:
	return (RunData.current_week + 1) * RunData.day_broken_packages 

func should_appear() -> bool:
	return RunData.day_broken_packages > 0

func get_name() -> String:
	return "%s (%s)" % [name, RunData.day_broken_packages]
