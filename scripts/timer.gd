extends Label

@export var timer: Timer
const DAY_DURATION_SEG: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_timer = timer
	timer.wait_time = DAY_DURATION_SEG
	timer.timeout.connect(GameManager.on_timer_end.emit)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = str(round(timer.time_left))
