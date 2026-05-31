extends Label

@export var timer: Timer

func _ready() -> void:
	GameManager.current_timer = timer
	timer.wait_time = RunData.stats.day_duration_segs
	timer.timeout.connect(GameManager.on_timer_end.emit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = str(round(timer.time_left))
