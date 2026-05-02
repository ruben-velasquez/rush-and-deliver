extends VBoxContainer

@export var packages_count_label: Label
@export var current_package_label: Label
@export var package_property_label: Label
@export var package_reward_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.on_swap_package.connect(update_current_package)
	GameManager.on_score_updated.connect(update_done_packages)

func update_done_packages():
	packages_count_label.text = "Packages " + str(GameManager.done_packages) + "/" + str(len(GameManager.packages))

func update_current_package():
	current_package_label.text = "-- Package " + str(GameManager.currentPackage + 1) + " --"
	package_property_label.text = "Property: " + str(Package.PackageProperty.find_key(GameManager.get_current_package().property)).capitalize()
	package_reward_label.text = "Reward: $" + str(GameManager.get_current_package().reward)
