class_name CapacityUpgrade
extends Upgrade

func _init() -> void:
	name = "Upgrade capacity"
	base_price = 5

func on_purchase():
	RunData.package_capacity += 1

func get_description() -> String:
	var capacity = RunData.package_capacity
	return "%s -> %s" % [capacity, capacity + 1]

func get_price() -> int:
	var capacity = RunData.package_capacity
	return base_price + capacity - 3
