class_name Chunk
extends Node2D

var coord: Vector2i = Vector2i.ZERO
var contents: Dictionary[String, Node2D] = {}
var current_content: Node2D

func update_coords(_coords: Vector2i):
	coord = _coords
	
	set_content(WorldGen.get_chunk_id(coord))

func set_content(id: String):
	if current_content:
		current_content.process_mode = Node.PROCESS_MODE_DISABLED
		current_content.set_physics_process(false)
		current_content.hide()
	
	if(contents.has(id)):
		current_content = contents[id]
		current_content.process_mode = Node.PROCESS_MODE_INHERIT
		current_content.set_physics_process(true)
		current_content.show()
	else:
		var content = TerrainManager.instance.get_chunk_content(id).instantiate()
		contents[id] = content
		current_content = content
		
		add_child(content)
