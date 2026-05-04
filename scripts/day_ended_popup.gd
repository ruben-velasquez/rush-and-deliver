extends Control
class_name DayEndedPopUp

@export var info: RichTextLabel

func setup():
	var daily_costs = GameManager.daily_costs
	var money_amount = GameManager.current_score
	var new_money_amount = money_amount
	var output = ""
	
	for fee in daily_costs:
		new_money_amount -= fee.amount
		output += "%s: [color=red]-%s$[/color]\n" % [fee.name.capitalize(), fee.amount]
	
	output += "Money: %s$" % [new_money_amount]
	info.text = output
