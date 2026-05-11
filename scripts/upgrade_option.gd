extends Node

@export var purchase_button: Button
@export var label: Label

var _upgrade: Upgrade

func _ready() -> void:
	setup(
		CapacityUpgrade.new()
	)

# Called when the node enters the scene tree for the first time.
func setup(_u: Upgrade):
	_upgrade = _u
	
	label.text = _upgrade.name
	label.tooltip_text = _upgrade.get_description()
	purchase_button.text = "%s$" % UpgradesManager.get_upgrade_price(_upgrade)
	if RunData.money < UpgradesManager.get_upgrade_price(_upgrade):
		purchase_button.disabled = true
	purchase_button.pressed.connect(on_purchase)

func on_purchase():
	purchase_button.disabled = true
	UpgradesManager.add_upgrade(_upgrade)
