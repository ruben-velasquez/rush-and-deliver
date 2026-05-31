extends Area2D

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(_body: Node2D):
	GameManager.packages_manager.generate_packages()
