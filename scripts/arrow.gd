extends Node2D

var goal: Node2D

func _ready() -> void:
	GameManager.on_swap_package.connect(func(): goal = GameManager.get_current_package().goal)

func _process(delta: float) -> void:
	if !goal:
		return hide()
		
	var direction = (goal.position - global_position).normalized()
	
	global_rotation = direction.angle()
