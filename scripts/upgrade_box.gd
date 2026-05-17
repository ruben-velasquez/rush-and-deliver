class_name UpgradeBox
extends HBoxContainer

var upgrade: Upgrade
@export var icon_rect: TextureRect
@export var sell_button: Button

# Called when the node enters the scene tree for the first time.
func setup(_upgrade: Upgrade):
	upgrade = _upgrade
	icon_rect.texture = UpgradesManager.get_icon(upgrade.id)
	icon_rect.tooltip_text = upgrade.get_description()
	sell_button.text = "Sell $%s" % [upgrade.base_price]
	sell_button.pressed.connect(sell_upgrade)

func sell_upgrade():
	UpgradesManager.sell_upgrade(upgrade)
	queue_free()
