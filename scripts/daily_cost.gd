class_name DailyCost
extends Object

var name := ""
var amount := 0
var optional := false
var active := true

func get_name() -> String:
	return name

func calculate_cost() -> int:
	return amount

func should_appear() -> bool:
	return false

func can_appear() -> bool:
	return false

func on_pay():
	pass
