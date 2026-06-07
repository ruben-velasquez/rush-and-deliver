class_name HeavyHaulerUpgrade
extends Upgrade

func _init() -> void:
	name = "Heavy Hauler"
	id = "heavy_hauler"
	base_price = 6

func apply_stats():
	RunData.stats.heavy_packages_speed_mult = 1

func get_description() -> String:
	return "Removes heavy packages effect"
