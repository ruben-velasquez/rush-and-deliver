class_name ReinforcedStorageUpgrade
extends Upgrade

func _init() -> void:
	name = "Reinforced Storage"
	base_price = 7
	unique = true

func apply_stats():
	RunData.stats.fragile_packages_health += 1

func get_description() -> String:
	return "+1 Packages durability" 
