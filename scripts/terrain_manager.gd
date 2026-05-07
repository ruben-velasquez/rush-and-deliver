extends Node2D
class_name TerrainManager

var _player: Node2D
var last_chunk: Vector2i = Vector2i(99,99)
var current_chunk: Vector2i = Vector2i(0,0)

const CHUNK_SCENE = preload("res://scenes/chunk.tscn")
const CHUNK_SIZE: int = 384
const CHUNKS_POS: Array[Vector2i] = [
	Vector2i(0,0),
	Vector2i(0,1),
	Vector2i(0,-1),
	Vector2i(1,0),
	Vector2i(1,1),
	Vector2i(1,-1),
	Vector2i(-1,0),
	Vector2i(-1,1),
	Vector2i(-1,-1),
	Vector2i(0, -2),
	Vector2i(0, 2),
	Vector2i(-2, 0),
	Vector2i(2, 0)
]

var chunks_grid: Dictionary[Vector2i, Node2D] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player = GameManager.player
	
	for pos in CHUNKS_POS:
		chunks_grid[pos] = _create_chunk()
	render_chunks()

func _process(_delta: float) -> void:
	# Get nearest chunk to the player
	var chunk_pos: Vector2i = Vector2i(
		round(_player.position.x / CHUNK_SIZE),
		round(_player.position.y / CHUNK_SIZE)
	)
	
	if(chunk_pos == current_chunk): return
	
	last_chunk = current_chunk
	current_chunk = chunk_pos
	
	render_chunks()

func render_chunks():
	var newGrid: Dictionary[Vector2i, Node2D] = {}
	var offset = current_chunk - last_chunk
	
	for pos in CHUNKS_POS:
		# Check if we can reuse other chunk
		var possibleMatch = Vector2i(pos + offset)
		if chunks_grid.has(possibleMatch):
			newGrid[pos] = chunks_grid[possibleMatch]
	
	var unused_chunks: Array[Node2D] = get_unused_chunks(newGrid)
	
	for pos in CHUNKS_POS:
		var absolute_pos = pos + current_chunk
		if newGrid.has(pos): continue
		var chunk = unused_chunks.pop_back()
		chunk.global_position = absolute_pos * CHUNK_SIZE
		newGrid[pos] = chunk
	
	chunks_grid = newGrid

func _create_chunk() -> Node2D:
	var chunk = CHUNK_SCENE.instantiate()
	add_child(chunk)
	return chunk

func get_unused_chunks(new_grid: Dictionary) -> Array[Node2D]:
	var unused_chunks: Array[Node2D] = []
	
	for pos in CHUNKS_POS:
		var chunk = chunks_grid[pos]
		if !new_grid.values().has(chunk):
			unused_chunks.append(chunk)
	
	return unused_chunks

func get_player_quadrant() -> Vector2i:
	var player_pos = _player.position / CHUNK_SIZE
	
	if player_pos.x < current_chunk.x:
		if player_pos.y < current_chunk.y:
			#return "ARRIBA_IZQ"
			return Vector2i(-1, -1)
		else:
			#return "ABAJO_IZQ"
			return Vector2i(-1, 1)
	else:
		if player_pos.y < current_chunk.y:
			#return "ARRIBA_DER"
			return Vector2i(1, -1)
		else:
			#return "ABAJO_DER"
			return Vector2i(1, 1)
