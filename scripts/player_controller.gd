extends CharacterBody2D
class_name PlayerController

var _PackagesManager: PackagesManager

const ACCELERATION = 400.0
const MAX_SPEED = 200.0
const FRICTION = 600.0
const ROTATION_SPEED = 3.0

var velocity_multiplier: float = 1.0

var move = true
var speed := 0.0

@export var camera2D: Camera2D

func _ready() -> void:
	_PackagesManager = GameManager.packages_manager
	GameManager.player = self
	GameManager.on_timer_end.connect(func (): move = false)

func _physics_process(delta: float) -> void:
	var forward_input := Input.get_axis("down", "up") # W/S o flechas
	var turn_input := Input.get_axis("left", "right")

	if move != true:
		forward_input = 0
		turn_input = 0

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
	velocity = -transform.y * speed * velocity_multiplier
	
	camera2D.rotation = rotation
	camera2D.position = position
	
	move_and_slide()
