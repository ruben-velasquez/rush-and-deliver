class_name Tooltip
extends PanelContainer

@export var title_label: RichTextLabel
@export var description_label: RichTextLabel

const OFFSET = Vector2(10.,10.)
var current_offset := OFFSET

func _ready() -> void:
	hide_tooltip()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		var screen_rect: Rect2 = get_viewport_rect()
		var tooltip_size: Vector2 = get_global_rect().size
		var target_pos: Vector2 = get_global_mouse_position() + OFFSET
		
		target_pos.x = clamp(target_pos.x, screen_rect.position.x, screen_rect.end.x - tooltip_size.x - OFFSET.x)
		target_pos.y = clamp(target_pos.y, screen_rect.position.y, screen_rect.end.y - tooltip_size.y - OFFSET.y)
		
		global_position = target_pos

func show_tooltip(title: String, description: String):
	show()
	
	title_label.text = title
	description_label.text = description.trim_prefix(" ").trim_suffix(" ")

func hide_tooltip():
	hide()
