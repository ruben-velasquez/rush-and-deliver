extends Node2D

var current_upgrades: Array[Upgrade] = []

func _ready() -> void:
	GameManager.on_day_end.connect(on_day_end)
	GameManager.on_day_start.connect(on_day_start)

func on_day_start():
	for upgrade in current_upgrades:
		upgrade.on_day_start()

func on_day_end():
	for upgrade in current_upgrades:
		upgrade.on_day_end()

func add_upgrade(upgrade: Upgrade):
	if RunData.money <  get_upgrade_price(upgrade): return
	GameManager.give_money(-get_upgrade_price(upgrade))
	current_upgrades.append(upgrade)
	upgrade.on_purchase()

func get_upgrade_price(upgrade: Upgrade) -> int:
	return upgrade.get_price()
