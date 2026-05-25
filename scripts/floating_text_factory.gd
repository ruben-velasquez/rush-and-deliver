class_name FloatingTextFactory
extends Node

static var instance: FloatingTextFactory
@export var camera: Camera2D

var items: Array[FloatingText]
var quantity: int = 5

const ITEM_SCENE: PackedScene = preload("res://scenes/floating_text.tscn")

func _ready() -> void:
	instance = self
	
	GameManager.packages_manager.on_package_delivered.connect(func(package: Package):
		show_text("+$%s" % package.reward, GameManager.player.global_position, GamePallete.SAFE_COLOR)
	)
	
	GameManager.packages_manager.on_fail_package.connect(func(_package: Package):
		show_text("Package broken", GameManager.player.global_position, GamePallete.DANGER_COLOR)
	)
	
	GameManager.packages_manager.on_late_package.connect(func():
		show_text("Late package", GameManager.player.global_position, GamePallete.DANGER_COLOR)
	)
	
	GameManager.player.on_engine_damaged.connect(func():
		show_text("Engine damaged", GameManager.player.global_position, GamePallete.DANGER_COLOR)
	)
	
	for i in range(quantity):
		var item = ITEM_SCENE.instantiate() as FloatingText
		item.camera = camera
		item.hide()
		items.append(item)
		add_child(item)

func get_item() -> FloatingText:
	var item = items.pop_back()
	item.show()
	return item

func show_text(_text: String, _position: Vector2, _text_color: Color):
	var item = get_item()
	item.global_position = _position
	item.setup(_text, _text_color)

func return_item(item: FloatingText):
	item.hide()
	item.modulate = Color.WHITE
	items.append(item)
