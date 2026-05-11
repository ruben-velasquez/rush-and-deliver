extends Control
class_name DayEndedPopUp

@export var info: RichTextLabel

func setup():
	var daily_costs = GameManager.daily_costs
	var money_amount = RunData.money
	var output = ""
	
	for fee in daily_costs:
		output += "%s: [color=red]-%s$[/color]\n" % [fee.name.capitalize(), fee.amount]
	
	output += "Money: %s$" % [money_amount]
	info.text = output
