extends Node2D
signal calmed
const PARAKEET_STATES := preload("res://assets/bosses/parakeet_guardian_states_v3.png")
const PARAKEET_FRAME := Vector2(512,512)
var level: Node2D
var health := 3
var phase := "waiting"
var remaining := 1.2
var invulnerable := 0.0
var elapsed := 0.0
var is_parakeet := true
var home_position := Vector2.ZERO
var facing := -1.0
var attack_target := Vector2.ZERO
var landing_position := Vector2.ZERO
var defeat_clock := 0.0
var defeat_origin := Vector2.ZERO

func encounter_stage() -> int:
	return clampi(4-health,1,3)

func phase_duration(next_phase: String) -> float:
	var stage := encounter_stage()-1
	match next_phase:
		"warning": return [1.25,1.10,1.0][stage]
		"attack": return [0.45,0.55,0.65][stage]
		"tired": return [4.0,3.8,3.6][stage]
		_: return [1.4,1.15,0.95][stage]

func attack_reach() -> float:
	return [220.0,270.0,320.0][encounter_stage()-1]

func stage_message() -> String:
	return ["O Periquito agita raízes mais largas.","Último padrão: vento e raízes mais rápidos!"][encounter_stage()-2]

func _ready() -> void:
	home_position = position
	attack_target = position
	landing_position = position
	add_to_group("enemies")

func accepts_charge() -> bool:
	return not is_parakeet

func _move_parakeet(delta: float, player: CharacterBody2D) -> void:
	if not is_parakeet: return
	var target := home_position
	var speed := 110.0+encounter_stage()*25.0
	match phase:
		"waiting":
			target = Vector2(clampf(player.position.x,home_position.x-150.0,home_position.x+150.0),home_position.y-62.0+sin(elapsed*3.0)*9.0)
		"warning":
			target = Vector2(position.x,home_position.y-78.0)
			facing = signf(player.position.x-position.x) if not is_zero_approx(player.position.x-position.x) else facing
		"attack":
			target = Vector2(attack_target.x,home_position.y-6.0)
			speed = 660.0+encounter_stage()*70.0
		"tired","calm":
			# A abertura acontece onde o mergulho terminou, sem obrigar o jogador a perseguir o chefe.
			target = landing_position
			speed = 0.0
	var previous_x := position.x
	position = position.move_toward(target,speed*delta)
	if not is_zero_approx(position.x-previous_x): facing = signf(position.x-previous_x)

func _physics_process(delta: float) -> void:
	if phase=="defeating":
		_process_defeat(delta)
		return
	if level.completed or level.respawning or health == 0: return
	var player: CharacterBody2D = level.tico
	if absf(player.position.x-position.x)>650: return
	elapsed += delta
	_move_parakeet(delta,player)
	invulnerable = maxf(0,invulnerable-delta)
	remaining -= delta
	if remaining <= 0:
		match phase:
			"waiting":
				phase = "warning"
				remaining = phase_duration("warning")
				level._say("O Periquito bate as asas! Pule quando o chão brilhar.")
			"warning":
				phase = "attack"
				remaining = phase_duration("attack")
				if is_parakeet:
					attack_target = Vector2(clampf(player.position.x,home_position.x-attack_reach(),home_position.x+attack_reach()),home_position.y)
			"attack":
				phase = "tired"
				landing_position = position
				remaining = phase_duration("tired")
				level._say("Agora! O Periquito pousou cansado.")
			"tired":
				phase = "waiting"
				remaining = phase_duration("waiting")
	var offset: Vector2 = player.position-position
	if phase == "attack" and absf(offset.x)<attack_reach() and offset.y > -38 and offset.y < 20:
		player.take_damage(position)
	# A faixa acompanha a cabeça abaixada. Ela é larga o bastante para um salto
	# normal acertar a ilustração, sem exigir que os centros coincidam.
	var over_lowered_head := absf(offset.x)<98 and offset.y>-190 and offset.y<-42
	if over_lowered_head:
		var stomp: bool = player.velocity.y>0 and player.previous_position.y<=position.y-42
		var charge: bool = accepts_charge() and player.is_in_group("pipo") and player.ability=="charge"
		if phase == "tired" and (stomp or charge):
			if receive_hit():
				if stomp: player.bounce()
		elif invulnerable<=0:
			player.take_damage(position)
	queue_redraw()

func receive_hit() -> bool:
	if phase != "tired" or invulnerable>0 or health<=0: return false
	health -= 1
	# A proteção evita que o mesmo salto seja contado mais de uma vez.
	invulnerable = 2.0
	level.puff(position+Vector2(0,-90),Color("ffd877"),12)
	level.sounds.play_effect("impact")
	if health == 0:
		if is_parakeet:
			phase = "defeating"
			defeat_clock = 0.0
			defeat_origin = position
			level.tico.controls_enabled = false
			level._say("O Periquito perdeu as forças!")
		else:
			phase = "calm"
			calmed.emit()
	else:
		phase = "waiting"
		remaining = phase_duration("waiting")
		level._say(stage_message())
	queue_redraw()
	return true

func _process_defeat(delta: float) -> void:
	defeat_clock += delta
	var fall_weight := clampf(defeat_clock/0.58,0.0,1.0)
	fall_weight = ease(fall_weight,-1.6)
	rotation = -facing*fall_weight*1.22
	position = defeat_origin+Vector2(facing*fall_weight*22.0,fall_weight*18.0)
	if defeat_clock>0.58:
		modulate.a = 1.0-clampf((defeat_clock-0.58)/0.62,0.0,1.0)
	if defeat_clock>=1.2:
		phase = "vanished"
		hide()
		level.puff(defeat_origin+Vector2(0,-55),Color("a6c95d"),18)
		calmed.emit()

func reset_enemy() -> void:
	if health == 0: return
	health = 3
	elapsed = 0
	phase = "waiting"
	remaining = phase_duration("waiting")
	invulnerable = 0
	position = home_position
	attack_target = home_position
	landing_position = home_position
	defeat_clock = 0.0
	defeat_origin = home_position
	rotation = 0.0
	modulate = Color.WHITE
	show()
	facing = -1.0
	queue_redraw()

func _draw() -> void:
	if phase=="vanished": return
	if phase in ["warning","attack"]:
		var reach := int(attack_reach())
		for x in range(-reach,reach+1,40):
			draw_line(Vector2(x,0),Vector2(x+15,-30 if phase=="attack" else -3),Color("efbb58"),8)
	var frame: int = int({"waiting":0,"warning":1,"attack":2,"tired":3,"calm":3}.get(phase,0))
	var hover := 9.0 if phase in ["tired","calm"] else (-8.0 if phase=="attack" else -28.0)
	var breath := 1.0
	if phase in ["tired","calm"]:
		# Expansão suave do peito/corpo comunica respiração ofegante sem parecer tristeza.
		breath = 1.0+sin(elapsed*5.4)*0.035
	var size := Vector2(220.0*breath,220.0*breath)
	var destination := Rect2(Vector2(-size.x*.5,-size.y+hover),size)
	var source := Rect2(Vector2(frame*PARAKEET_FRAME.x,0),PARAKEET_FRAME)
	draw_set_transform(Vector2.ZERO,0.0,Vector2(facing if is_parakeet else 1.0,1.0))
	draw_texture_rect_region(PARAKEET_STATES,destination,source)
	draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)
	if phase == "tired":
		draw_arc(Vector2(0,-122),72,PI,TAU,32,Color("ffe29b"),6)
		draw_colored_polygon(PackedVector2Array([Vector2(-12,-205),Vector2(12,-205),Vector2(0,-184)]),Color("ffe29b"))
	for i in 3:
		draw_circle(Vector2(-26+i*26,-238),8,Color("f4cf73") if i<health else Color("687552"))

func _trunk(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(22)
	return style
