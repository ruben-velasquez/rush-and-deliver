class_name DailyCost
extends Object

var name := ""
var amount := 0
var optional := false
var active := true
var tooltip := false

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

func on_skip():
	pass

func get_description() -> String:
	return ""
