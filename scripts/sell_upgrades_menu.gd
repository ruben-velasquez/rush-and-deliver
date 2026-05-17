extends VBoxContainer

const UPGRADE_BOX_NODE: PackedScene = preload("res://scenes/upgrade_box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in UpgradesManager.current_upgrades:
		add_upgrade(upgrade)
	
	UpgradesManager.on_add_upgrade.connect(add_upgrade)

func add_upgrade(upgrade: Upgrade):
	if !upgrade.unique: return
	var box = UPGRADE_BOX_NODE.instantiate() as UpgradeBox
	box.setup(upgrade)
	add_child(box)
