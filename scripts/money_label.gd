extends Label

func _ready() -> void:
	on_score_updated()
	GameManager.on_score_updated.connect(on_score_updated)

func on_score_updated():
	text = "$" + str(GameManager.current_score)
