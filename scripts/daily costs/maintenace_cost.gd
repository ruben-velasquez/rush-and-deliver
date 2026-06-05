class_name MaintenaceCost
extends DailyCost

func _init() -> void:
	name = "Car maintenace"
	optional = true
	tooltip = true

func calculate_cost() -> int:
	return RunData.stats.repair_car_cost

func should_appear() -> bool:
	return RunData.player_health < RunData.stats.max_player_health/2.

func on_pay():
	RunData.player_health = RunData.stats.max_player_health

func get_description() -> String:
	return "Get your car fixed to avoid accidents"
