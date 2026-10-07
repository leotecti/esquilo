extends Node2D
## Galeria subterrânea de 1-2, acessada por uma ruína de pedra com névoa.
const ENTRY := Vector2(19400,475)
# Faixa plana imediatamente anterior à bandeira de x=24.200.
const RETURN := Vector2(24020,755)
const START := Vector2(46200,755)
const EXIT := Vector2(50750,565)
const LEFT_EDGE := 46000
const RIGHT_EDGE := 51200
const LIFE_ID := "galeria_12_life"
const EXIT_RETURN_STEPS := [Rect2(50990,630,110,20),Rect2(51080,700,120,20)]
const NIGHT_FOREST = preload("res://assets/environment/night_forest_passage.png")
var level: Node2D
var active := false
var checkpoint := false
var transitioning := false
var veil: ColorRect
var hints: Array[Label] = []
var bonus_life: StaticBody2D
var enemies: Array[Node2D] = []

func build() -> void:
	level._platform(Rect2(LEFT_EDGE,760,RIGHT_EDGE-LEFT_EDGE,220))
	# Cada plataforma alta recebe aproximações de até 80 px. Assim a exploração
	# opcional também funciona nos dois sentidos e com o salto menor de Pipo.
	for rect in [Rect2(46490,700,160,60),Rect2(46650,650,420,110),
		Rect2(47080,680,160,80),Rect2(47240,620,160,140),Rect2(47400,590,480,170),
		Rect2(47880,650,160,110),Rect2(48040,710,160,50),Rect2(48200,680,420,80),
		Rect2(48630,680,160,80),Rect2(48790,610,160,150),Rect2(48950,540,520,220),
		Rect2(49470,610,160,150),Rect2(49630,680,160,80),Rect2(49790,640,60,120),Rect2(49850,640,440,120),
		Rect2(50290,640,105,120),Rect2(50395,570,105,190),Rect2(50500,570,500,190)]: level._platform(rect)
	# Plataformas atravessáveis formam a volta após uma queda junto ao portal.
	# Do piso y=760, os saltos sobem para 700, 630 e então para a saída em 570.
	for rect in EXIT_RETURN_STEPS: level._drop_platform(rect)
	for rect in [Rect2(LEFT_EDGE-50,-200,50,1300),Rect2(RIGHT_EDGE,-200,50,1300)]: level._solid("GalleryBoundary",rect,Color.TRANSPARENT)
	for row in [[46400,715,4],[46800,605,4],[47500,545,5],[48300,625,4],[49040,495,5],[49920,595,4],[50600,525,5]]:
		for i in int(row[2]): _nut(Vector2(row[0]+i*76,row[1]))
	# Cada fruta acompanha a superfície local. A altura fixa anterior (y=710)
	# deixava os itens soterrados sob as plataformas elevadas da galeria.
	for entry in [[47150,632,0],[47920,602,1],[48710,632,2],[49720,632,0],[50350,592,1]]: _food(Vector2(entry[0],entry[1]),entry[2])
	for point in [Vector2(47800,545),Vector2(49380,495),Vector2(50580,525)]: _nut(point,true)
	level._golden_nut(Vector2(49300,495),"galeria_pedra_12")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:galeria_pedra_12")
	# Lesmas patrulham as plataformas do percurso. No piso-base elas ficavam
	# presas sob os degraus e não participavam do desafio da galeria.
	for entry in [[48050,710,70],[49600,610,75],[50380,640,65]]:
		var enemy = level._slug(Vector2(entry[0],entry[1]),entry[2])
		enemy.set_meta("e20_optional_enemy",true)
		enemies.append(enemy)
	if LIFE_ID not in level.campaign.data.story.events:
		bonus_life = preload("res://scripts/objects/life_cache.gd").new()
		bonus_life.name = "GalleryLifeCache"
		bonus_life.campaign = level.campaign
		bonus_life.stage_id = 1
		bonus_life.reward_id = LIFE_ID
		bonus_life.position = Vector2(50060,490)
		level.actors.add_child(bonus_life)
	_add_hint(ENTRY,"Galeria das Pedras\nAÇÃO para entrar",true)
	_add_hint(START,"Voltar à trilha • Ação",false)
	_add_hint(EXIT,"Sair adiante • Ação",false)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("273849")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _nut(point: Vector2, healing := false) -> void:
	level._nut(point,healing)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","gallery:%d:%d" % [point.x,point.y])

func _food(point: Vector2, kind: int) -> void:
	level._food(point,kind)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","gallery-food:%d:%d" % [point.x,point.y])

func _add_hint(point: Vector2, message: String, entry: bool) -> void:
	var label := Label.new()
	label.text = message
	label.position = point+Vector2(-165,-145)
	label.size.x = 330
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",19)
	label.add_theme_color_override("font_color",Color("eef3dc"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("263b3bea")
	style.set_corner_radius_all(12)
	style.content_margin_top = 7
	style.content_margin_bottom = 7
	label.add_theme_stylebox_override("normal",style)
	label.set_meta("portal_point",point)
	label.set_meta("entry_portal",entry)
	label.hide()
	add_child(label)
	hints.append(label)

func _physics_process(_delta: float) -> void:
	queue_redraw()
	for hint in hints:
		hint.visible = not transitioning and not level.completed and not level.respawning and level.tico.position.distance_to(hint.get_meta("portal_point"))<(180 if hint.get_meta("entry_portal") else 110)
	if transitioning or level.completed or level.respawning: return
	if active and level.tico.position.y>980:
		level.tico.take_damage(level.tico.position+Vector2(0,30))
		if level.tico.health>0: restore_player()
	if Input.is_action_just_pressed("action") and level.tico.is_on_floor():
		if not active and level.tico.position.distance_to(ENTRY)<105: travel(true)
		elif active and (level.tico.position.distance_to(START)<105 or level.tico.position.distance_to(EXIT)<105): travel(false)

func travel(entering: bool) -> void:
	if transitioning or level.completed or level.respawning: return
	transitioning = true
	level.tico.controls_enabled = false
	level.touch.release_all()
	for action in ["move_left","move_right","move_down","jump","action","switch_character"]: Input.action_release(action)
	var tween := create_tween()
	tween.tween_property(veil,"modulate:a",1.0,.16)
	tween.tween_callback(func(): active=entering; apply_camera(); level.sounds.set_environment("night" if entering else "forest"); level.tico.reset_at(START if entering else RETURN); level.camera.snap_to_target(); level._save_progress(); level._say("Galeria das Pedras" if entering else "De volta à trilha, perto da bandeira"))
	tween.tween_property(veil,"modulate:a",0.0,.16)
	tween.tween_callback(func(): level.tico.controls_enabled=true; transitioning=false)

func apply_camera() -> void:
	level.camera.limit_left = LEFT_EDGE if active else 0
	level.camera.limit_right = RIGHT_EDGE if active else level.main_right

func restore_player() -> void:
	apply_camera()
	if active: level.tico.reset_at(START)
	level.camera.snap_to_target()

func snapshot() -> Dictionary: return {"active":active,"checkpoint":false}
func restore(state: Dictionary) -> void:
	active = state.get("active",false) and not level.completed
	checkpoint = false
	restore_player()

func _draw() -> void:
	var pulse := sin(Time.get_ticks_msec()*.003)
	# Passagem noturna: três painéis preservam a proporção da pintura e usam as
	# bordas escuras como transições naturais entre trechos do bosque.
	for panel in 3:
		draw_texture_rect(NIGHT_FOREST,Rect2(LEFT_EDGE+panel*1800,-10,1800,770),false,Color("d5e6f4"))
	# Véu azul aproxima o fundo da paleta das plataformas e garante leitura dos
	# personagens. Névoa e vaga-lumes se movem suavemente sobre a pintura.
	draw_rect(Rect2(LEFT_EDGE,0,RIGHT_EDGE-LEFT_EDGE,760),Color(0.04,0.10,0.20,.22))
	for i in 18:
		var phase := Time.get_ticks_msec()*.00035+i*.71
		var light := Vector2(LEFT_EDGE+135+i*292+sin(phase)*18,180+(i%5)*91+cos(phase*.8)*12)
		draw_circle(light,3.5+sin(phase)*.7,Color("ffe28faa"))
	for i in 5:
		var mist_x := LEFT_EDGE+500+i*1050+sin(Time.get_ticks_msec()*.00018+i)*90
		draw_set_transform(Vector2(mist_x,610-i%2*70),0,Vector2(3.6,0.55))
		draw_circle(Vector2.ZERO,82,Color(0.55,0.72,0.84,.055))
		draw_set_transform(Vector2.ZERO)
	# Portal de alvenaria, rochas na base e névoa: leitura distinta da árvore de 1-1.
	draw_colored_polygon(PackedVector2Array([Vector2(19170,545),Vector2(19195,355),Vector2(19255,285),Vector2(19335,250),Vector2(19465,250),Vector2(19545,285),Vector2(19605,355),Vector2(19630,545)]),Color("665d4d"))
	draw_arc(Vector2(19400,440),170,PI,TAU,30,Color("a89872"),34,true)
	draw_rect(Rect2(19225,420,350,130),Color("655d4e"))
	draw_set_transform(Vector2(19400,455),0,Vector2(1.15,.9))
	draw_circle(Vector2.ZERO,118,Color(0.35,0.65,0.69,.34+pulse*.04))
	draw_set_transform(Vector2.ZERO)
	for i in 7:
		var phase := Time.get_ticks_msec()*.00045+i*.9
		draw_circle(Vector2(19400+sin(phase)*105,510-fmod(Time.get_ticks_msec()*.012+i*31,150)),4,Color("d4f4e9aa"))
	for rock in [Rect2(19155,515,105,65),Rect2(19235,505,85,75),Rect2(19495,505,95,75),Rect2(19570,520,90,60)]:
		draw_colored_polygon(PackedVector2Array([rock.position+Vector2(0,rock.size.y),rock.position+Vector2(12,18),rock.position+Vector2(rock.size.x*.55,0),rock.position+Vector2(rock.size.x,25),rock.end]),Color("7d735d"))
	# Cristais discretos ligam a antiga identidade da galeria à nova passagem.
	for point in [Vector2(46900,710),Vector2(48600,710),Vector2(50100,710),Vector2(50900,710)]:
		draw_colored_polygon(PackedVector2Array([point+Vector2(-18,0),point+Vector2(-8,-48),point+Vector2(4,-70),point+Vector2(18,0)]),Color("7fc6b8aa"))
	# A entrada de retorno fica discreta. O portal ao fim é maior, tem moldura,
	# névoa e luz para ser reconhecido antes de o jogador chegar até ele.
	draw_arc(START+Vector2(0,-45),45,PI,TAU,24,Color("9e9072"),9,true)
	draw_circle(START+Vector2(0,-30),31,Color("75b8b188"))
	var portal_center := EXIT+Vector2(0,-62)
	draw_set_transform(portal_center,0,Vector2(.82,1.25))
	draw_circle(Vector2.ZERO,72,Color("314b50"))
	draw_circle(Vector2.ZERO,60,Color(0.48,0.82,0.76,.38+pulse*.05))
	draw_arc(Vector2.ZERO,70,0,TAU,40,Color("b3a37b"),9,true)
	draw_set_transform(Vector2.ZERO)
	for i in 6:
		var phase := Time.get_ticks_msec()*.0006+i*1.1
		draw_circle(portal_center+Vector2(sin(phase)*42,35-fmod(Time.get_ticks_msec()*.015+i*24,105)),3.5,Color("d7f8e6bb"))
	for rock in [Rect2(EXIT.x-86,EXIT.y-32,50,38),Rect2(EXIT.x+35,EXIT.y-32,55,38)]:
		draw_colored_polygon(PackedVector2Array([rock.position+Vector2(0,rock.size.y),rock.position+Vector2(8,10),rock.position+Vector2(rock.size.x*.55,0),rock.end]),Color("84785f"))
