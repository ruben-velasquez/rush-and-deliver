extends Label

func _ready() -> void:
	on_score_updated()
	GameManager.on_money_updated.connect(on_score_updated)

func on_score_updated():
	text = "$" + str(RunData.money)
