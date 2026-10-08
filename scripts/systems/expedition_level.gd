extends "res://scripts/systems/world_level.gd"
@export_range(2,4) var biome := 2
@export_range(0,3) var section := 0
const NAMES = {
	2:["2-1 • Atravessando o Rio","2-2 • Correnteza","2-3 • A Grande Ponte","2-4 • Guardião do Rio"],
	3:["3-1 • Vento nas Alturas","3-2 • Cavernas da Montanha","3-3 • O Ninho das Corujas","3-4 • Gavião da Montanha"],
	4:["4-1 • A Vila Mecânica","4-2 • A Grande Barragem","4-3 • As Engrenagens","4-4 • Rei Castor"]}
const BACKGROUNDS = [preload("res://assets/worlds/river_painted.png"),preload("res://assets/worlds/mountain.svg"),preload("res://assets/worlds/village.svg")]
var water: Array[Rect2] = []
var wind_zones: Array[Rect2] = []
var headwind_zones: Array[Rect2] = []
var current_zones: Array[Rect2] = []
var weighted_springs: Array[Node2D] = []
var headwind_hint_shown := false
var cargo_objects: Array[Node2D] = []
var carried_object: Node2D
var cave_roofs: Array[Rect2] = []
var movers: Array[Node2D] = []
var mechanisms: Dictionary = {}
var connections: Dictionary = {}
var scenery: Node2D
var safe_spot := Vector2(160,755)
var hazard_delay := 0.0
var headwind_clock := 0.0
var supply_departure_active := false
var supply_placement_active := false
const RIVER_TICO_SPEED_SCALE := 0.10
const RIVER_PIPO_SPEED_SCALE := 0.95

func _ready() -> void:
	world_stage = 3
	$Geometry/SafetyFloor.collision_layer = 0
	$FollowCamera.limit_top = -260
	super._ready()
	if biome==2 and section==0:
		squirrel.move_speed *= RIVER_TICO_SPEED_SCALE
		pipo.movement_speed_multiplier = RIVER_PIPO_SPEED_SCALE
		pipo.move_speed = 220.0*RIVER_PIPO_SPEED_SCALE
	next_button.text = "Próxima fase" if section<2 else ("Encontrar o Guardião" if section==2 else ("Seguir para a Montanha" if biome==2 else "Seguir para a Vila" if biome==3 else "Jogar novamente"))
	_say(["O rio leva pistas! Espere os troncos e salte entre as margens.","Siga as penas! Tico pode planar nas correntes de vento.","Os castores precisam de ajuda. Pipo aciona os mecanismos!"][biome-2])
	_message_time = 7
	_update_layout()

func _process(delta: float) -> void:
	super._process(delta)
	# A classe-base recalcula o botão de troca a cada quadro. A sequência de
	# entrega precisa mantê-lo bloqueado até a carroça sair da tela.
	if supply_departure_active:
		switch_button.disabled = true

func _build_gameplay() -> void:
	if biome==2: _river()
	elif biome==3: _mountain()
	else: _village()
	if biome==2 and section==0:
		# 2-1 possui uma exploração própria atrás da cachoeira. A campanha
		# expedicionária não cria automaticamente as áreas do Mundo 1.
		optional_area = preload("res://scripts/systems/waterfall_grotto_area.gd").new()
		optional_area.level = self
		optional_area.z_index = -2
		add_child(optional_area)
		optional_area.build()
		for actor in actors.get_children():
			if actor.is_in_group("enemies"): actor.set_meta("pipo_one_hit",true)
	for actor in actors.get_children():
		if actor.has_method("reset_item") or actor.has_method("reset_block"):
			actor.set_meta("save_id","%d:%d" % [actor.position.x,actor.position.y])

func _river() -> void:
	if section==3:
		_boss_arena()
		return
	if section==1:
		for rect in [Rect2(0,760,940,200),Rect2(1450,760,720,200),Rect2(2580,760,1220,200)]: _platform(rect)
		water = [Rect2(940,805,510,190),Rect2(2170,805,410,190)]
		current_zones = [Rect2(1450,650,720,150),Rect2(2580,650,520,150)]
		_device("Tronco",Vector2(700,760),"log")
		_weight_platform("PesoMargem",Vector2(1760,760))
		_supply_cargo("CargaMargem",Vector2(1560,760),Vector2(2050,760))
		_bridge("Tronco",Rect2(900,758,580,30))
		_gate("Tronco",Rect2(1430,310,25,450))
		_mover(Vector2(2250,720),Vector2(250,0),180,5)
		for point in [Vector2(350,715),Vector2(550,715),Vector2(1050,712),Vector2(1260,712),Vector2(1620,715),Vector2(2020,715),Vector2(2360,655),Vector2(2710,715),Vector2(3400,715)]: _nut(point)
		_armored_enemy(Vector2(2940,760),70)
		_markers(Vector2(1830,760),Vector2(3570,760))
		_sign(Vector2(390,540),"Pipo • Empurre o tronco até a água")
		_sign(Vector2(1620,550),"Tico • Siga sobre os troncos")
		return
	if section==2:
		for rect in [Rect2(0,760,720,200),Rect2(1150,700,650,260),Rect2(2300,700,460,260),Rect2(3180,760,620,200)]: _platform(rect)
		water = [Rect2(720,810,430,180),Rect2(1800,810,500,180),Rect2(2760,810,420,180)]
		current_zones = [Rect2(1150,590,650,150),Rect2(2300,590,460,150)]
		_mover(Vector2(780,715),Vector2(300,0),180,5)
		_device("Ponte",Vector2(1440,700),"charge")
		_weight_platform("PesoPonte",Vector2(1620,700))
		_supply_cargo("CargaPonte",Vector2(2700,700),Vector2(3390,760))
		_bridge("Ponte",Rect2(1770,700,570,30))
		_gate("Ponte",Rect2(2280,270,25,430))
		_mover(Vector2(2820,720),Vector2(300,0),200,5.5)
		for point in [Vector2(350,715),Vector2(580,715),Vector2(1260,655),Vector2(1620,655),Vector2(1920,655),Vector2(2150,655),Vector2(2520,655),Vector2(3380,715)]: _nut(point)
		_armored_enemy(Vector2(2580,700),65)
		_markers(Vector2(1660,700),Vector2(3580,760))
		_sign(Vector2(370,540),"A grande ponte • Espere os troncos")
		_sign(Vector2(1180,460),"Pipo • Invista na engrenagem")
		return
	# A primeira fase é validada antes da produção das demais.
	for rect in [Rect2(0,760,760,200),Rect2(1140,760,460,200),Rect2(2080,720,460,240),Rect2(2840,760,960,200)]: _platform(rect)
	# A água começa após a margem estendida; assim as ondas não atravessam o solo.
	water = [Rect2(760,810,380,180),Rect2(1600,810,480,180),Rect2(2540,810,300,180)]
	current_zones = [Rect2(1140,650,460,150),Rect2(2080,610,460,150),Rect2(2840,650,520,150)]
	# A primeira plataforma permanece inteiramente sobre o rio: sua altura segue
	# acessível, mas ela não cria mais um teto baixo sobre a trilha de Pipo.
	_mover(Vector2(820,725),Vector2(250,0),180,5)
	_mover(Vector2(1680,725),Vector2(180,0),180,4.8)
	_mover(Vector2(1950,700),Vector2(110,0),180,5.2)
	_weight_platform("PesoCorrente",Vector2(3425,760))
	_supply_cargo("CargaRio",Vector2(3480,760),Vector2(3650,760))
	# A corrente de ar atravessa toda a fase: Tico sente a rajada desde a entrada,
	# enquanto o peso de Pipo permite manter o avanço.
	headwind_zones = [Rect2(-120,-260,4040,1220)]
	_weighted_spring(Vector2(2440,720))
	_platform(Rect2(2580,405,330,45))
	for point in [Vector2(2615,361),Vector2(2685,361),Vector2(2755,361)]: _nut(point)
	for point in [Vector2(350,715),Vector2(580,715),Vector2(850,650),Vector2(1260,715),Vector2(1520,715),Vector2(1850,620),Vector2(2350,645),Vector2(2970,715),Vector2(3290,715)]: _nut(point)
	_armored_enemy(Vector2(3155,760),45)
	_markers(Vector2(1410,760),Vector2(3740,760))
	preload("res://scripts/systems/river_crossing_layout.gd").build(self)
	_sign(Vector2(370,535),"Espere o tronco • Pule")
	_sign(Vector2(1240,560),"Bandeira • Um passo de cada vez")
	_sign(Vector2(2170,490),"Vento forte • Pipo alcança a mola")
	_sign(Vector2(2940,505),"Pipo • Leve as provisões até a carroça")

func _mountain() -> void:
	if section==3:
		_boss_arena()
		return
	if section==1:
		for rect in [Rect2(0,760,1800,200),Rect2(1800,690,200,270),Rect2(2000,620,200,340),Rect2(2200,550,350,410),Rect2(2950,460,350,500),Rect2(3300,390,500,570)]: _platform(rect)
		var roof := Rect2(580,0,650,696)
		cave_roofs.append(roof)
		var body := _solid("CaveRoof",roof,Color("4b5368"))
		for child in body.get_children():
			if child is Polygon2D: child.hide()
		_device("Rocha",Vector2(1460,760),"charge")
		_gate("Rocha",Rect2(1710,310,36,450))
		wind_zones.append(Rect2(2470,220,540,580))
		for point in [Vector2(350,715),Vector2(700,733),Vector2(990,733),Vector2(1320,715),Vector2(1890,645),Vector2(2080,575),Vector2(2350,505),Vector2(3070,415),Vector2(3480,345)]: _nut(point)
		secret = SECRET.instantiate()
		secret.position = Vector2(1580,718)
		actors.add_child(secret)
		secret.collected.connect(_on_collected)
		total_nuts += 1
		_sky_enemy(Vector2(2650,410))
		_markers(Vector2(1870,690),Vector2(3600,390))
		_sign(Vector2(260,510),"Tico • Passagem estreita")
		_sign(Vector2(1280,530),"Pipo • Invista e siga o faro")
		return
	if section==2:
		for rect in [Rect2(0,760,600,200),Rect2(600,690,200,270),Rect2(800,620,200,340),Rect2(1000,550,220,410),Rect2(1640,430,360,530),Rect2(2000,360,220,600),Rect2(2220,290,260,670),Rect2(2480,220,250,740),Rect2(3180,220,620,740)]: _platform(rect)
		wind_zones = [Rect2(1140,100,560,700),Rect2(2650,-80,600,860)]
		_mover(Vector2(1470,510),Vector2(0,-100),160,5)
		_sky_enemy(Vector2(1860,345))
		_crow_enemy(Vector2(2890,175))
		for point in [Vector2(350,715),Vector2(680,645),Vector2(1080,505),Vector2(1400,385),Vector2(1770,385),Vector2(2090,315),Vector2(2340,245),Vector2(2600,175),Vector2(2960,100),Vector2(3440,175)]: _nut(point)
		_markers(Vector2(1780,430),Vector2(3600,220))
		_sign(Vector2(270,510),"Suba até o ninho • Siga as penas")
		_sign(Vector2(1010,280),"Tico • Segure PULO no vento")
		return
	# Vento e subida graduais; uma corrente sustenta Tico durante a planagem.
	for rect in [Rect2(0,760,680,200),Rect2(680,690,220,270),Rect2(900,620,280,340),Rect2(1640,530,360,430),Rect2(2410,460,400,500),Rect2(3180,390,620,570)]: _platform(rect)
	wind_zones = [Rect2(1100,280,570,540),Rect2(1940,220,510,590),Rect2(2740,140,510,680)]
	for point in [Vector2(350,715),Vector2(760,645),Vector2(990,575),Vector2(1350,470),Vector2(1760,485),Vector2(2150,400),Vector2(2590,415),Vector2(2980,350),Vector2(3400,345)]: _nut(point)
	_mover(Vector2(2210,560),Vector2(0,-80),160,5)
	_sky_enemy(Vector2(2710,370))
	_markers(Vector2(1830,530),Vector2(3580,390))
	_sign(Vector2(350,525),"Tico • Segure PULO no vento")
	_sign(Vector2(920,390),"Abra a cauda • Siga as correntes")

func _boss_arena() -> void:
	_platform(Rect2(0,760,3800,200))
	for point in [Vector2(350,715),Vector2(700,715),Vector2(1100,715),Vector2(1600,715)]: _nut(point)
	_markers(Vector2(1840,760),Vector2(3590,760))
	_nut(Vector2(1990,715),true)
	guardian = preload("res://scripts/enemies/region_guardian.gd").new()
	guardian.level = self
	guardian.biome = biome
	guardian.position = Vector2(2850,760)
	if biome==2:
		_mover(Vector2(2550,640),Vector2(120,0),160,5)
		_sign(Vector2(1100,520),"Pipo rompe a defesa • Tico acerta o guardião")
	elif biome==3:
		_platform(Rect2(2500,690,750,70))
		guardian.position.y = 690
		wind_zones.append(Rect2(2440,420,820,340))
		_sign(Vector2(1100,520),"Espere o Gavião pousar • Tico salta por cima")
	else:
		_device("Arena",Vector2(2220,760),"charge")
		var lift := _mover(Vector2(2460,752),Vector2(0,-220),300,6,false)
		connections["Arena"].append({"lift":lift})
		_platform(Rect2(2600,620,650,140))
		guardian.position.y = 620
		_sign(Vector2(1200,520),"Pipo liga o elevador • Tico sobe e salta")
	actors.add_child(guardian)
	guardian.calmed.connect(_on_guardian_calmed)

func _village() -> void:
	if section==3:
		_boss_arena()
		return
	if section==1:
		for rect in [Rect2(0,760,1050,200),Rect2(1850,760,500,200),Rect2(2660,620,1140,340)]: _platform(rect)
		water = [Rect2(1050,740,800,260),Rect2(2350,810,310,180)]
		_device("Comporta",Vector2(800,760),"charge")
		_bridge("Comporta",Rect2(1030,760,840,35))
		_gate("Comporta",Rect2(1830,300,25,460))
		connections["Comporta"].append({"drain":true})
		var roof := Rect2(1300,0,450,696)
		cave_roofs.append(roof)
		_solid("DamTunnel",roof,Color("695840"))
		var lift := _mover(Vector2(2460,750),Vector2(0,-210),400,6,false)
		connections["Comporta"].append({"lift":lift})
		for point in [Vector2(350,715),Vector2(560,715),Vector2(1110,715),Vector2(1450,733),Vector2(1660,733),Vector2(2190,715),Vector2(2790,575),Vector2(3340,575)]: _nut(point)
		_markers(Vector2(2090,760),Vector2(3600,620))
		_sign(Vector2(360,510),"Pipo • Abra a comporta com uma investida")
		_sign(Vector2(1050,510),"Água baixa • Tico passa por baixo")
		return
	if section==2:
		for rect in [Rect2(0,760,940,200),Rect2(1470,760,750,200),Rect2(2540,620,1260,340)]: _platform(rect)
		water = [Rect2(940,810,530,180),Rect2(2220,810,320,180)]
		_device("Tora",Vector2(700,760),"log")
		_bridge("Tora",Rect2(910,760,590,30))
		_gate("Tora",Rect2(1460,300,25,460))
		_device("Roda",Vector2(1840,760),"weight")
		var lift := _mover(Vector2(2320,750),Vector2(0,-220),420,6,false)
		connections["Roda"].append({"lift":lift})
		_gate("Roda",Rect2(2515,250,25,510))
		_device("Engrenagem",Vector2(3210,620),"charge")
		_gate("Engrenagem",Rect2(3440,200,25,420))
		for point in [Vector2(350,715),Vector2(570,715),Vector2(1120,715),Vector2(1610,715),Vector2(2010,715),Vector2(2690,575),Vector2(3020,575),Vector2(3500,575)]: _nut(point)
		_slug(Vector2(2850,620),65)
		_markers(Vector2(2040,760),Vector2(3640,620))
		_sign(Vector2(360,520),"Tora • Peso • Engrenagem")
		_sign(Vector2(1610,510),"Pipo liga o elevador")
		_sign(Vector2(2930,390),"Pipo • Última engrenagem")
		return
	for rect in [Rect2(0,760,1180,200),Rect2(1740,760,480,200),Rect2(2520,620,1280,340)]: _platform(rect)
	water = [Rect2(1180,810,560,180),Rect2(2220,810,300,180)]
	_device("Peso",Vector2(830,760),"weight")
	_bridge("Peso",Rect2(1150,760,620,30))
	_gate("Peso",Rect2(1730,300,25,460))
	var lift := _mover(Vector2(2310,750),Vector2(0,-220),420,6,false)
	connections["Peso"].append({"lift":lift})
	for point in [Vector2(350,715),Vector2(600,715),Vector2(1020,715),Vector2(1330,715),Vector2(1560,715),Vector2(1860,715),Vector2(2100,715),Vector2(2670,575),Vector2(3350,575)]: _nut(point)
	_markers(Vector2(1940,760),Vector2(3580,620))
	_sign(Vector2(420,510),"Pipo • Fique sobre o botão de peso")
	_sign(Vector2(1830,505),"Suba no elevador • Espere ele subir")

func _mover(point: Vector2, travel: Vector2, width := 180.0, duration := 5.0, enabled := true) -> Node2D:
	var platform = preload("res://scripts/objects/travel_platform.gd").new()
	platform.position = point
	platform.travel = travel
	platform.width = width
	platform.duration = duration
	platform.enabled = enabled
	platform.wood = biome!=3
	actors.add_child(platform)
	movers.append(platform)
	return platform

func _device(id: String, point: Vector2, mode: String) -> Node2D:
	var device: Node2D
	if mode=="log":
		device = PUSHABLE.instantiate()
		device.set_script(preload("res://scripts/objects/bridge_log.gd"))
		device.max_travel = 130
	else:
		device = preload("res://scripts/objects/power_device.gd").new()
		device.mode = mode
		device.level = self
	device.name = id
	device.position = point
	actors.add_child(device)
	mechanisms[id] = device
	connections[id] = []
	device.activated.connect(func(_node): _apply_device(id,true))
	return device

func _weight_platform(id: String, point: Vector2) -> Node2D:
	var device = preload("res://scripts/objects/weight_platform.gd").new()
	device.name = id
	device.level = self
	device.position = point
	actors.add_child(device)
	mechanisms[id] = device
	connections[id] = []
	device.activated.connect(func(_node): _apply_device(id,true))
	return device

func _weighted_spring(point: Vector2) -> Node2D:
	var spring = preload("res://scripts/objects/weighted_spring.gd").new()
	spring.level = self
	spring.position = point
	actors.add_child(spring)
	weighted_springs.append(spring)
	return spring

func _supply_cargo(id: String, point: Vector2, destination: Vector2) -> Node2D:
	var cargo = preload("res://scripts/objects/carryable_supply.gd").new()
	cargo.name = id
	cargo.level = self
	cargo.position = point
	cargo.destination = destination
	actors.add_child(cargo)
	cargo_objects.append(cargo)
	mechanisms[id] = cargo
	connections[id] = []
	cargo.delivered.connect(func(_node): _apply_device(id,true))
	return cargo

func pipo_is_carrying() -> bool:
	return is_instance_valid(carried_object) and carried_object.carried

func try_pipo_carry(character: CharacterBody2D) -> bool:
	if character!=pipo: return false
	if pipo_is_carrying():
		var cargo := carried_object
		cargo.interact(character)
		if cargo.placing: return true
	for cargo in cargo_objects:
		if cargo.active or character.position.distance_to(cargo.position)>105: continue
		if cargo.interact(character):
			carried_object = cargo
			_say("Pipo está levando as provisões. AÇÃO solta ou entrega o cesto.")
			sounds.play_notes([262,330],.06)
			return true
	return false

func _start_supply_placement(cargo: Node2D) -> void:
	if supply_placement_active or supply_departure_active or cargo.active or not cargo.carried: return
	supply_placement_active = true
	supply_departure_active = true
	squirrel.controls_enabled = false
	pipo.controls_enabled = false
	squirrel.velocity = Vector2.ZERO
	pipo.velocity = Vector2.ZERO
	pipo.facing = 1.0 if cargo.destination.x>=pipo.position.x else -1.0
	pipo.state = &"idle"
	switch_button.disabled = true
	carried_object = null
	cargo.placement_finished.connect(_finish_supply_placement,CONNECT_ONE_SHOT)
	cargo.start_placement()
	_say("Pipo está colocando as provisões na carroça…")

func _finish_supply_placement(cargo: Node2D) -> void:
	supply_placement_active = false
	cargo.activate()
	_feedback(cargo.destination,"Provisões prontas!",Color("ffe394"))
	_say("A comida seguirá agora para o vilarejo!")
	sounds.play_notes([523,659,784],.07)
	cargo.departure_finished.connect(_finish_supply_departure,CONNECT_ONE_SHOT)
	cargo.start_departure()

func drop_carried_object() -> void:
	if not pipo_is_carrying(): return
	carried_object.drop_at(pipo.position)
	carried_object = null

func _start_supply_departure(cargo: Node2D) -> void:
	if supply_departure_active or cargo.departed: return
	supply_departure_active = true
	squirrel.controls_enabled = false
	pipo.controls_enabled = false
	squirrel.velocity = Vector2.ZERO
	pipo.velocity = Vector2.ZERO
	switch_button.disabled = true
	cargo.departure_finished.connect(_finish_supply_departure,CONNECT_ONE_SHOT)
	cargo.start_departure()

func _finish_supply_departure(_cargo: Node2D) -> void:
	supply_departure_active = false
	squirrel.controls_enabled = tico==squirrel
	pipo.controls_enabled = tico==pipo
	switch_button.disabled = false
	_say("As provisões seguem para o vilarejo. Agora, vá até o portal!")
	_feedback(tico.position+Vector2(0,-90),"Siga para o portal",Color("bfe69c"))
	sounds.play_notes([659,784,988],.075)

func _bridge(id: String, rect: Rect2) -> void:
	var body := _solid("Bridge",rect,Color("a8804b"))
	body.hide()
	body.get_node("Collision").disabled = true
	connections[id].append({"body":body,"rect":rect})

func _gate(id: String, rect: Rect2) -> void:
	var body := _solid("Sluice",rect,Color("876d4b"))
	connections[id].append({"gate":body})

func _apply_device(id: String, announce: bool) -> void:
	var device: Node2D = mechanisms[id]
	device.activate(false)
	for target in connections[id]:
		if target.has("body"):
			target.body.get_node("Collision").set_deferred("disabled",false)
			if target.rect not in terrain: terrain.append(target.rect)
		if target.has("gate"):
			target.gate.hide()
			target.gate.get_node("Collision").set_deferred("disabled",true)
		if target.has("lift"): target.lift.enabled = true
		if target.has("drain"):
			water.clear()
	if announce:
		_say("Caminho aberto! Agora os dois podem seguir.")
		sounds.play_effect("checkpoint")
		puff(device.position,Color("ffdf89"),14)
		_save_progress()

func _sky_enemy(point: Vector2) -> void:
	var enemy = preload("res://scripts/enemies/sky_enemy.gd").new()
	enemy.position = point
	enemy.level = self
	actors.add_child(enemy)
	enemy.stomped.connect(_on_stomp)

func _crow_enemy(point: Vector2) -> void:
	var enemy = preload("res://scripts/enemies/crow.gd").new()
	enemy.position = point
	enemy.level = self
	actors.add_child(enemy)
	enemy.stomped.connect(_on_stomp)

func _armored_enemy(point: Vector2, distance: float = 95.0) -> Node2D:
	var enemy = preload("res://scripts/enemies/armored_beetle.gd").new()
	enemy.position = point
	enemy.level = self
	enemy.patrol_distance = distance
	actors.add_child(enemy)
	enemy.stomped.connect(_on_stomp)
	enemy.armor_broken_signal.connect(_on_enemy_armor_broken)
	return enemy

func _on_enemy_armor_broken(enemy: Node2D) -> void:
	_feedback(enemy.position,"Armadura quebrada!",Color("f3d580"))
	_say("Boa, Pipo! A carapaça quebrou. Agora o inimigo está vulnerável.")
	sounds.play_notes([196,294,440],.065)

func _build_forest() -> void:
	$Landscape.hide()
	for body in $Geometry.get_children():
		for child in body.get_children():
			if child is Polygon2D: child.hide()
	background = TextureRect.new()
	background.texture = BACKGROUNDS[biome-2]
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Background.add_child(background)
	scenery = preload("res://scripts/presentation/expedition_art.gd").new()
	scenery.level = self
	actors.add_child(scenery)
	for actor in actors.get_children():
		if actor is Label:
			actor.add_theme_color_override("font_color",Color("fff2d1"))
			actor.add_theme_color_override("font_outline_color",Color("384e59"))
			actor.add_theme_constant_override("outline_size",5)

func _physics_process(delta: float) -> void:
	if not world_ready: return
	headwind_clock += delta
	tico.wind_acceleration = Vector2.ZERO
	tico.current_acceleration = Vector2.ZERO
	if get_tree().paused or completed or respawning: return
	hazard_delay = maxf(0,hazard_delay-delta)
	for zone in wind_zones:
		if zone.has_point(tico.position) and tico==squirrel and Input.is_action_pressed("jump"):
			tico.wind_acceleration = Vector2(160,-500)
	for zone in headwind_zones:
		# A rajada pertence à trilha aberta. Dentro da Caverna do Rio o ar fica
		# calmo e a troca para Tico é exigida pela altura das formações rochosas.
		if is_instance_valid(optional_area) and optional_area.get("active"): continue
		if zone.has_point(tico.position):
			# Intervalos mais suaves deixam Tico dar passos curtos; a rajada seguinte
			# cresce e o empurra novamente para trás.
			var gust := pow(maxf(0.0,sin(headwind_clock*1.8)),3.0)
			tico.wind_acceleration += Vector2(-lerpf(650.0,4200.0,gust),0)
			if tico==squirrel and not headwind_hint_shown:
				headwind_hint_shown = true
				_say("O vento empurra Tico para trás. Pipo é pesado o bastante para chegar à mola.")
	if biome==2 and section==0 and tico==pipo and pipo.ability=="charge":
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy.get_parent()==actors and enemy.get_meta("pipo_one_hit",false) and enemy.visible and pipo.position.distance_to(enemy.position)<78:
				if enemy.has_method("receive_charge"): enemy.receive_charge(pipo)
				elif enemy.has_method("_defeat"): enemy._defeat(pipo)
	for zone in current_zones:
		if zone.has_point(tico.position):
			tico.current_acceleration = Vector2(900,0)
	if tico.is_on_floor():
		for rect in terrain:
			if tico.position.x>rect.position.x+35 and tico.position.x<rect.end.x-35 and absf(tico.position.y-rect.position.y)<4:
				safe_spot = tico.position+Vector2(0,-4)
	var in_hazard: bool = tico.position.y>930
	for rect in water:
		if rect.has_point(tico.position): in_hazard = true
	if in_hazard and hazard_delay<=0:
		hazard_delay = 0.7
		tico.take_damage(tico.position+Vector2(0,30))
		if tico.health>0:
			tico.reset_at(safe_spot)
			camera.snap_to_target()
			_say("Tudo bem! Tente de novo a partir da margem.")

func tico_struggling_against_wind(character: CharacterBody2D) -> bool:
	if biome!=2 or section!=0 or character!=squirrel or not character.controls_enabled or not character.is_on_floor(): return false
	if is_instance_valid(optional_area) and optional_area.get("active"): return false
	if is_zero_approx(Input.get_axis("move_left","move_right")): return false
	return headwind_zones.any(func(zone: Rect2): return zone.has_point(character.position))

func _update_layout() -> void:
	super._update_layout()
	if world_ready:
		$Interface/HUD/TopBar/Title.text = NAMES[biome][section]+"\n"+("Pipo • Força" if tico==pipo else "Tico • Agilidade")
		if is_instance_valid(contextual_help): contextual_help.layout()

func _on_exit(marker: Node2D) -> void:
	for device in mechanisms.values():
		if not device.active:
			marker.activated = false
			_say("A carroça ainda espera as provisões de Pipo." if device.has_method("drop_at") else "Ative o mecanismo para completar o caminho.")
			return
	if is_instance_valid(guardian) and guardian.health>0:
		marker.activated = false
		_say("Ajude o guardião antes de seguir.")
		return
	super._on_exit(marker)
	var message: String = NAMES[biome][section]+"\nTrilha concluída!"
	if section==3:
		message = ["Rio das Pedras concluído!\nAs pistas seguem para as montanhas.","Montanha das Corujas concluída!\nOs castores precisam da nossa ajuda.","Vila dos Castores concluída!\nA trilha até a Árvore está aberta."][biome-2]
	result_text.text = message+"\nNozes: %d de %d" % [nuts,total_nuts]
	_save_progress()

func world_snapshot() -> Dictionary:
	var state := super.world_snapshot()
	state["mechanisms"] = {}
	for id in mechanisms: state.mechanisms[id] = mechanisms[id].active
	return state

func restore_world(state: Dictionary) -> void:
	for id in state.get("mechanisms",{}):
		if mechanisms.has(id) and state.mechanisms[id]: _apply_device(id,false)
	super.restore_world(state)
	safe_spot = checkpoint_position

func _respawn() -> void:
	super._respawn()
	if tico.health>0:
		safe_spot = checkpoint_position
		hazard_delay = 0

func _on_guardian_calmed() -> void:
	_say(["Guardião: A correnteza está calma. Sigam as penas até a montanha!","Gavião: Vi os carregamentos descendo para a vila. Sigam por lá!","Rei Castor: Obrigado! Os alimentos foram levados para a grande árvore."][biome-2])
	_message_time = 8
	_save_progress()

func _test_details() -> Dictionary:
	var state := super._test_details()
	state.merge({"stage":9,"biome":biome,"section":section,"world_title":NAMES[biome][section],"mechanisms":world_snapshot().mechanisms,"wind":tico.wind_acceleration.y},true)
	state["movers"] = []
	for platform in movers: state.movers.append([platform.position.x,platform.position.y])
	return state
