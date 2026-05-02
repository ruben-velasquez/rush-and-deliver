extends VBoxContainer

@export var packages_count_label: Label
@export var current_package_label: Label
@export var package_property_label: Label
@export var package_reward_label: Label
@export var package_distance_label: Label

@export var package_info_container: VBoxContainer

@export var all_packages_shipped_label: Label

var deactivated: bool = false

var _player: Node2D
var _goal: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_package_info()

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
	
	if GameManager.done_packages == len(GameManager.packages):
		hide_package_info()
	elif deactivated:
		show_package_info()

func update_current_package():
	update_done_packages()
	_goal = GameManager.get_current_package().goal
	current_package_label.text = "-- Package " + str(GameManager.currentPackage + 1) + " --"
	package_property_label.text = "Property: " + str(Package.PackageProperty.find_key(GameManager.get_current_package().property)).capitalize()
	package_reward_label.text = "Reward: $" + str(GameManager.get_current_package().reward)

func hide_package_info():
	deactivated = true
	all_packages_shipped_label.process_mode = Node.PROCESS_MODE_INHERIT
	all_packages_shipped_label.show()
	package_info_container.process_mode = Node.PROCESS_MODE_DISABLED
	package_info_container.hide()

func show_package_info():
	deactivated = false
	all_packages_shipped_label.process_mode = Node.PROCESS_MODE_DISABLED
	all_packages_shipped_label.hide()
	package_info_container.process_mode = Node.PROCESS_MODE_INHERIT
	package_info_container.show()
