class_name FridayExpensesInfo
extends VBoxContainer

@export var summary: VBoxContainer
@export var total_label: RichTextLabel

const billEntryScene: PackedScene = preload("res://scenes/bill_entry.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if RunData.current_day == 5: hide()
	
	var total: int = 0
	
	for c in GameManager.get_costs_pool():
		var cost = c.call() as DailyCost
		
		if cost is not FridayExpense:
			continue
		
		var billEntry = billEntryScene.instantiate() as BillEntry
		
		summary.add_child(billEntry)
		
		total += cost.amount
		
		billEntry.setupCost(cost, Color("8b8b8b"), false)
	
	total_label.text = "-$%s" % [total]
