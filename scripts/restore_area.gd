extends Area2D

func _ready() -> void:
	GameManager.packages_manager.restore_area = self
	body_entered.connect(on_body_entered)

func on_body_entered(_body: Node2D):
	GameManager.packages_manager.generate_packages()
