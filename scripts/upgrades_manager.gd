extends Node2D

const ICONS: AtlasDB = preload("res://objects/upgrade_icons.tres")

var current_upgrades: Array[Upgrade] = []
var upgrade_pool: Array[Callable] = [
	func(): return CapacityUpgrade.new(),
	func(): return SpeedUpgrade.new(),
	func(): return ReinforcedStorageUpgrade.new(),
	func(): return RushDeliveryLicenseUpgrade.new(),
	func(): return RiskyDeliveryUpgrade.new(),
	func(): return HeavyHaulerUpgrade.new(),
	func(): return CheapRepairUpgrade.new(),
]

signal on_upgrades_change
signal on_add_upgrade(upgrade: Upgrade)

func _ready() -> void:
	GameManager.on_day_end.connect(on_day_end)
	GameManager.on_day_start.connect(on_day_start)
	on_upgrades_change.connect(rebuild_stats)

func on_day_start():
	for upgrade in current_upgrades:
		upgrade.on_day_start()

func on_day_end():
	for upgrade in current_upgrades:
		upgrade.on_day_end()

func rebuild_stats():
	RunData.stats = RunStats.new()
	
	for upgrade in current_upgrades:
		upgrade.apply_stats()

func add_upgrade(upgrade: Upgrade):
	if upgrade.unique and unique_upgrades_quantity() >= RunData.stats.max_unique_upgrades: return
	if RunData.money <  get_upgrade_price(upgrade): return
	
	GameManager.give_money(-get_upgrade_price(upgrade))
	current_upgrades.append(upgrade)
	upgrade.on_purchase()
	
	on_upgrades_change.emit()
	on_add_upgrade.emit(upgrade)

func sell_upgrade(upgrade: Upgrade):
	if !has_upgrade(upgrade) or !upgrade.unique: return
	
	GameManager.give_money(upgrade.base_price)
	current_upgrades.erase(upgrade)
	print(has_upgrade(upgrade))
	
	on_upgrades_change.emit()

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

func unique_upgrades_quantity() -> int:
	var count = 0
	
	for upg in current_upgrades:
		if upg.unique:
			count += 1
	
	return count

func get_icon(id: String) -> Texture2D:
	if ICONS.sprites.has(id):
		return ICONS.sprites.get(id)
	return ICONS.sprites.get("capacity")
