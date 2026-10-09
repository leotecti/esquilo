extends CharacterBody2D
const BALANCE = preload("res://scripts/systems/game_balance.gd")
## Controlador de Tico. Valores iniciais ajustáveis no Inspector para playtest.

signal landed
signal health_changed(current: int)
signal hurt
signal defeated
signal tail_attack_started
signal tail_window(attack_id: int)
signal auto_run_finished

@export_group("Vida")
@export var max_health: int = BALANCE.PLAYER_MAX_HEALTH
@export var invulnerability_duration: float = BALANCE.DAMAGE_INVULNERABILITY
var health: int = BALANCE.PLAYER_MAX_HEALTH
var invulnerability_left: float = 0.0
var controls_enabled: bool = true
var previous_position: Vector2
var _hurt_left: float = 0.0

@export_group("Movimento")
@export var move_speed: float = BALANCE.TICO_MOVE_SPEED
@export var acceleration: float = 2200.0
@export var deceleration: float = 2600.0
@export var air_acceleration: float = 1400.0
## Aderência horizontal do piso. Valores menores preservam o embalo em
## superfícies molhadas ou congeladas sem alterar o controle no ar.
@export_range(0.1, 1.0) var surface_grip: float = 1.0
@export_group("Salto")
@export var jump_velocity: float = BALANCE.TICO_JUMP_VELOCITY
@export_range(0.1, 1.0) var jump_cut: float = 0.48
@export var fall_gravity_multiplier: float = 1.35
@export var max_fall_speed: float = 900.0
@export var coyote_duration: float = 0.10
@export var jump_buffer_duration: float = 0.12
@export_group("Planar")
@export var glide_duration: float = BALANCE.GLIDE_DURATION
@export var glide_fall_speed: float = 100.0
@export var glide_gravity_multiplier: float = 0.18
@export_group("Caudada")
@export var tail_enabled: bool = true
@export var tail_prepare_duration: float = 0.10
@export var tail_active_duration: float = 0.14
@export var tail_recovery_duration: float = 0.28

var facing: float = 1.0
var state: StringName = &"idle"
var glide_remaining: float = 0.0
var _coyote_left: float = 0.0
var _buffer_left: float = 0.0
var _landing_left: float = 0.0
var _jump_cut_applied: bool = false
var _gliding: bool = false
var _reset_pending: bool = false
var auto_run_target := INF
var wind_acceleration := Vector2.ZERO
var current_acceleration := Vector2.ZERO
var tail_phase := "ready"
var tail_phase_left := 0.0
var tail_attack_id := 0
var _drop_platform: CollisionObject2D

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	health = max_health
	glide_remaining = glide_duration


func _physics_process(delta: float) -> void:
	if is_finite(auto_run_target):
		_process_auto_run(delta)
		return
	if tail_enabled and tail_phase=="ready" and controls_enabled and is_on_floor() and not _reset_pending and _hurt_left<=0.0 and Input.is_action_just_pressed("action"):
		_start_tail_attack()
	if tail_phase!="ready":
		_process_tail_attack(delta)
		return
	_tick_status(delta)
	_move_character(delta)

func _start_tail_attack() -> void:
	tail_attack_id += 1
	tail_phase = "prepare"
	tail_phase_left = tail_prepare_duration
	velocity.x = 0
	_buffer_left = 0
	_coyote_left = 0
	tail_attack_started.emit()

func _process_tail_attack(delta: float) -> void:
	_tick_status(delta)
	tail_phase_left -= delta
	velocity.x = 0
	velocity.y = minf(velocity.y+get_gravity().y*delta,max_fall_speed)
	move_and_slide()
	# O acerto acompanha a metade frontal do giro, quando a cauda cruza o alvo.
	if tail_phase=="active" and 1.0-tail_phase_left/tail_active_duration>=0.50:
		tail_window.emit(tail_attack_id)
	if tail_phase_left<=0:
		if tail_phase=="prepare":
			tail_phase = "active"
			tail_phase_left = tail_active_duration
		elif tail_phase=="active":
			tail_phase = "recover"
			tail_phase_left = tail_recovery_duration
		else: cancel_tail_attack()
	_update_animation()

func start_auto_run(target_x: float) -> void:
	cancel_tail_attack()
	controls_enabled = false
	auto_run_target = target_x
	invulnerability_left = maxf(invulnerability_left,5.0)

func _process_auto_run(delta: float) -> void:
	previous_position = global_position
	var distance := auto_run_target-global_position.x
	if absf(distance)<=12.0:
		global_position.x = auto_run_target
		velocity = Vector2.ZERO
		auto_run_target = INF
		state = &"idle"
		sprite.play(state)
		auto_run_finished.emit()
		return
	facing = signf(distance)
	velocity.x = facing*move_speed
	velocity.y = minf(velocity.y+get_gravity().y*delta,max_fall_speed)
	move_and_slide()
	state = &"run"
	sprite.flip_h = facing<0
	sprite.speed_scale = 1.0
	sprite.play(state)

func cancel_tail_attack() -> void:
	tail_phase = "ready"
	tail_phase_left = 0

func action_ready() -> bool:
	return tail_phase=="ready"


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
	if grounded and Input.is_action_just_pressed("move_down"):
		grounded = not _begin_platform_drop()
	if Input.is_action_just_pressed("jump"):
		_buffer_left = jump_buffer_duration

	var direction := Input.get_axis("move_left", "move_right")
	var rate := acceleration if grounded else air_acceleration
	if is_zero_approx(direction):
		rate = deceleration if grounded else air_acceleration
	if grounded:
		rate *= surface_grip
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

	# A corrente de ar pode elevar Tico sem interromper a planagem já iniciada.
	_gliding = (not grounded and (velocity.y > 0.0 or _gliding)
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
	# Rajadas horizontais também atuam no chão; correntes de sustentação continuam
	# sendo preenchidas pelo nível apenas durante a planagem.
	velocity += wind_acceleration * environmental_force_multiplier(&"wind") * delta
	# Correntezas rasas deslocam também no chão. A aceleração entra depois do
	# controle horizontal para tornar a estabilidade de cada personagem visível.
	velocity += current_acceleration * environmental_force_multiplier(&"current") * delta
	move_and_slide()
	_update_platform_drop()
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

func _begin_platform_drop() -> bool:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collider = collision.get_collider()
		if collision.get_normal().y < -0.5 and collider is CollisionObject2D and collider.get_meta("drop_through",false):
			_drop_platform = collider
			add_collision_exception_with(_drop_platform)
			global_position.y += 5.0
			velocity.y = 190.0
			_coyote_left = 0.0
			_buffer_left = 0.0
			return true
	return false

func _update_platform_drop() -> void:
	if not is_instance_valid(_drop_platform):
		_drop_platform = null
		return
	var release_y := float(_drop_platform.get_meta("drop_release_y",_drop_platform.global_position.y+50.0))
	if global_position.y >= release_y:
		remove_collision_exception_with(_drop_platform)
		_drop_platform = null


func _update_animation() -> void:
	if tail_phase!="ready":
		state = StringName("tail_"+tail_phase)
		sprite.flip_h = facing<0
		return
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
	if is_instance_valid(_drop_platform): remove_collision_exception_with(_drop_platform)
	_drop_platform = null
	cancel_tail_attack()
	auto_run_target = INF
	wind_acceleration = Vector2.ZERO
	current_acceleration = Vector2.ZERO
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


func environmental_force_multiplier(_kind: StringName) -> float:
	return 1.0

func knockback_multiplier() -> float:
	return 1.0

func take_damage(source: Vector2) -> bool:
	if health <= 0 or invulnerability_left > 0.0 or not controls_enabled:
		return false
	health -= 1
	cancel_tail_attack()
	_gliding = false
	invulnerability_left = invulnerability_duration
	_hurt_left = 0.2
	var knockback := 240.0 * knockback_multiplier()
	velocity = Vector2(-knockback if source.x >= global_position.x else knockback, -knockback)
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
	_gliding = false
	velocity.y = -360.0
	_jump_cut_applied = true
	_coyote_left = 0.0
	_buffer_left = 0.0
	_reset_pending = true
