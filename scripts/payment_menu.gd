extends CanvasLayer
class_name PaymentMenu

const MONEY_FONT: String = "res://fonts/Retro5.ttf"
const FEE_BOX_NODE: PackedScene = preload("res://scenes/fee_box.tscn")

@export var continue_button: Button
@export var info: RichTextLabel
@export var fee_boxes_parent: Control

signal on_changed_fee

var money_left: int

func _ready():
	var daily_costs = GameManager.current_costs
	
	for fee in daily_costs:
		fee.active = !fee.optional
		var box = FEE_BOX_NODE.instantiate() as FeeBox
		box.setup(fee, self);
		fee_boxes_parent.add_child(box)
	
	update_money_left()
	
	continue_button.pressed.connect(on_continue)

func update_money_left():
	var daily_costs = GameManager.current_costs
	money_left = RunData.money
	
	for fee in daily_costs:
		if fee.active:
			money_left -= fee.calculate_cost()
	
	on_changed_fee.emit()
	info.text = "Money: [font=%s]%s$[/font]" % [MONEY_FONT, money_left]

func on_continue():
	if money_left < 0:
		GameManager.reset()
		SceneManager.instance.load_main_menu_scene()
	else:
		GameManager.pay_costs()
		SceneManager.instance.load_shop_scene()
