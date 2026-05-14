extends Control
class_name DayEndedPopUp

@export var info: RichTextLabel

func setup():
	var daily_costs = GameManager.current_costs
	var output = ""
	
	for fee in daily_costs:
		output += "%s: [color=red]-%s$[/color]\n" % [fee.name.capitalize(), fee.calculate_cost()]
	
	output += "Money: %s$" % [RunData.money]
	info.text = output
