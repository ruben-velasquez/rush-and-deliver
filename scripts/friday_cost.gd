class_name FridayExpense
extends DailyCost

func should_appear() -> bool:
	return RunData.current_day == 5
