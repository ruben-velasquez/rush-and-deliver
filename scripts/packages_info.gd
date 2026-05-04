extends VBoxContainer

@export var packages_count_label: Label
@export var current_package_label: Label
@export var package_property_label: RichTextLabel
@export var package_reward_label: Label
@export var package_distance_label: Label
@export var package_data_label: RichTextLabel

@export var package_info_container: VBoxContainer

@export var all_packages_shipped_label: Label

var packages_manager: PackagesManager
var deactivated: bool = false

var _player: Node2D
var _goal: Node2D

const PROPERTIES_COLORS: Dictionary[String, String] = {
	"Fragile": "8affe2",
	"Urgent": "ffc18a",
	"Heavy": "ff928a",
	"Normal": "ffffff"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_package_info()

	GameManager.packages_manager.on_swap_package.connect(update_current_package)
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
	
	var package = packages_manager.get_current_package()
	
	if packages_manager.is_urgent(package):
		package_data_label.text = "Bonus time left: %s" % [roundf(package.urgent_time_left)]
	elif packages_manager.is_fragile(package):
		package_data_label.text = "Health: %s" % [package.fragile_health]
	else:
		package_data_label.text = ""

func update_done_packages():
	if packages_manager == null:
		packages_manager = GameManager.packages_manager
	
	packages_count_label.text = "Packages " + str(GameManager.packages_manager.done_count()) + "/" + str(len(GameManager.packages_manager.packages))
	
	if packages_manager.all_done():
		hide_package_info()
	elif deactivated:
		show_package_info()

func update_current_package():
	update_done_packages()
	var package = packages_manager.get_current_package()
	_goal = package.goal
	current_package_label.text = "-- Package " + str(packages_manager.currentPackage + 1) + " --"
	
	var property = str(Package.PackageProperty.find_key(package.property)).capitalize()
	var property_color = PROPERTIES_COLORS[property]
	package_property_label.text = "Property: [color=%s]%s[/color]" % [property_color, property]
	
	package_reward_label.text = "Reward: $" + str(package.reward)

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
