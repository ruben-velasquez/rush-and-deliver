class_name RushDeliveryLicenseUpgrade
extends Upgrade

func _init() -> void:
	name = "Rush Delivery License"
	base_price = 15
	unique = true

func get_description() -> String:
	return "+10seg Urgent time bonus"

func apply_stats():
	RunData.stats.urgent_packages_time += 10
