class_name MaintenaceCost
extends DailyCost

func _init() -> void:
	name = "Car maintenace"
	amount = 10
	optional = true

func should_appear() -> bool:
	return RunData.player_health < RunData.stats.max_player_health/2.

func on_pay():
	RunData.player_health = RunData.stats.max_player_health
