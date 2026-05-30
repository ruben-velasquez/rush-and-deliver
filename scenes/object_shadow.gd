extends Sprite2D

const light_dir = Vector2(-0.05, 0.05)
var _owner: Node2D
var pos_offset: Vector2

func _ready() -> void:
	material = material.duplicate(true)
	_owner = get_parent()
	pos_offset = _owner.global_position - global_position
	ShadowsViewport.instance.append_shadow(self)

func _process(_delta: float) -> void:
	if !_owner.is_visible_in_tree(): return hide()
	else: show()
	
	global_position = _owner.global_position + pos_offset
	global_rotation = _owner.global_rotation
	
	global_position -= ShadowsViewport.instance.global_position
	
	material.set_shader_parameter(
		"light_dir",
		light_dir.rotated(-global_rotation)
	)
