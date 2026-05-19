extends RichTextLabel

const MONEY_FONT = "res://fonts/Retro5.ttf"

func _ready() -> void:
	update_estimated()
	GameManager.packages_manager.on_fail_package.connect(update_estimated)
	GameManager.player.on_crash.connect(update_estimated)

func update_estimated():
	text = "Estimated Costs: [font=%s]$%s" % [MONEY_FONT, GameManager.get_estimated_costs()]
