extends Button

enum ButtonType { LOAD_SCENE, EXIT_GAME, NEXT_DAY }

@export var buttonType = ButtonType.LOAD_SCENE
@export_file("*.tscn") var sceneToLoad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _pressed() -> void:
	match buttonType:
		ButtonType.NEXT_DAY:
			GameManager.start_day()
		ButtonType.LOAD_SCENE:
			print(sceneToLoad)
			SceneManager.instance.load_scene(sceneToLoad)
		ButtonType.EXIT_GAME:
			get_tree().quit()
