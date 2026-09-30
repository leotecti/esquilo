extends CharacterBody2D
## Controlador de Tico. Valores iniciais ajustáveis no Inspector para playtest.

signal landed
signal health_changed(current: int)
signal hurt
signal defeated

@export_group("Vida")
@export var max_health: int = 3
@export var invulnerability_duration: float = 1.5
var health: int = 3
var invulnerability_left: float = 0.0
var controls_enabled: bool = true
var previous_position: Vector2
var _hurt_left: float = 0.0

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
var wind_acceleration := Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	health = max_health
	glide_remaining = glide_duration


func _physics_process(delta: float) -> void:
	_tick_status(delta)
	_move_character(delta)


func _tick_status(delta: float) -> void:
	previous_position = global_position
	invulnerability_left = maxf(0.0, invulnerability_left - delta)
	_hurt_left = maxf(0.0, _hurt_left - delta)
	sprite.modulate.a = 0.45 if invulnerability_left > 0.0 and fmod(invulnerability_left, 0.16) < 0.08 else 1.0


func _move_character(delta: float) -> void:
	if not controls_enabled:
		velocity = Vector2.ZERO
		return
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
	if _hurt_left <= 0.0:
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
	var rising: bool = velocity.y < 0.0
	if not grounded:
		velocity += wind_acceleration * delta
	move_and_slide()
	if rising:
		for index in get_slide_collision_count():
			var collision := get_slide_collision(index)
			var collider = collision.get_collider()
			if collision.get_normal().y > 0.5 and collider.has_method("hit_from_below"):
				collider.hit_from_below()

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
	wind_acceleration = Vector2.ZERO
	global_position = point
	force_update_transform()
	previous_position = point
	controls_enabled = true
	_hurt_left = 0.0
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


func take_damage(source: Vector2) -> bool:
	if health <= 0 or invulnerability_left > 0.0 or not controls_enabled:
		return false
	health -= 1
	invulnerability_left = invulnerability_duration
	_hurt_left = 0.2
	velocity = Vector2(-240.0 if source.x >= global_position.x else 240.0, -240.0)
	_jump_cut_applied = true
	health_changed.emit(health)
	hurt.emit()
	if health == 0:
		controls_enabled = false
		defeated.emit()
	return true


func recover(amount: int = 1) -> bool:
	if amount <= 0 or health <= 0 or health >= max_health or not controls_enabled:
		return false
	health = mini(max_health, health + amount)
	health_changed.emit(health)
	return true


func restore_health() -> void:
	health = max_health
	health_changed.emit(health)


func bounce() -> void:
	velocity.y = -360.0
	_jump_cut_applied = true
	_coyote_left = 0.0
	_buffer_left = 0.0
	_reset_pending = true
