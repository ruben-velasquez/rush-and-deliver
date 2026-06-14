extends TextureProgressBar

@export var label: RichTextLabel

const RED_COLOR = "#f7436a"
const GREEN_COLOR = "#6dfc8a"

func _ready() -> void:
	update_estimated()
	GameManager.packages_manager.on_fail_package.connect(update_estimated)
	GameManager.packages_manager.on_late_package.connect(update_estimated)
	GameManager.player.on_crash.connect(update_estimated)
	GameManager.on_money_updated.connect(update_estimated)

func update_estimated(_p: Package = null):
	var money_text: String
	var estimated_costs = GameManager.get_estimated_costs()
	max_value = GameManager.get_estimated_costs()
	value = min(RunData.money, max_value)
	
	if RunData.money < estimated_costs:
		tint_progress = Color(RED_COLOR)
		money_text = "[color=%s]$%s[/color]" % [RED_COLOR, estimated_costs]
	else:
		tint_progress = Color(GREEN_COLOR)
		money_text = "[color=%s]$%s[/color]" % [GREEN_COLOR,estimated_costs]
	
	label.text = "ESTIMATED COSTS: %s" % [money_text]
