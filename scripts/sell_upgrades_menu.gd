extends VBoxContainer

const UPGRADE_BOX_NODE: PackedScene = preload("res://scenes/upgrade_box.tscn")
@export var tooltip: Tooltip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in UpgradesManager.current_upgrades:
		add_upgrade(upgrade)
	
	UpgradesManager.on_add_upgrade.connect(add_upgrade)

func add_upgrade(upgrade: Upgrade):
	if upgrade.is_special: return
	var box = UPGRADE_BOX_NODE.instantiate() as UpgradeBox
	box.setup(upgrade, tooltip)
	add_child(box)
