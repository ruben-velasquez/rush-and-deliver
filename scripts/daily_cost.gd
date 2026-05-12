class_name DailyCost
extends Object

var name := ""
var amount := 0

func calculate_cost() -> int:
	return amount

func should_appear() -> bool:
	return false

func can_appear() -> bool:
	return false
