extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const CHROMA = preload("res://scripts/presentation/chroma_key.gdshader")
const TAIL_SPIN = preload("res://assets/slice/tico_tail_spin.png")
const TAIL_SPIN_FRAME_COUNT := 6
# Cada pose ocupa uma célula de 512 px com margem transparente lateral. Isso
# preserva o tamanho de Tico e impede fragmentos dos quadros vizinhos.
const TAIL_SPIN_CROP_Y := 0.0
const TAIL_SPIN_CROP_HEIGHT := 335.0
const TICO_VISUAL_HEIGHT := 76.0
# A arte acompanha o corpo físico já aprovado: Pipo tem 72 px de colisão contra
# 56 px de Tico. O porte agora fica evidente sem ampliar colisões ou bloquear rotas.
const PIPO_VISUAL_HEIGHT := 98.0
const PIPO_CHARGE_HEIGHT := 69.0
const PIPO_PREPARE_HEIGHT := 78.0
const PIPO_PUSH_HEIGHT := 86.0
var character: CharacterBody2D
var level: Node2D
var pig := false
var pose := "idle"
var _time := 0.0
var _step_time := 0.0
var _previous_grounded := true
var _previous_vy := 0.0
var push_frame := 0
var _push_time := 0.0
var _push_distance := 0.0
var _last_position := Vector2.ZERO
var run_frame := 0
var _run_distance := 0.0
var _tail_frames: Array[Texture2D] = []
var tail_spin_frame := 0

func _ready() -> void:
	character = get_parent()
	character.sprite.hide()
	pig = character.is_in_group("pipo")
	material = ShaderMaterial.new()
	material.shader = CHROMA
	_last_position = character.global_position
	for index in TAIL_SPIN_FRAME_COUNT:
		var frame := AtlasTexture.new()
		frame.atlas = TAIL_SPIN
		var frame_width := TAIL_SPIN.get_width()/float(TAIL_SPIN_FRAME_COUNT)
		frame.region = Rect2(frame_width*index,TAIL_SPIN_CROP_Y,frame_width,TAIL_SPIN_CROP_HEIGHT)
		_tail_frames.append(frame)

func _process(delta: float) -> void:
	if not character.visible:
		pose = "idle"
		_last_position = character.global_position
		return
	_time += delta
	var previous_pose := pose
	pose = str(character.state)
	if _pressing_stone():
		pose = "push" if pig and character.pushing else "push_attempt"
	if level.completed: pose = "celebrate"
	elif character._hurt_left > 0 or level.respawning: pose = "hurt"
	if pose in ["push", "push_attempt"]:
		if previous_pose != pose:
			_push_time = 0
			_push_distance = 0
		else:
			_push_time += delta
			_push_distance += character.global_position.distance_to(_last_position)
		# Pipo alterna os pés conforme avança, sem caminhar parado no limite da pedra.
		push_frame = int(_push_distance / 12.0) % 4 if pose == "push" else (0 if pig else int(_push_time * 5) % 4)
	else:
		push_frame = 0
	if pose in ["run","carry"]:
		if previous_pose != pose: _run_distance = 0
		else:
			# Distância relativa ao apoio: um elevador não deve fazer os pés correrem.
			_run_distance += absf(character.velocity.x) * delta
		run_frame = int(_run_distance / (20.0 if pig else 18.0)) % 4
	else:
		run_frame = 0
	_last_position = character.global_position
	if character.controls_enabled and not level.respawning and not level.completed:
		if character.velocity.y < -300 and _previous_vy >= -50 and not character.is_on_floor():
			level.sounds.play_effect("jump")
		if character.is_on_floor() and not _previous_grounded:
			level.sounds.play_effect("land")
		if character.is_on_floor() and (absf(character.velocity.x) > 30 or pose == "push"):
			_step_time += delta
			if _step_time > (0.36 if pig else 0.26):
				_step_time = 0
				level.sounds.play_effect("step")
				level.puff(character.position,Color("e2d2a5"),3)
	_previous_grounded = character.is_on_floor()
	_previous_vy = character.velocity.y
	modulate.a = character.sprite.modulate.a
	queue_redraw()

func _pressing_stone() -> bool:
	if not character.controls_enabled or not character.is_on_floor():
		return false
	if pig and character.ability != "ready":
		return false
	var direction := Input.get_axis("move_left", "move_right")
	if is_zero_approx(direction):
		return false
	for i in character.get_slide_collision_count():
		var hit := character.get_slide_collision(i)
		var object = hit.get_collider()
		if absf(hit.get_normal().x) > 0.5 and direction * hit.get_normal().x < 0:
			if object.has_method("push_by") or object.has_method("receive_charge"):
				return true
	return false

func _draw() -> void:
	if not is_instance_valid(character): return
	var maps := {"idle":0,"jump":3,"fall":4,"land":0,
		"glide":5,"hurt":6,"celebrate":7}
	if pig:
		maps.merge({"push":5,"carry":5,"charge":6,"sniff":7,"hurt":8,"celebrate":9,"prepare":10,"recover":11},true)
	var texture := ATLAS.frame("pipo" if pig else "tico",maps.get(pose,0))
	if not pig and pose.begins_with("tail_"):
		tail_spin_frame = 0
		if pose=="tail_active":
			var progress: float = 1.0-character.tail_phase_left/character.tail_active_duration
			tail_spin_frame = clampi(1+int(progress*4.0),1,4)
		elif pose=="tail_recover":
			var recovery: float = 1.0-character.tail_phase_left/character.tail_recovery_duration
			tail_spin_frame = 4 if recovery<0.35 else 5
		texture = _tail_frames[tail_spin_frame]
	if pose == "run" or (pose=="carry" and absf(character.velocity.x)>20):
		texture = ATLAS.frame("run",(4 if pig else 0)+run_frame)
	if pose in ["push", "push_attempt"]:
		texture = ATLAS.frame("push",(4 if pig else 0)+push_frame)
	var height := PIPO_VISUAL_HEIGHT if pig else TICO_VISUAL_HEIGHT
	# Compensa a cauda erguida do recorte sem encolher o corpo ao abrir a planagem.
	if pose == "glide": height = 82
	if pose == "charge": height = PIPO_CHARGE_HEIGHT
	if pose == "prepare": height = PIPO_PREPARE_HEIGHT
	if pose in ["push", "push_attempt", "carry"]: height = PIPO_PUSH_HEIGHT if pig else 72
	if pose.begins_with("tail_"): height = 82
	var size := texture.get_size() * (height / texture.get_height())
	var bob := sin(_time*3)*1.0
	var angle := 0.0
	if pose == "glide":
		bob = sin(_time*2.5)*0.8
		angle = sin(_time*2.5)*0.015
	if pose == "run": bob = -absf(sin(_run_distance / (20.0 if pig else 18.0) * PI/2))*2
	if pose == "push": bob = 0
	if pose == "carry":
		bob = -absf(sin(_run_distance/20.0*PI/2))*1.5 if absf(character.velocity.x)>20 else sin(_time*3.0)*0.5
		angle = sin(_time*5.0)*0.012
	if pose == "push_attempt": bob = -absf(sin(_push_time*5))*0.6
	if pose == "celebrate": bob = -absf(sin(_time*5))*7
	# O giro já possui deslocamento desenhado em cada quadro. Um segundo balanço
	# vertical fazia Tico parecer flutuar sobretudo no quadro visto de costas.
	if pose.begins_with("tail_"): bob = 0
	if pose == "sniff": angle = sin(_time*6)*0.035
	if pose == "hurt": angle = -0.12
	draw_set_transform(Vector2(0,bob),angle,Vector2(character.facing,1))
	# O rosto acompanha a colisão; a cauda fica atrás do corpo de Tico.
	var right_edge := size.x * 0.5 if pig else size.x * 0.32
	if pose in ["push", "push_attempt"]:
		# As mãos ficam junto à lateral física da pedra, também ao virar à esquerda.
		right_edge = 26.0 if pig else 18.0
	draw_texture_rect(texture,Rect2(Vector2(right_edge-size.x,-size.y),size),false)
	if pig and pose=="carry":
		# Braços sustentam a cesta acima da cabeça; sobrancelhas, boca e suor
		# comunicam peso sem exigir textura ou animação adicional.
		var skin := Color("a9d83f")
		var sleeve := Color("f2ead2")
		for side in [-1.0,1.0]:
			draw_line(Vector2(side*25,-48),Vector2(side*32,-89),Color("17613c"),13,true)
			draw_line(Vector2(side*29,-70),Vector2(side*32,-89),sleeve,10,true)
			draw_circle(Vector2(side*32,-96),8,skin)
		draw_line(Vector2(-13,-70),Vector2(-4,-66),Color("334424"),3,true)
		draw_line(Vector2(10,-66),Vector2(19,-70),Color("334424"),3,true)
		draw_arc(Vector2(4,-55),7,PI+.25,TAU-.25,12,Color("6e382e"),3,true)
		draw_colored_polygon(PackedVector2Array([Vector2(-24,-73),Vector2(-18,-86),Vector2(-13,-74)]),Color("dff4ddcc"))
