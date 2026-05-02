extends Area2D

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(_body: Node2D):
	GameManager.regenerate_packages()
