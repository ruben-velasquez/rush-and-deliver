class_name WorldGen
extends Object

static func get_chunk_id(coords: Vector2i) -> String:
	if coords == Vector2i.ZERO:
		return "002"
	else:
		return "001"
