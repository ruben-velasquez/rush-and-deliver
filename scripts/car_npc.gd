extends CharacterBody2D
class_name CarNPC

@export var frontArea: Area2D

var move =  true
var free_traffic = true
var speed := 0.0
var spawned_time_ms = 0

const ACCELERATION = 400.0
const MAX_SPEED = 150.0
const FRICTION = 600.0
const ROTATION_SPEED = 3.0

var parent: NPCManager

func _ready() -> void:
	frontArea.body_entered.connect(func(_b): move = false)
	frontArea.body_exited.connect(func(_b): move = true)
	deactive()

func _physics_process(delta: float) -> void:
	var forward_input := 1 # W/S o flechas
	var turn_input := 0
	var desired_velocity: Vector2
	var weight = 0.2
	var can_move = move and free_traffic
	
	if Time.get_ticks_msec() - spawned_time_ms > parent.NPC_MINIMUN_LIFETIME_MS and GameManager.player.global_position.distance_to(global_position) > parent.despawn_distance:
		parent.return_entity(self)

	if can_move != true: 
		forward_input = 0
		if velocity.y > MAX_SPEED / 2:
			weight = 0.9

	# --- Aceleración ---
	if forward_input != 0:
		speed += forward_input * ACCELERATION * delta
	else:
		# --- Fricción ---
		speed = move_toward(speed, 0, FRICTION * delta)

	# Limitar velocidad
	speed = clamp(speed, -MAX_SPEED / 2, MAX_SPEED)

	# --- Rotación (solo si se está moviendo) ---
	if abs(speed) > 10:
		rotation += turn_input * ROTATION_SPEED * (speed / MAX_SPEED) * delta

	# --- Movimiento en dirección del auto ---
	desired_velocity = -transform.y * speed
	
	
	velocity = lerp(velocity, desired_velocity, weight)
	
	move_and_slide()
	
	# Detectar si chocamos con algo después de movernos
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is CharacterBody2D and "velocity" in collider:
			# 1. Calculamos qué tan fuerte fue el choque contra la superficie
			# Usamos el producto punto para saber cuánta velocidad iba hacia el objeto
			var impact_speed = velocity.dot(-collision.get_normal())
			
			# 2. Solo empujamos si nos movemos hacia él (evita que el NPC nos "succione")
			if impact_speed > 0:
				var push_strength = 0.3 # Ajusta (0.1 suave, 0.8 pesado)
				var push_vector = -collision.get_normal() * impact_speed * push_strength
				
				velocity /= 2
				collider.velocity += push_vector

func deactive():
	self.hide()
	set_process(false)
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

func activate():
	self.show()
	set_process(true)
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
