extends Node2D

var goal: Node2D
var restore_area: Node2D

func _ready() -> void:
	goal = GameManager.packages_manager.get_current_package().goal
	GameManager.packages_manager.on_swap_package.connect(func(): goal = GameManager.packages_manager.get_current_package().goal)

func _process(_delta: float) -> void:
	var objective = goal
	
	if goal == null:
		if restore_area == null:
			restore_area = GameManager.packages_manager.restore_area
		objective = restore_area
		
	var direction = (objective.global_position - global_position).normalized()
	
	var distance = clampf((global_position.distance_to(objective.global_position) + 100) / 800, 0.5, 1)
	
	scale = Vector2(distance, distance)
	
	global_rotation = direction.angle()
