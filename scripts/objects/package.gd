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
			urgent_time_left = 10

		PackageProperty.FRAGILE:
			fragile_health = 4

		PackageProperty.HEAVY:
			weight_multiplier = 0.8
