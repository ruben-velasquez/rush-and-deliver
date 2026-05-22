extends RichTextLabel

const MONEY_FONT = "res://fonts/Retro5.ttf"

func _ready() -> void:
	update_estimated()
	GameManager.packages_manager.on_fail_package.connect(update_estimated)
	GameManager.player.on_crash.connect(update_estimated)
	GameManager.on_money_updated.connect(update_estimated)

func update_estimated():
	var money_text: String
	var estimated_costs = GameManager.get_estimated_costs()
	
	if RunData.money < estimated_costs:
		money_text = "[color=RED]$%s[/color]" % [estimated_costs]
	else:
		money_text = "[color=GREEN]$%s[/color]" % [estimated_costs]
	
	money_text = "[outline_size=7][outline_color=WHITE]%s[/outline_color][/outline_size]" % money_text
	
	text = "Estimated Costs: [font=%s]%s" % [MONEY_FONT, money_text]
