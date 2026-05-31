extends Area2D
class_name Goal

const WAIT_TIME_SEG = 1

@export var sprite: Sprite2D

var appear_range: int = 3
var package: Package
var player_on_zone: bool = false
var player_time = 0

const CHUNK_STREET_Y_OFFSET = 176.0
const CHUNK_STREET_X_OFFSET = -88.0
const CHUNK_SECTION_X_DISTANCE = 64.0
const CHUNK_SECTION_Y_DISTANCE = 40.0

func _on_body_entered(_body: Node2D) -> void:
	player_time = 0
	player_on_zone = true

func _on_body_exited(_body: Node2D) -> void:
	player_time = 0
	player_on_zone = false

func _process(delta: float) -> void:
	if player_on_zone:
		player_time += delta
	
	if player_time >= WAIT_TIME_SEG:
		GameManager.packages_manager.deliver(package)
		queue_free()
	
	sprite.self_modulate = lerp(Color.WHITE, Color.LAWN_GREEN, player_time/WAIT_TIME_SEG)

func set_goal_zone():
	var chunk = Vector2(0, 0);
	
	# Set the chunk
	chunk.x = randi_range(-appear_range, appear_range)
	chunk.y = randi_range(-appear_range, appear_range)
	
	var section_x_offset = randi_range(0, 3) * CHUNK_SECTION_X_DISTANCE
	var section_y_offset = randi_range(0, 1) * CHUNK_SECTION_Y_DISTANCE
	
	position.x = (chunk.x * TerrainManager.CHUNK_SIZE) + CHUNK_STREET_X_OFFSET + section_x_offset
	position.y = (chunk.y * TerrainManager.CHUNK_SIZE) + CHUNK_STREET_Y_OFFSET + section_y_offset
