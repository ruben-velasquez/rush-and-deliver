class_name SmartTilemapLayer
extends TileMapLayer

func _ready() -> void:
	var parent = get_parent()
	parent.visibility_changed.connect(_update_collision)
	_update_collision()

func _update_collision():
	collision_enabled = get_parent().visible
