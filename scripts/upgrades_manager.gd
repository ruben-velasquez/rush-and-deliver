extends Node2D

var current_upgrades: Array[Upgrade] = []
var upgrade_pool: Array[Callable] = [
	func(): return CapacityUpgrade.new()
]

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

func get_random_upgrade(pool: Array[Upgrade]) -> Upgrade:
	var weight_total := 0.0
	
	for upgrade in pool:
		weight_total += upgrade.weight
	
	var random_weight = randf_range(0, weight_total)
	var weight_count = 0
	
	for upgrade in pool:
		weight_count += upgrade.weight
		if random_weight <= weight_count:
			return upgrade
	
	return 

func generate_shop(quantity: int) -> Array[Upgrade]:
	var available_upgrades: Array[Upgrade] = []
	var shop_upgrades: Array[Upgrade] = []
	
	for _upg in upgrade_pool:
		var upgrade = _upg.call() as Upgrade
		
		if upgrade.unique and has_upgrade(upgrade):
			continue
		
		if upgrade.can_appear():
			available_upgrades.append(upgrade)
	
	for i in range(quantity):
		if available_upgrades.is_empty(): break
		
		var selected = get_random_upgrade(available_upgrades)
		
		available_upgrades.erase(selected)
		
		shop_upgrades.append(selected)
	
	return shop_upgrades

func has_upgrade(upgrade: Upgrade) -> bool:
	return current_upgrades.any(func(_upg):
		return upgrade.name == _upg.name
	)
	
