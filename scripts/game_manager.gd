extends Node

var scene_manager: SceneManager

var current_day: int = 1
var current_score: int = 0
var current_timer: Timer

var done_packages: int = 1

var packages: Array[Package]
var currentPackage: int = 0

var player: Node2D

signal on_timer_end
signal on_score_updated
signal on_swap_package

const GOAL_SCENE = preload("res://scenes/goal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the minimum size for the current window
	get_window().min_size = Vector2i(640, 360)

func _SetScore(newScore: int):
	current_score = newScore
	on_score_updated.emit()

func ShippedPackage(packageIndex: int):
	done_packages += 1
	_SetScore(current_score + packages[packageIndex].reward)
	packages[packageIndex].done = true
	
	if packageIndex == currentPackage:
		next_package()

func next_day():
	current_day += 1
	scene_manager.reload_scene()

func generate_packages():
	
	packages.clear()
	currentPackage = 0
	done_packages = 0
	for i in range(3):
		var newPackage = Package.new()
		newPackage.property = Package.PackageProperty.values().pick_random()
		newPackage.reward = randi_range(1, 5)
		
		var goalInstance: Goal = GOAL_SCENE.instantiate()
		goalInstance.packageIndex = i
		goalInstance.set_goal_zone()
		get_tree().current_scene.add_child.call_deferred(goalInstance)
		newPackage.goal = goalInstance
		
		packages.append(newPackage)
		
	on_swap_package.emit()

func next_package():
	if done_packages == len(packages):
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
	if done_packages == len(packages):
		return
		
	currentPackage -= 1
	# Fix out of bound index
	if currentPackage < 0:
		currentPackage = len(packages) - 1
	# If the package is already shipped we skip it
	if get_current_package().done:
		return next_package()
		
	on_swap_package.emit()
	
func get_current_package() -> Package:
	return packages[currentPackage]
