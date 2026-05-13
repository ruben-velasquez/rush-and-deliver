extends CharacterBody2D
class_name PlayerController

var _PackagesManager: PackagesManager

const ACCELERATION = 400.0
const MAX_SPEED = 200.0
const FRICTION = 600.0
const ROTATION_SPEED = 3.0

var velocity_multiplier: float = 1.0

signal on_crash

var last_crash = -CRASH_COOLDOWN_MS
const CRASH_COOLDOWN_MS = 2000

var move = true
var _speed := 0.0

@export var camera2D: Camera2D

func _ready() -> void:
	_PackagesManager = GameManager.packages_manager
	GameManager.player = self
	GameManager.on_timer_end.connect(func (): move = false)

func _physics_process(delta: float) -> void:
	var forward_input := Input.get_axis("down", "up") # W/S o flechas
	var turn_input := Input.get_axis("left", "right")
	var desired_velocity: Vector2
	
	if move != true:
		forward_input = 0
		turn_input = 0

	# --- Aceleración ---
	if forward_input != 0:
		_speed += forward_input * ACCELERATION * delta
	else:
		# --- Fricción ---
		_speed = move_toward(_speed, 0, FRICTION * delta)

	# Limitar velocidad
	_speed = clamp(_speed, -MAX_SPEED / 2, MAX_SPEED)

	# --- Rotación (solo si se está moviendo) ---
	if abs(_speed) > 10:
		rotation += turn_input * ROTATION_SPEED * (_speed / MAX_SPEED) * delta

	# --- Movimiento en dirección del auto ---
	desired_velocity = -transform.y * _speed * velocity_multiplier * RunData.stats.speed_multiplier
	
	velocity = lerp(velocity, desired_velocity, 0.2)
	
	camera2D.rotation = rotation
	camera2D.position = position
	
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
				
				if Time.get_ticks_msec() - last_crash > CRASH_COOLDOWN_MS:
					last_crash = Time.get_ticks_msec()
					on_crash.emit()
