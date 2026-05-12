extends Node2D
class_name PackagesManager

const GOAL_SCENE = preload("res://scenes/goal.tscn")
var packages: Array[Package]
var currentPackage: int = 0
var restore_area: Area2D

signal on_swap_package

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.packages_manager = self
	generate_packages()
	
	call_deferred("_late_ready")

func _late_ready():
	GameManager.player.on_crash.connect(on_player_crash)

func _process(delta: float) -> void:
	GameManager.player.velocity_multiplier = 1.0
	
	for package in packages:
		if package.done or package.failed: continue
		
		if is_urgent(package):
			package.urgent_time_left -= delta
			if package.urgent_time_left <= 0:
				RunData.day_late_packages += 1
				fail(package)
		
		if is_heavy(package) and is_current_package(package):
			GameManager.player.velocity_multiplier = package.weight_multiplier

func deliver(package: Package):
	package.done = true
	GameManager.give_money(package.reward)
	
	if is_current_package(package):
		next_package()

func fail(package: Package):
	package.failed = true
	package.done = true
	if is_instance_valid(package.goal):
		package.goal.queue_free()
	
	if is_current_package(package):
		next_package()
	
	on_swap_package.emit()

func generate_packages():
	currentPackage = 0
	
	if packages.is_empty():
		packages.resize(RunData.package_capacity)
	
	for i in range(RunData.package_capacity):
		if packages[i] and !packages[i].done:
			continue
		
		var newPackage = _generate_package()
		
		packages[i] = newPackage
		
	on_swap_package.emit()

func _generate_package() -> Package:
	var newPackage = Package.new()
	newPackage.property = Package.PackageProperty.values().pick_random()
	
	var goalInstance: Goal = GOAL_SCENE.instantiate()
	goalInstance.package = newPackage
	goalInstance.set_goal_zone()
	get_tree().current_scene.add_child.call_deferred(goalInstance)
	newPackage.goal = goalInstance
	newPackage.setup()
	
	newPackage.reward = _calculate_reward(newPackage.property, Vector2i.ZERO.distance_to(goalInstance.position))
	
	return newPackage

func _calculate_reward(property: Package.PackageProperty, distance: float):
	var base = 2
	var per_distance = distance * 0.8 / 100
	var multiplier = 1.0
	var randomness = randf_range(0.9, 1.1)
	
	match property:
		Package.PackageProperty.URGENT:
			multiplier = 2.2
		Package.PackageProperty.HEAVY:
			multiplier = 1.3
		Package.PackageProperty.FRAGILE:
			multiplier = 1.5
	
	var reward = (base + per_distance) * multiplier * randomness
	
	return reward

func next_package():
	if all_done():
		return
	
	currentPackage += 1
	# Fix out of bound index
	if currentPackage > len(packages) - 1:
		currentPackage = 0
	# If the package is already shipped we skip it
	if get_current_package().done:
		return next_package()
	
	on_swap_package.emit()

func previous_package():
	if all_done():
		return
		
	currentPackage -= 1
	# Fix out of bound index
	if currentPackage < 0:
		currentPackage = len(packages) - 1
	# If the package is already shipped we skip it
	if get_current_package().done:
		return previous_package()
		
	on_swap_package.emit()

func get_current_package() -> Package:
	return packages[currentPackage]

func done_count() -> int:
	var count := 0
	for p in packages:
		if p.done and !p.failed:
			count += 1
	return count

func all_done() -> bool:
	for p in packages:
		if !p.done:
			return false
	return true

func on_player_crash():
	for package in packages:
		if package.property == Package.PackageProperty.FRAGILE and !package.failed and !package.done:
			package.fragile_health -= 1
			
			if package.fragile_health <= 0:
				RunData.day_broken_packages += 1
				fail(package)
			else:
				on_swap_package.emit()

# Helpers

func is_current_package(pkg: Package) -> bool:
	return packages.find(pkg) == currentPackage

func is_heavy(pkg: Package) -> bool:
	return pkg.property == Package.PackageProperty.HEAVY

func is_urgent(pkg: Package) -> bool:
	return pkg.property == Package.PackageProperty.URGENT

func is_fragile(pkg: Package) -> bool:
	return pkg.property == Package.PackageProperty.FRAGILE
