class_name InterestsUpgrade
extends Upgrade

func _init() -> void:
	name = "Interest"
	id = "interest"
	base_price = 20
	unique = false

func on_day_end():
	var brute_money = RunData.money
	var fee_costs = GameManager.get_estimated_costs()
	var liquid_money = brute_money - fee_costs
	var interest: int = floor(liquid_money/5.)
	
	if interest >= 1:
		GameManager.give_money(interest)
		var summary = RunData.SummaryEntry.new()
		summary.title = "Interest"
		summary.money_movement = interest
		summary.appear_bottom = true
		RunData.day_summary.append(summary)

func get_description() -> String:
	return "Receive $1 for every $5 remaining after daily expenses"
