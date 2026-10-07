extends "res://scripts/characters/tico.gd"
## Pipo compartilha vida/salto básico, mas tem corpo maior e nenhuma planagem.
signal ability_changed(phase: String)
@export var prepare_duration: float = 0.22
@export var charge_speed: float = 580.0
@export var charge_duration: float = 0.42
@export var recovery_duration: float = 0.30
var ability: String = "ready"
var ability_left: float = 0.0
var charge_direction: float = 1.0
var sniffing: bool = false
var pushing: bool = false
var _push_speed: float = 0.0
const CARRY_MOVE_SPEED := 150.0
const KNOCKBACK_MULTIPLIER := 0.45
const WIND_MULTIPLIER := 0.30
const CURRENT_MULTIPLIER := 0.25

func _ready() -> void:
	tail_enabled = false
	jump_velocity = BALANCE.PIPO_JUMP_VELOCITY
	super._ready()

func action_ready() -> bool:
	return ability=="ready" and not is_carrying()

func _physics_process(delta: float) -> void:
	if not controls_enabled:
		cancel_ability()
		super._physics_process(delta)
		return
	if ability == "ready" and is_on_floor() and Input.is_action_just_pressed("action") and _hurt_left <= 0:
		if level_has_carry_interaction(): return
		charge_direction = facing
		_set_ability("prepare", prepare_duration)
	if ability != "ready":
		_tick_status(delta)
		ability_left -= delta
		velocity.x = charge_direction * charge_speed if ability == "charge" else 0.0
		velocity.y = minf(velocity.y + 1200.0 * delta, max_fall_speed)
		move_and_slide()
		if ability == "charge":
			for i in get_slide_collision_count():
				var hit := get_slide_collision(i)
				if absf(hit.get_normal().x) > 0.5:
					var object = hit.get_collider()
					if object.has_method("receive_charge"):
						object.receive_charge(self)
					_set_ability("recover", recovery_duration)
					break
		if ability_left <= 0:
			if ability == "prepare":
				_set_ability("charge", charge_duration)
			elif ability == "charge":
				_set_ability("recover", recovery_duration)
			else:
				_set_ability("ready", 0)
		_update_animation()
		return
	# Manter o contato sem reacelerar do zero a cada colisão com a pedra.
	move_speed = CARRY_MOVE_SPEED if is_carrying() else 220.0
	jump_velocity = 0.0 if is_carrying() else BALANCE.PIPO_JUMP_VELOCITY
	if pushing and is_on_floor() and _hurt_left <= 0:
		velocity.x = Input.get_axis("move_left", "move_right") * _push_speed
	pushing = false
	super._physics_process(delta)
	if is_on_floor() and _hurt_left <= 0:
		var direction := Input.get_axis("move_left", "move_right")
		for i in get_slide_collision_count():
			var hit := get_slide_collision(i)
			var object = hit.get_collider()
			if absf(hit.get_normal().x) > 0.5 and direction * hit.get_normal().x < 0 and object.has_method("push_by"):
				pushing = object.push_by(self, direction, delta)
				_push_speed = object.push_speed
	_update_animation()

func level_has_carry_interaction() -> bool:
	var parent_level := get_parent()
	return parent_level.has_method("try_pipo_carry") and parent_level.try_pipo_carry(self)

func is_carrying() -> bool:
	var parent_level := get_parent() if is_inside_tree() else null
	return is_instance_valid(parent_level) and parent_level.has_method("pipo_is_carrying") and parent_level.pipo_is_carrying()

func _set_ability(phase: String, duration: float) -> void:
	ability = phase
	ability_left = duration
	if phase == "prepare":
		_buffer_left = 0
		_coyote_left = 0
	if phase != "charge":
		velocity.x = 0
	ability_changed.emit(phase)

func cancel_ability() -> void:
	ability = "ready"
	ability_left = 0
	if is_node_ready():
		sprite.rotation = 0
		sprite.scale = Vector2.ONE

func _update_animation() -> void:
	super._update_animation()
	sprite.rotation = 0
	sprite.scale = Vector2.ONE
	if ability != "ready":
		state = StringName(ability)
		sprite.play("idle")
		sprite.rotation = 0.12 * facing if ability == "charge" else -0.08 * facing
		sprite.scale = Vector2(1.1,0.9) if ability == "prepare" else Vector2.ONE
	elif pushing:
		state = &"push"
		sprite.play("run")
		sprite.rotation = facing * 0.08
	elif is_carrying():
		state = &"carry"
		sprite.play("idle")
	elif sniffing and is_on_floor() and absf(velocity.x) < 10:
		state = &"sniff"
		sprite.play("idle")
		sprite.rotation = sin(Time.get_ticks_msec() * 0.009) * 0.06

func take_damage(source: Vector2) -> bool:
	var applied := super.take_damage(source)
	if applied:
		cancel_ability()
		var parent_level := get_parent()
		if parent_level.has_method("drop_carried_object"): parent_level.drop_carried_object()
	return applied

func environmental_force_multiplier(kind: StringName) -> float:
	if kind==&"wind": return WIND_MULTIPLIER
	if kind==&"current": return CURRENT_MULTIPLIER
	return 1.0

func knockback_multiplier() -> float:
	return KNOCKBACK_MULTIPLIER

func reset_at(point: Vector2) -> void:
	cancel_ability()
	sniffing = false
	pushing = false
	super.reset_at(point)
