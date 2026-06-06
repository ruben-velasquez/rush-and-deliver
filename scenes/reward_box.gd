class_name RewardBox
extends HBoxContainer

@export var label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func setup(entry: RunData.SummaryEntry):
	label.text = "%s: [font=res://fonts/Retro5.ttf][color=green]+$%s" % [entry.title, entry.money_movement]
