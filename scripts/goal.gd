extends Area2D
class_name Goal

var appear_range: int = 500
var package: Package

func _on_body_entered(_body: Node2D) -> void:
	GameManager.packages_manager.deliver(package)
	queue_free()

func set_goal_zone():
	position.x = randi_range(-appear_range, appear_range)
	position.y = randi_range(-appear_range, appear_range)
