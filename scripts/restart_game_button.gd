extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(reset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func reset():
	GameManager.reset()
	SceneManager.instance.reload_scene()
