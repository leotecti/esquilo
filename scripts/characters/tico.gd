extends CharacterBody2D
## Controlador de Tico. Valores iniciais ajustáveis no Inspector para playtest.

signal landed

@export_group("Movimento")
@export var move_speed: float = 300.0
@export var acceleration: float = 2200.0
@export var deceleration: float = 2600.0
@export var air_acceleration: float = 1400.0
@export_group("Salto")
@export var jump_velocity: float = -560.0
@export_range(0.1, 1.0) var jump_cut: float = 0.48
@export var fall_gravity_multiplier: float = 1.35
@export var max_fall_speed: float = 900.0
@export var coyote_duration: float = 0.10
@export var jump_buffer_duration: float = 0.12
@export_group("Planar")
@export var glide_duration: float = 2.0
@export var glide_fall_speed: float = 100.0
@export var glide_gravity_multiplier: float = 0.18

var facing: float = 1.0
var state: StringName = &"idle"
var glide_remaining: float = 0.0
var _coyote_left: float = 0.0
var _buffer_left: float = 0.0
var _landing_left: float = 0.0
var _jump_cut_applied: bool = false
var _gliding: bool = false
var _reset_pending: bool = false

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	glide_remaining = glide_duration


func _physics_process(delta: float) -> void:
	# A informação de contato da física anterior não vale após reposicionar.
	var grounded := is_on_floor() and not _reset_pending
	_reset_pending = false
	_coyote_left = coyote_duration if grounded else maxf(0.0, _coyote_left - delta)
	_buffer_left = maxf(0.0, _buffer_left - delta)
	_landing_left = maxf(0.0, _landing_left - delta)
	if grounded:
		glide_remaining = glide_duration
		_jump_cut_applied = false
	if Input.is_action_just_pressed("jump"):
		_buffer_left = jump_buffer_duration

	var direction := Input.get_axis("move_left", "move_right")
	var rate := acceleration if grounded else air_acceleration
	if is_zero_approx(direction):
		rate = deceleration if grounded else air_acceleration
	velocity.x = move_toward(velocity.x, direction * move_speed, rate * delta)
	if not is_zero_approx(direction):
		facing = signf(direction)

	var jumped := false
	if _buffer_left > 0.0 and _coyote_left > 0.0:
		velocity.y = jump_velocity
		_coyote_left = 0.0
		_buffer_left = 0.0
		_landing_left = 0.0
		_jump_cut_applied = false
		jumped = true

	# Soltar cedo reduz a subida uma única vez. Buffer já solto gera salto curto.
	if velocity.y < 0.0 and not Input.is_action_pressed("jump") and not _jump_cut_applied:
		velocity.y *= jump_cut
		_jump_cut_applied = true

	_gliding = (not grounded and velocity.y > 0.0
		and Input.is_action_pressed("jump") and glide_remaining > 0.0)
	if not grounded or jumped:
		var gravity_multiplier := 1.0
		if _gliding:
			gravity_multiplier = glide_gravity_multiplier
			glide_remaining = maxf(0.0, glide_remaining - delta)
		elif velocity.y > 0.0:
			gravity_multiplier = fall_gravity_multiplier
		velocity.y += get_gravity().y * gravity_multiplier * delta
		velocity.y = minf(velocity.y, glide_fall_speed if _gliding else max_fall_speed)
	move_and_slide()

	if is_on_floor() and not grounded:
		_landing_left = 0.10
		glide_remaining = glide_duration
		_gliding = false
		landed.emit()
	_update_animation()


func _update_animation() -> void:
	if is_on_floor():
		if _landing_left > 0.0:
			state = &"land"
		else:
			state = &"run" if absf(velocity.x) > 10.0 else &"idle"
	elif _gliding:
		state = &"glide"
	else:
		state = &"jump" if velocity.y < 0.0 else &"fall"
	sprite.flip_h = facing < 0.0
	sprite.speed_scale = clampf(absf(velocity.x) / move_speed, 0.45, 1.25) if state == &"run" else 1.0
	sprite.play(state)


func reset_at(point: Vector2) -> void:
	global_position = point
	velocity = Vector2.ZERO
	facing = 1.0
	_coyote_left = 0.0
	_buffer_left = 0.0
	_landing_left = 0.0
	_gliding = false
	_jump_cut_applied = false
	_reset_pending = true
	glide_remaining = glide_duration
	state = &"idle"
	if is_node_ready():
		sprite.flip_h = false
		sprite.play(state)
