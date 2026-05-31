extends Node2D

var goal: Node2D

func _ready() -> void:
	goal = GameManager.packages_manager.get_current_package().goal
	GameManager.packages_manager.on_swap_package.connect(func(): goal = GameManager.packages_manager.get_current_package().goal)

func _process(_delta: float) -> void:
	var objective: Vector2
	
	if goal == null:
		objective = GameManager.packages_manager.RESTORE_AREA_POS
	else:
		objective = goal.global_position
	
	var direction = (objective - global_position).normalized()
	
	var distance = clampf((global_position.distance_to(objective) + 100) / 800, 0.5, 1)
	
	scale = Vector2(distance, distance)
	
	global_rotation = direction.angle()
