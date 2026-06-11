class_name RewardBox
extends Container

@export var label: RichTextLabel
@export var amount_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func setup(entry: RunData.SummaryEntry):
	label.text = "%s:" % [entry.title]
	amount_label.text = "[font=res://fonts/Retro5.ttf][color=green]+$%s" % [entry.money_movement]
