class_name Package
extends Object

enum PackageProperty { NORMAL, HEAVY, FRAGILE, URGENT }

var goal: Area2D
var property: PackageProperty = PackageProperty.NORMAL
var reward: int = 1
var done: bool = false
var failed: bool = false
var data = []

var fragile_health: int = 0
var weight_multiplier: float = 1.0
var urgent_time_left: float = 0.0
var urgent_bonus: bool = true

func setup():
	match property:
		PackageProperty.URGENT:
			urgent_time_left = RunData.stats.urgent_packages_time

		PackageProperty.FRAGILE:
			fragile_health = RunData.stats.fragile_packages_health

		PackageProperty.HEAVY:
			weight_multiplier = RunData.stats.heavy_packages_speed_mult
