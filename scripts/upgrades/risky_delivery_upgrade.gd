class_name RiskyDeliveryUpgrade
extends Upgrade

func _init() -> void:
	name = "Risky delivery"
	id = "risky_delivery"
	base_price = 10
	unique = true

func get_description() -> String:
	return "1.25x Fragile Reward\n-1 Fragile durability"

func apply_stats():
	RunData.stats.fragile_packages_health -= 1
	RunData.stats.fragile_reward_mult *= 1.25
