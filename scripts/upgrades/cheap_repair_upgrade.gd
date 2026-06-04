class_name CheapRepairUpgrade
extends Upgrade

func _init() -> void:
	name = "Cheap Repair"
	id = "cheap_repair"
	base_price = 5
	unique = true

func apply_stats():
	RunData.stats.repair_car_cost /= 2

func get_description() -> String:
	return "Reduced price of car maintenance"
