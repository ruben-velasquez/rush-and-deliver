extends VBoxContainer

const PACKAGE_ICON_SCENE: PackedScene = preload("res://scenes/package_icon.tscn")
@export var icons_parent: Control

@export var packages_count_label: Label

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
	
	for i in range(RunData.stats.package_capacity):
		var icon = PACKAGE_ICON_SCENE.instantiate() as PackageIcon
		icons_parent.add_child(icon)

	GameManager.packages_manager.on_swap_package.connect(update_current_package)
	GameManager.packages_manager.on_package_delivered.connect(update_icons.unbind(1))
	GameManager.on_money_updated.connect(update_done_packages)
	_player = GameManager.player
	update_current_package()

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
	update_icons()
	var package = packages_manager.get_current_package()
	_goal = package.goal

func hide_package_info():
	deactivated = true
	all_packages_shipped_label.process_mode = Node.PROCESS_MODE_INHERIT
	all_packages_shipped_label.show()

func show_package_info():
	deactivated = false
	all_packages_shipped_label.process_mode = Node.PROCESS_MODE_DISABLED
	all_packages_shipped_label.hide()

func update_icons():
	var packages = packages_manager.get_active_packages()
	for i in range(RunData.stats.package_capacity):
		var icon = icons_parent.get_child(i) as PackageIcon
		if i >= len(packages):
			icon.hide()
			continue
		icon.show()
		icon.setup(packages[i])
