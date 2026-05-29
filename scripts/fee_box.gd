class_name FeeBox
extends HBoxContainer

@export var checkbox: CheckBox
@export var title_label: RichTextLabel
var payment_menu: PaymentMenu
var fee: DailyCost

const MONEY_FONT := "res://fonts/Retro5.ttf"

func setup(_fee: DailyCost, _menu: PaymentMenu):
	fee = _fee
	payment_menu = _menu
	
	title_label.text =  "%s: [font=%s][color=red]-%s$[/color][/font]\n" % [fee.get_name().capitalize(), MONEY_FONT, fee.calculate_cost()]
	
	if fee.optional:
		checkbox.button_pressed = false
		checkbox.toggled.connect(on_change)
	else:
		checkbox.button_pressed = true
	
	measure_fee_state()
	
	payment_menu.on_changed_fee.connect(measure_fee_state)

func measure_fee_state():
	if !fee.optional:
		checkbox.disabled = true
	elif !checkbox.button_pressed and payment_menu.money_left < fee.calculate_cost():
		checkbox.disabled = true
	else:
		checkbox.disabled = false

func on_change(toggled_on: bool):
	fee.active = toggled_on
	payment_menu.update_money_left()
