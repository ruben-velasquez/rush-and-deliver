extends Node2D

var _player: Node2D
var current_chunk: Vector2i

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
	var raw: Vector2 = _player.position / CHUNK_SIZE
	var chunk_pos: Vector2i = Vector2i(
		round(_player.position.x / CHUNK_SIZE),
		round(_player.position.y / CHUNK_SIZE)
	)
	
	if(chunk_pos == current_chunk): return
	
	current_chunk = chunk_pos
	
	render_chunks()

func render_chunks():
	for pos in CHUNKS_POS:
		var absolute_pos = pos + current_chunk
		var chunk = chunks_grid[pos]
		chunk.global_position = absolute_pos * CHUNK_SIZE
		chunks_grid[pos] = chunk

func _create_chunk() -> Node2D:
	var chunk = CHUNK_SCENE.instantiate()
	add_child(chunk)
	return chunk
