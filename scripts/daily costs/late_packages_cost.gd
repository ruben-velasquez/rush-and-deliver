class_name LatePackagesCost
extends DailyCost

func _init() -> void:
	name = "Late packages"

func calculate_cost() -> int:
	return (RunData.current_week + 1) * RunData.day_late_packages

func should_appear() -> bool:
	return RunData.day_late_packages > 0

func get_name() -> String:
	return "%s (%s)" % [name, RunData.day_late_packages]
