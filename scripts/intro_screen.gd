extends Control

@export var info_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_label.text = "Week %s, day %s" % [RunData.current_week, RunData.current_day]
	
	var tween = create_tween()
	
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1).set_delay(1)
	
	await tween.finished
	
	GameManager.current_timer.start()
	GameManager.player.move = true
