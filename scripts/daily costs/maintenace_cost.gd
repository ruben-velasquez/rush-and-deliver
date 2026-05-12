class_name MaintenaceCost
extends DailyCost

func _init() -> void:
	name = "Car maintenace"
	amount = 20

func can_appear() -> bool:
	return true
