extends VBoxContainer

@export var packages_count_label: Label
@export var current_package_label: Label
@export var package_property_label: Label
@export var package_reward_label: Label
@export var package_distance_label: Label

var _player: Node2D
var _goal: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.on_swap_package.connect(update_current_package)
	GameManager.on_score_updated.connect(update_done_packages)
	_player = GameManager.player
	update_current_package()

func _process(delta: float) -> void:
	if !_player || !_goal: 
		return
	
	# Distance between player and goal
	var distance = sqrt(pow(_goal.position.x - _player.position.x, 2) + pow(_goal.position.y - _player.position.y, 2))
	distance = round(distance) / 2
	
	package_distance_label.text = str(distance) + " m"

func update_done_packages():
	packages_count_label.text = "Packages " + str(GameManager.done_packages) + "/" + str(len(GameManager.packages))

func update_current_package():
	update_done_packages()
	_goal = GameManager.get_current_package().goal
	current_package_label.text = "-- Package " + str(GameManager.currentPackage + 1) + " --"
	package_property_label.text = "Property: " + str(Package.PackageProperty.find_key(GameManager.get_current_package().property)).capitalize()
	package_reward_label.text = "Reward: $" + str(GameManager.get_current_package().reward)
