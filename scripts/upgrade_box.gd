class_name UpgradeBox
extends HBoxContainer

var upgrade: Upgrade
@export var icon_rect: TextureRect
@export var sell_button: Button

var sell_button_tween: Tween

# Called when the node enters the scene tree for the first time.
func setup(_upgrade: Upgrade, _tooltip: Tooltip):
	upgrade = _upgrade
	icon_rect.texture = UpgradesManager.get_icon(upgrade.id)
	
	icon_rect.mouse_entered.connect(_tooltip.show_tooltip.bind(upgrade.name, upgrade.get_description()))
	icon_rect.mouse_exited.connect(_tooltip.hide_tooltip)
	
	sell_button.text = "SELL $%s" % [floori(upgrade.get_price()*0.75)]
	sell_button.pressed.connect(sell_upgrade)
	sell_button.modulate.a = 0
	sell_button.hide()
	
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)
	

func on_mouse_enter():
	sell_button.show()
	
	if sell_button_tween and !sell_button_tween.finished:
		sell_button_tween.stop()
	
	sell_button_tween = create_tween()
	
	sell_button_tween.tween_property(sell_button, "modulate", Color.WHITE, 0.2)

func on_mouse_exit():
	if sell_button_tween and !sell_button_tween.finished:
		sell_button_tween.stop()
	
	sell_button_tween = create_tween()
	
	sell_button_tween.tween_property(sell_button, "modulate", Color.TRANSPARENT, 0.2)
	
	await sell_button_tween.finished
	
	sell_button.hide()

func sell_upgrade():
	UpgradesManager.sell_upgrade(upgrade)
	queue_free()
