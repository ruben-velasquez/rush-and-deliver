extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_package_left"):
		GameManager.packages_manager.previous_package()
	elif Input.is_action_just_pressed("swap_package_right"):
		GameManager.packages_manager.next_package()
