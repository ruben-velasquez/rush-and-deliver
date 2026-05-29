extends Label

@export var timer: Timer
const DAY_DURATION_SEG: float = 40

func _ready() -> void:
	GameManager.current_timer = timer
	timer.wait_time = DAY_DURATION_SEG
	timer.timeout.connect(GameManager.on_timer_end.emit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = str(round(timer.time_left))
