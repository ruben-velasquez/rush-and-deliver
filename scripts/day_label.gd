extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Week %s, Day %s" % [RunData.current_week, RunData.current_day]
