extends Node2D

@export var controller: PlayerController
@export var smoke_particles: GPUParticles2D

func _ready() -> void:
	controller.on_crash.connect(on_player_crash)

func on_player_crash():
	RunData.player_health -= 1
	if RunData.player_health < RunData.stats.max_player_health/2.:
		smoke_particles.emitting = true
