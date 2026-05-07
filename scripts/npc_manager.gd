extends Node2D
class_name NPCManager

enum Direction {TOP, LEFT, RIGHT, BOTTOM}

var _player: Node2D
@export var terrain_manager: TerrainManager
var npcs_count = 25
var npcs: Array[CarNPC]
var despawn_distance: float = 600

var last_direction_spawn_time = DIRECTION_SPAWN_TIME_INITIAL_VALUE

var DIRECTION_SPAWN_TIME_INITIAL_VALUE = [
	{
		"direction": Direction.TOP,
		"last_spawn": -SPAWN_COOLDOWN_MS
	},
	{
		"direction": Direction.LEFT,
		"last_spawn": -SPAWN_COOLDOWN_MS
	},
	{
		"direction": Direction.RIGHT,
		"last_spawn": -SPAWN_COOLDOWN_MS
	},
	{
		"direction": Direction.BOTTOM,
		"last_spawn": -SPAWN_COOLDOWN_MS
	}
]

const NPC_SCENE = preload("res://scenes/car_npc.tscn")
const SPAWN_OFFSET_BL = 20
const SPAWN_OFFSET_TR = -20
const SPAWN_COOLDOWN_MS = 3000
const SPAWN_CHECK_COOLDOWN = 250
const STREET_CHUNK_OFFSET = 200
const SPAWN_POS_RANDOMNESS = 0.2
const NPC_MINIMUN_LIFETIME_MS = 2000

var last_spawn_time = -SPAWN_CHECK_COOLDOWN
var current_player_chunk = Vector2i.ZERO

var aditional_chunks = [Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]

func _ready() -> void:
	_player = GameManager.player
	for i in range(npcs_count):
		_create_npc()

func spawn_random_direction():
	var available_directions = last_direction_spawn_time.filter(func(d): return Time.get_ticks_msec() - d["last_spawn"] > SPAWN_COOLDOWN_MS)
	
	if !available_directions.is_empty(): 
		var direction = available_directions.pick_random()["direction"] as Direction
		
		last_spawn_time = Time.get_ticks_msec()
		last_direction_spawn_time[direction]["last_spawn"] = Time.get_ticks_msec()
		
		_spawn_npc(direction)
	else:
		var _direction = Direction.values().pick_random()
			
		if aditional_chunks.is_empty():
			aditional_chunks = [Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]
		var _offset = aditional_chunks.pop_back()
		
		last_spawn_time = Time.get_ticks_msec()
		
		_spawn_npc(_direction, _offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_player_chunk != player_street_chunk():
		last_spawn_time -= SPAWN_CHECK_COOLDOWN
		last_direction_spawn_time = DIRECTION_SPAWN_TIME_INITIAL_VALUE
	
	if Time.get_ticks_msec() - last_spawn_time > SPAWN_CHECK_COOLDOWN:
		spawn_random_direction()

func _create_npc() -> CarNPC:
	var _npc = NPC_SCENE.instantiate() as CarNPC
	_npc.parent = self
	_npc.deactive()
	add_child(_npc)
	npcs.append(_npc)
	return _npc

func _spawn_npc(direction: Direction, chunk_offset = Vector2i.ZERO):
	if npcs.is_empty(): return
	
	current_player_chunk = player_street_chunk()
	
	var _npc = npcs.pop_back()
	var _target_chunk: Vector2i
	var _offset: Vector2
	var _randomness_offset = randf_range(-SPAWN_POS_RANDOMNESS, SPAWN_POS_RANDOMNESS)
	
	match direction:
		Direction.TOP:
			_offset = Vector2(SPAWN_OFFSET_TR, _randomness_offset)
			_npc.global_rotation_degrees = 180
			_target_chunk = Vector2i(0, -2) + current_player_chunk + chunk_offset
		Direction.LEFT:
			_offset = Vector2(_randomness_offset, SPAWN_OFFSET_BL)
			_npc.global_rotation_degrees = 90
			_target_chunk = Vector2i(-2, 0) + current_player_chunk +  chunk_offset
		Direction.RIGHT:
			_offset = Vector2(_randomness_offset, SPAWN_OFFSET_TR)
			_npc.global_rotation_degrees = -90
			_target_chunk = Vector2i(2, 0) + current_player_chunk + chunk_offset
		Direction.BOTTOM:
			_offset = Vector2(SPAWN_OFFSET_BL, _randomness_offset)
			_npc.global_rotation_degrees = 0
			_target_chunk = Vector2i(0, 2) + current_player_chunk + chunk_offset

	_npc.velocity = Vector2.ZERO
	_npc.spawned_time_ms = Time.get_ticks_msec()
	_npc.global_position = (Vector2(_target_chunk) * terrain_manager.CHUNK_SIZE) + (Vector2.ONE * STREET_CHUNK_OFFSET) +_offset
	_npc.activate()
	
func return_entity(npc: CarNPC):
	npc.deactive()
	npcs.append(npc)

func player_street_chunk() -> Vector2i:
	var coords = (_player.position - (Vector2.ONE * STREET_CHUNK_OFFSET)) / terrain_manager.CHUNK_SIZE
	coords = round(coords)
	return coords
