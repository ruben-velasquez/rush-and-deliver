class_name CapacityUpgrade
extends Upgrade

func _init() -> void:
	name = "Upgrade capacity"
	id = "capacity"
	base_price = 5
	unique = false

func apply_stats():
	RunData.stats.package_capacity += 1

func get_description() -> String:
	var capacity = RunData.stats.package_capacity
	return "%s -> %s" % [capacity, capacity + 1]

func get_price() -> int:
	var capacity = RunData.stats.package_capacity
	return base_price + capacity - 3

func can_appear() -> bool:
	return RunData.stats.package_capacity < 6
