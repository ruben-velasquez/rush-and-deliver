extends Node

const UPGRADE_OPTION_SCENE: PackedScene = preload("res://scenes/upgrade_option.tscn")

@export var tooltip: Tooltip

@export var special_upgrade_option: UpgradeOption

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var upgrades = UpgradesManager.generate_shop(3)
	
	for upgrade in upgrades:
		var option_node = UPGRADE_OPTION_SCENE.instantiate() as UpgradeOption
		
		add_child(option_node)
		

		option_node.setup(upgrade, tooltip)
	
	special_upgrade_option.setup(UpgradesManager.get_special_upgrade(), tooltip)
