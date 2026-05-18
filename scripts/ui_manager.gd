extends CanvasLayer
class_name UIManager

@export var game_over_screen: DayEndedPopUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_window(game_over_screen)
	GameManager.ui_manager = self

func show_game_over_screen():
	show_window(game_over_screen)
	game_over_screen.setup()

func hide_window(_c: Control):
	_c.process_mode = Node.PROCESS_MODE_DISABLED
	_c.hide() 

func show_window(_c: Control):
	_c.process_mode = Node.PROCESS_MODE_INHERIT
	_c.show()
