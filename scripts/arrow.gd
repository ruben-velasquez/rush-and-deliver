extends Node2D

var goal: Node2D

func _ready() -> void:
	goal = GameManager.packages_manager.get_current_package().goal
	GameManager.on_swap_package.connect(func(): goal = GameManager.packages_manager.get_current_package().goal)

func _process(_delta: float) -> void:
	visible = goal != null
	
	if !visible:
		return
		
	var direction = (goal.position - global_position).normalized()
	
	var distance = clampf((global_position.distance_to(goal.position) + 100) / 800, 0.5, 1)
	
	scale = Vector2(distance, distance)
	
	global_rotation = direction.angle()
