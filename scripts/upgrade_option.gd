class_name UpgradeOption
extends Node

@export var purchase_button: Button
@export var label: Label
@export var texture: TextureRect

var _upgrade: Upgrade

# Called when the node enters the scene tree for the first time.
func setup(_u: Upgrade):
	_upgrade = _u
	
	label.text = _upgrade.name
	label.tooltip_text = _upgrade.get_description()
	purchase_button.text = "$%s" % UpgradesManager.get_upgrade_price(_upgrade)
	texture.texture = UpgradesManager.get_icon(_u.id)
	
	measure_availability()
	UpgradesManager.on_upgrades_change.connect(measure_availability)
	
	purchase_button.pressed.connect(on_purchase)

func measure_availability():
	if UpgradesManager.has_upgrade(_upgrade):
		purchase_button.disabled = true
		purchase_button.tooltip_text = "Already purchased"
	elif RunData.money < UpgradesManager.get_upgrade_price(_upgrade):
		purchase_button.disabled = true
		purchase_button.tooltip_text = "Not enough money"
	elif _upgrade.unique and RunData.stats.max_unique_upgrades <= UpgradesManager.unique_upgrades_quantity():
		purchase_button.disabled = true
		purchase_button.tooltip_text = "Not enough space"
	else:
		purchase_button.disabled = false
		purchase_button.tooltip_text = ""

func on_purchase():
	purchase_button.disabled = true
	UpgradesManager.add_upgrade(_upgrade)
