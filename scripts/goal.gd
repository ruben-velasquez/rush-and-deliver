extends Area2D
class_name Goal

const WAIT_TIME_SEG = 1

@export var sprite: Sprite2D

var appear_range: int = 500
var package: Package
var player_on_zone: bool = false
var player_time = 0

func _on_body_entered(_body: Node2D) -> void:
	player_time = 0
	player_on_zone = true

func _on_body_exited(_body: Node2D) -> void:
	player_time = 0
	player_on_zone = false

func _process(delta: float) -> void:
	if player_on_zone:
		player_time += delta
	
	if player_time >= WAIT_TIME_SEG:
		GameManager.packages_manager.deliver(package)
		queue_free()
	
	sprite.self_modulate = lerp(Color.WHITE, Color.LAWN_GREEN, player_time/WAIT_TIME_SEG)

func set_goal_zone():
	position.x = randi_range(-appear_range, appear_range)
	position.y = randi_range(-appear_range, appear_range)
