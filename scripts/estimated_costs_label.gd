extends RichTextLabel

const MONEY_FONT = "res://fonts/Retro5.ttf"
const RED_COLOR = "#be173b"
const GREEN_COLOR = "#57b069"

func _ready() -> void:
	update_estimated()
	GameManager.packages_manager.on_fail_package.connect(update_estimated)
	GameManager.player.on_crash.connect(update_estimated)
	GameManager.on_money_updated.connect(update_estimated)

func update_estimated(_p: Package = null):
	var money_text: String
	var estimated_costs = GameManager.get_estimated_costs()
	
	if RunData.money < estimated_costs:
		money_text = "[color=%s]$%s[/color]" % [RED_COLOR, estimated_costs]
	else:
		money_text = "[color=%s]$%s[/color]" % [GREEN_COLOR,estimated_costs]
	
	money_text = "[outline_size=7][outline_color=WHITE]%s[/outline_color][/outline_size]" % money_text
	
	text = "Estimated Costs: [font=%s]%s" % [MONEY_FONT, money_text]
