extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const CHROMA = preload("res://scripts/presentation/chroma_key.gdshader")
const TAIL_SPIN = preload("res://assets/slice/tico_tail_spin.png")
const PIPO_CARRY = preload("res://assets/characters/pipo/carry_sheet.png")
const PIPO_RUN = preload("res://assets/characters/pipo/run_sheet_v2.png")
const TICO_WIND_STRUGGLE = preload("res://assets/characters/tico/wind_struggle_sheet.png")
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
# O sprite sheet de transporte tem margens grandes no topo e abaixo dos pés.
# O recorte preserva a escala aprovada e ancora todas as poses no chão.
const PIPO_CARRY_CROP_Y := 120.0
const PIPO_CARRY_CROP_HEIGHT := 665.0
const PIPO_CARRY_HEIGHT := 119.0
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
var _push_grace := 0.0
var _last_position := Vector2.ZERO
var run_frame := 0
var _run_distance := 0.0
var _tail_frames: Array[Texture2D] = []
var _carry_frames: Array[Texture2D] = []
var _pipo_run_frames: Array[Texture2D] = []
var _wind_frames: Array[Texture2D] = []
var tail_spin_frame := 0
var _wind_step_time := 0.0

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
	for index in 4:
		var frame := AtlasTexture.new()
		frame.atlas = PIPO_CARRY
		var frame_width := PIPO_CARRY.get_width()/4.0
		frame.region = Rect2(frame_width*index,PIPO_CARRY_CROP_Y,frame_width,PIPO_CARRY_CROP_HEIGHT)
		frame.filter_clip = true
		_carry_frames.append(frame)
	for index in 4:
		var frame := AtlasTexture.new()
		frame.atlas = PIPO_RUN
		var frame_width := PIPO_RUN.get_width()/4.0
		# Recorte comum mantém o chapéu e os pés na mesma escala aprovada das
		# outras poses, sem deixar a margem transparente encolher Pipo na corrida.
		frame.region = Rect2(frame_width*index,48,frame_width,278)
		frame.filter_clip = true
		_pipo_run_frames.append(frame)
	for index in 4:
		var frame := AtlasTexture.new()
		frame.atlas = TICO_WIND_STRUGGLE
		var frame_width := TICO_WIND_STRUGGLE.get_width()/4.0
		# Recorte termina junto aos pés: margem transparente inferior faria Tico flutuar.
		frame.region = Rect2(frame_width*index,105,frame_width,430)
		frame.filter_clip = true
		_wind_frames.append(frame)

func _process(delta: float) -> void:
	if not character.visible:
		pose = "idle"
		_last_position = character.global_position
		return
	_time += delta
	var previous_pose := pose
	pose = str(character.state)
	if pig and character.pushing:
		# A rocha avança alguns pixels antes de Pipo recuperar o contato. Manter a
		# pose nesse intervalo curto evita alternância entre empurrar e correr.
		_push_grace = 0.14
	else:
		_push_grace = maxf(0.0,_push_grace-delta)
	if pig and pose=="carry":
		var cargo: Node2D = level.carried_object if is_instance_valid(level.get("carried_object")) else null
		if not is_instance_valid(cargo) or (cargo.has_method("delivery_preview") and cargo.delivery_preview()):
			# A cesta pertence a uma única apresentação por vez. Na aproximação ela
			# passa para a carroça; depois da entrega, a pose antiga pode permanecer
			# no controlador pausado por um quadro, mas não volta a desenhar o cesto.
			pose = "carry_delivery"
	if pig and bool(level.get("supply_placement_active")):
		pose = "delivery_place"
	if not pig and level.has_method("tico_struggling_against_wind") and level.tico_struggling_against_wind(character):
		pose = "wind_struggle"
	var pressing_stone := _pressing_stone()
	if pressing_stone:
		pose = "push" if pig and character.pushing else "push_attempt"
	elif pig and _push_grace>0.0 and character.is_on_floor() and not is_zero_approx(Input.get_axis("move_left","move_right")):
		pose = "push"
	if level.completed: pose = "celebrate"
	elif character._hurt_left > 0 or level.respawning: pose = "hurt"
	if pose in ["push", "push_attempt"]:
		if previous_pose != pose:
			_push_time = 0
			_push_distance = 0
		else:
			_push_time += delta
			# Correções de colisão podem deslocar Pipo vários pixels em um único
			# quadro. O limite impede que duas poses sejam puladas de uma vez.
			_push_distance += minf(character.global_position.distance_to(_last_position),4.0)
		# Pipo alterna os pés conforme avança, sem caminhar parado no limite da pedra.
		push_frame = int(_push_distance / 12.0) % 4 if pose == "push" else (0 if pig else int(_push_time * 5) % 4)
	else:
		push_frame = 0
	if pose in ["run","carry","wind_struggle"]:
		if previous_pose != pose: _run_distance = 0
		else:
			# Distância relativa ao apoio: um elevador não deve fazer os pés correrem.
			_run_distance += absf(character.velocity.x) * delta
		run_frame = int(_run_distance / (20.0 if pig else 18.0)) % 4
	else:
		run_frame = 0
	if pose=="wind_struggle":
		_wind_step_time += delta
		# Passada pesada: cada pose permanece visível enquanto Tico enfrenta a rajada.
		run_frame = int(_wind_step_time*2.4)%4
	else:
		_wind_step_time = 0.0
	_last_position = character.global_position
	if character.controls_enabled and not level.respawning and not level.completed:
		if character.velocity.y < -300 and _previous_vy >= -50 and not character.is_on_floor():
			level.sounds.play_effect("jump")
		if character.is_on_floor() and not _previous_grounded:
			level.sounds.play_effect("land")
		if character.is_on_floor() and (absf(character.velocity.x) > 30 or pose in ["push","wind_struggle"]):
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
	if pose in ["run","wind_struggle"]:
		texture = _pipo_run_frames[run_frame] if pig else ATLAS.frame("run",run_frame)
	if pose == "wind_struggle": texture = _wind_frames[run_frame]
	if pose == "carry": texture = _carry_frames[run_frame if absf(character.velocity.x)>20 else 0]
	if pose in ["push", "push_attempt", "delivery_place"]:
		texture = ATLAS.frame("push",(4 if pig else 0)+(0 if pose=="delivery_place" else push_frame))
	var height := PIPO_VISUAL_HEIGHT if pig else TICO_VISUAL_HEIGHT
	# Compensa a cauda erguida do recorte sem encolher o corpo ao abrir a planagem.
	if pose == "glide": height = 82
	if pose == "charge": height = PIPO_CHARGE_HEIGHT
	if pose == "prepare": height = PIPO_PREPARE_HEIGHT
	if pose in ["push", "push_attempt", "delivery_place"]: height = PIPO_PUSH_HEIGHT if pig else 72
	if pose == "carry": height = PIPO_CARRY_HEIGHT
	if pose == "wind_struggle": height = 92
	if pose.begins_with("tail_"): height = 82
	var size := texture.get_size() * (height / texture.get_height())
	var bob := sin(_time*3)*1.0
	var angle := 0.0
	if pose == "glide":
		bob = sin(_time*2.5)*0.8
		angle = sin(_time*2.5)*0.015
	if pose == "run": bob = -absf(sin(_run_distance / (20.0 if pig else 18.0) * PI/2))*2
	if pose == "wind_struggle":
		bob = -absf(sin(_wind_step_time*2.4*PI/2))*0.7
		angle = 0.025*character.facing
	if pose in ["push","delivery_place"]: bob = 0
	if pose == "carry":
		# As próprias poses já alternam as pernas. Deslocar ou girar o quadro inteiro
		# separava os pés do piso e fazia Pipo flutuar enquanto carregava a cesta.
		bob = 0
		angle = 0
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
	if pose in ["push", "push_attempt", "delivery_place"]:
		# As mãos ficam junto à lateral física da pedra, também ao virar à esquerda.
		right_edge = 26.0 if pig else 18.0
	draw_texture_rect(texture,Rect2(Vector2(right_edge-size.x,-size.y),size),false)
