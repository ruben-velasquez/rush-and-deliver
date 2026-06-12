class_name BillEntry
extends MarginContainer

@export var label: RichTextLabel
@export var amount_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func setup(entry: RunData.SummaryEntry, color: Color = Color("8b8b8b"), indent: bool = false, signPrefix: String = "-"):
	if indent:
		add_theme_constant_override("margin_left", 34)
		
	label.text = "%s:" % [entry.title]
	amount_label.text = "[font=res://fonts/Retro5.ttf][color=%s]%s$%s" % [
		color.to_html(),
		signPrefix,
		entry.money_movement
	]

func setupCost(cost: DailyCost, color: Color = Color("8b8b8b"), indent: bool = false, signPrefix: String = "-"):
	if indent:
		add_theme_constant_override("margin_left", 34)
		

	label.text = "%s:" % [cost.name]
	amount_label.text = "[font=res://fonts/Retro5.ttf][color=%s]%s$%s" % [
		color.to_html(),
		signPrefix,
		cost.amount
	]
