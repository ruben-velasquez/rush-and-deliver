class_name SpeedUpgrade 
extends Upgrade

func _init() -> void:
	unique = true
	name = "Speed Upgrade"
	base_price = 10
	id = "speed"

func get_description() -> String:
	return "1.2x Speed"

func apply_stats():
	RunData.stats.speed_multiplier *= 1.2
