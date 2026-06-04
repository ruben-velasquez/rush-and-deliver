class_name TrafficDirector
extends Area2D

enum TrafficDirection {
	HORIZONTAL,
	VERTICAL
}

var current_direction: TrafficDirection = TrafficDirection.HORIZONTAL

var npc_directions: Array[TrafficDirection]

var npc_list: Array[CarNPC]

var last_swap: int = 0

const DIRECTION_DURATION_MS := 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - last_swap > DIRECTION_DURATION_MS:
		_swap_direction()
		update_traffic()
	elif Time.get_ticks_msec() - last_swap > DIRECTION_DURATION_MS/2.0:
		update_traffic()

func on_body_entered(body: Node2D):
	if body is CarNPC:
		(body as CarNPC).free_traffic = false
		npc_list.append(body as CarNPC)

func on_body_exited(body: Node2D):
	if body is CarNPC:
		npc_list.erase(body as CarNPC)
		(body as CarNPC).free_traffic = true

func update_traffic():
	if len(npc_list) > 0:
		for npc in npc_list:
			if npc.free_traffic:
				continue
				
			if abs(npc.global_rotation_degrees) == 90:
				npc.free_traffic = current_direction == TrafficDirection.HORIZONTAL
			else:
				npc.free_traffic = current_direction == TrafficDirection.VERTICAL

func _swap_direction():
	last_swap = Time.get_ticks_msec()
	current_direction = get_opposed_direction(current_direction)
	
func get_opposed_direction(dir: TrafficDirection) -> TrafficDirection:
	return abs(dir - 1)
