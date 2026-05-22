extends Node2D

@export var controller: PlayerController
@export var smoke_particles: GPUParticles2D
@export var fire_particles: GPUParticles2D
@export var explosion_vfx: GPUParticles2D
@export var player_exploded_sprite: Texture2D
@export var player_sprite: Sprite2D

func _ready() -> void:
	if RunData.player_health < RunData.stats.max_player_health/2.:
		smoke_particles.emitting = true
		
	controller.on_crash.connect(on_player_crash)

func on_player_crash():
	RunData.player_health -= 1
	if RunData.player_health < RunData.stats.max_player_health/2.:
		if RunData.player_health < 0:
			die()
		else:
			smoke_particles.emitting = true

func die():
	GameManager.current_timer.stop()
	
	fire_particles.emitting = true
	smoke_particles.emitting = false
	controller.move = false
	
	await get_tree().create_timer(2.0).timeout
	
	fire_particles.emitting = false
	explosion_vfx.emitting = true
	player_sprite.texture = player_exploded_sprite
	
	await get_tree().create_timer(1.0).timeout
	
	GameManager.player_died()
