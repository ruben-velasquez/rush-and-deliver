extends CanvasLayer
class_name PaymentMenu

const MONEY_FONT: String = "res://fonts/Retro5.ttf"
@export var info: RichTextLabel

func _ready():
	var daily_costs = GameManager.current_costs
	var output = ""
	
	for fee in daily_costs:
		output += "%s: [font=%s][color=red]-%s$[/color][/font]\n" % [fee.name.capitalize(), MONEY_FONT, fee.calculate_cost()]
	
	output += "Money: [font=%s]%s$[/font]" % [MONEY_FONT, RunData.money]
	info.text = output
