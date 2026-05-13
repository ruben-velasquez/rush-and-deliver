class_name Upgrade
extends Object

var name: String
var base_price: int
var unique: bool
var weight: int

func on_purchase():
	pass

func on_day_start():
	pass

func on_day_end():
	pass

func get_description() -> String:
	return ""

func get_price() -> int:
	return base_price

func can_appear() -> bool:
	return true

func apply_stats():
	pass
