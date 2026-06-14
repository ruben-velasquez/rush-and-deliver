extends Label

@export var timer: Timer

func _ready() -> void:
	GameManager.current_timer = timer
	timer.wait_time = RunData.stats.day_duration_segs
	timer.timeout.connect(GameManager.on_timer_end.emit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var total_minutes =  480
	var minutes_elapsed = floori(((total_minutes as float) / RunData.stats.day_duration_segs) * timer.time_left)
	minutes_elapsed = 480 - minutes_elapsed
	
	var relative_hour = floori(minutes_elapsed / 60.)
	var relative_minutes = floori(((minutes_elapsed / 60.) - floori(minutes_elapsed / 60.)) * 60.)
	
	text = "%02d : %02d" % [relative_hour, relative_minutes]
