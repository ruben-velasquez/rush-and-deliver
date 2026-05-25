class_name FloatingText
extends RichTextLabel

var camera: Camera2D

func _process(_delta: float) -> void:
	rotation = camera.get_screen_rotation()

func setup(_text: String, _text_color: Color):
	text = _text
	
	add_theme_color_override("default_color", _text_color)
	add_theme_color_override("font_outline_color", Color.WHITE)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	tween.parallel().tween_property(self, "global_position", global_position - 20 * get_global_transform().y, 1)
	
	await tween.finished
	
	FloatingTextFactory.instance.return_item(self)
