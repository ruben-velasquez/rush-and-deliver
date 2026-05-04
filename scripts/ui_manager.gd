extends CanvasLayer

@export var finish_popup: DayEndedPopUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finish_popup.process_mode = Node.PROCESS_MODE_DISABLED
	finish_popup.hide()
	GameManager.on_timer_end.connect(show_finish_popup)

func show_finish_popup():
	finish_popup.process_mode = Node.PROCESS_MODE_INHERIT
	finish_popup.show()
	finish_popup.setup()
