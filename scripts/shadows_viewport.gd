class_name ShadowsViewport
extends SubViewportContainer

@export var subviewport: SubViewport
@export var camera: Camera2D

static var instance: ShadowsViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self

func _process(_delta: float) -> void:
	global_position = camera.global_position
	global_position.x -= size.x/2
	global_position.y -= size.y/2

func append_shadow(shadow: Node2D):
	shadow.reparent.call_deferred(subviewport, true)
