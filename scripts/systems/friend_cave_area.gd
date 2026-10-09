extends Node2D
## Área secundária de 1-3: túnel natural, morcegos, estalactites e goteiras.
const ENTRY := Vector2(19500,520)
const RETURN := Vector2(24080,675)
const LEFT_EDGE := 65000
const RIGHT_EDGE := 70800
const START := Vector2(65180,755)
const EXIT := Vector2(70550,700)
const PORTAL_STYLE_VERSION := 2
const CAVE_BACKGROUND = preload("res://assets/environment/cold_cave_background.png")
const BACKGROUND_STYLE_VERSION := 2
const TERRAIN_STYLE_VERSION := 1
const PERFORMANCE_STYLE_VERSION := 2
const CAVE_PLATFORMS := [Rect2(65000,760,5800,220),Rect2(65480,690,360,70),
	Rect2(65840,620,420,140),Rect2(66480,680,300,80),Rect2(66920,600,500,160),
	Rect2(67620,680,360,80),Rect2(68120,590,520,170),Rect2(68820,670,400,90),
	Rect2(69420,610,500,150),Rect2(70120,680,420,80)]
var level: Node2D
var active := false
var checkpoint := false
var transitioning := false
var veil: ColorRect
var hints: Array[Label] = []
var drips: Array[Node2D] = []
var _visual_elapsed := 0.0

func build() -> void:
	for rect in CAVE_PLATFORMS: level._platform(rect)
	for rect in [Rect2(LEFT_EDGE-50,-200,50,1300),Rect2(RIGHT_EDGE,-200,50,1300)]: level._solid("FriendCaveBoundary",rect,Color.TRANSPARENT)
	for row in [[65220,715,4],[65720,575,4],[66540,635,3],[67020,555,5],[67700,635,4],[68230,545,5],[68920,625,4],[69520,565,5],[70200,635,4]]:
		for i in int(row[2]): _nut(Vector2(row[0]+i*76,row[1]))
	for entry in [[66000,570,0],[67300,550,1],[68600,540,2],[69800,560,0]]: _food(Vector2(entry[0],entry[1]),entry[2])
	for point in [Vector2(66800,635),Vector2(69200,625),Vector2(70280,635)]: _nut(point,true)
	level._golden_nut(Vector2(68500,535),"caverna_amizade_13")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:caverna_amizade_13")
	for point in [Vector2(66200,390),Vector2(67550,350),Vector2(69000,380),Vector2(69950,340)]:
		var bat = preload("res://scripts/enemies/sky_enemy.gd").new()
		bat.level = level
		bat.position = point
		bat.set_meta("friend_cave_bat",true)
		level.actors.add_child(bat)
		bat.stomped.connect(level._on_stomp)
	for entry in [[65650,610,0.0],[66680,650,.7],[67950,650,1.4],[68750,640,2.1],[69700,650,.35],[70400,650,1.1]]:
		var drip = preload("res://scripts/hazards/cave_drip.gd").new()
		drip.level = level
		drip.position = Vector2(entry[0],90)
		drip.drop_y = entry[1]-90
		drip.delay = entry[2]
		add_child(drip)
		drips.append(drip)
	_add_hint(ENTRY,"Túnel da Gruta Fria\nAÇÃO para explorar",true)
	_add_hint(START,"Voltar à trilha • Ação",false)
	_add_hint(EXIT,"Saída da caverna • Ação",false)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("172b35")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _nut(point: Vector2, healing := false) -> void:
	level._nut(point,healing)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","friend-cave:%d:%d" % [point.x,point.y])

func _food(point: Vector2, kind: int) -> void:
	level._food(point,kind)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","friend-cave-food:%d:%d" % [point.x,point.y])

func _add_hint(point: Vector2, message: String, entry: bool) -> void:
	var label := Label.new()
	label.text = message
	label.position = point+Vector2(-175,-150 if entry else -120)
	label.size.x = 350
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",19)
	label.add_theme_color_override("font_color",Color("e9f3e6"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("18313aea")
	style.border_color = Color("7da0a5")
	style.set_border_width_all(2)
	style.set_corner_radius_all(13)
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	label.add_theme_stylebox_override("normal",style)
	label.set_meta("portal_point",point)
	label.set_meta("entry_portal",entry)
	label.hide()
	add_child(label)
	hints.append(label)

func _physics_process(delta: float) -> void:
	_visual_elapsed += delta
	# A pintura completa da gruta é estática. Somente o portal da trilha pulsa;
	# goteiras, inimigos e personagens mantêm suas animações em nós próprios.
	if not active and level.tico.position.distance_to(ENTRY)<850.0 and _visual_elapsed>=1.0/20.0:
		_visual_elapsed = 0.0
		queue_redraw()
	if not active and not transitioning and level.tico.position.distance_to(ENTRY)>=900.0:
		for hint in hints: hint.hide()
		return
	for hint in hints:
		hint.visible = not transitioning and not level.completed and not level.respawning and level.tico.position.distance_to(hint.get_meta("portal_point"))<(180 if hint.get_meta("entry_portal") else 110)
	if transitioning or level.completed or level.respawning: return
	if active and level.tico.position.y>980:
		level.tico.take_damage(level.tico.position+Vector2(0,30))
		if level.tico.health>0: restore_player()
	if Input.is_action_just_pressed("action") and level.tico.is_on_floor():
		if not active and level.tico.position.distance_to(ENTRY)<110: travel(true)
		elif active and (level.tico.position.distance_to(START)<110 or level.tico.position.distance_to(EXIT)<110): travel(false)

func travel(entering: bool) -> void:
	if transitioning or level.completed or level.respawning: return
	transitioning = true
	level.tico.controls_enabled = false
	level.touch.release_all()
	for action in ["move_left","move_right","move_down","jump","action","switch_character"]: Input.action_release(action)
	var tween := create_tween()
	tween.tween_property(veil,"modulate:a",1.0,.18)
	tween.tween_callback(func(): active=entering; queue_redraw(); apply_camera(); level.sounds.set_environment("night" if entering else "forest"); level.tico.reset_at(START if entering else RETURN); level.camera.snap_to_target(); level._save_progress(); level._say("Gruta Fria • observe o brilho antes dos pingos" if entering else "De volta à trilha, perto da bandeira"))
	tween.tween_property(veil,"modulate:a",0.0,.18)
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
	queue_redraw()
	restore_player()

func _draw() -> void:
	# Portal e caverna nunca são enviados juntos ao renderizador. Isso mantém o
	# retângulo visual próximo da câmera em vez de atravessar 45 mil unidades.
	if active:
		_draw_active_cave()
		return
	# A entrada usa rochas sobrepostas e profundidade, com leitura clara de túnel.
	var pulse := sin(Time.get_ticks_msec()*.003)
	draw_colored_polygon(PackedVector2Array([Vector2(19230,760),Vector2(19280,520),Vector2(19380,405),Vector2(19500,365),Vector2(19620,405),Vector2(19720,520),Vector2(19770,760)]),Color("56544e"))
	draw_set_transform(Vector2(19500,590),0,Vector2(1.2,1.0))
	draw_circle(Vector2.ZERO,135,Color("182d35"))
	draw_circle(Vector2(0,8),112,Color(0.12,0.31,0.38,.78+pulse*.04))
	draw_circle(Vector2(0,12),86,Color(0.31,0.66,0.67,.16+pulse*.04))
	draw_set_transform(Vector2.ZERO)
	# Arco segmentado, brilho e neblina deixam clara a função de passagem.
	for i in 9:
		var angle := lerpf(PI,TAU,float(i)/8.0)
		var center := Vector2(19500,590)+Vector2(cos(angle)*158,sin(angle)*142)
		var radial := Vector2(cos(angle),sin(angle))
		var tangent := Vector2(-radial.y,radial.x)
		draw_colored_polygon(PackedVector2Array([center-radial*20-tangent*29,center-radial*20+tangent*29,center+radial*20+tangent*25,center+radial*20-tangent*25]),Color("898273"))
		draw_polyline(PackedVector2Array([center-radial*20-tangent*29,center-radial*20+tangent*29,center+radial*20+tangent*25,center+radial*20-tangent*25,center-radial*20-tangent*29]),Color("b8ad91"),3,true)
	for i in 7:
		var phase := Time.get_ticks_msec()*.00055+i*.9
		draw_circle(Vector2(19500+sin(phase)*92,625-fmod(Time.get_ticks_msec()*.014+i*29,125)),4,Color("b8f0dfaa"))
	for i in 4:
		draw_set_transform(Vector2(19435+i*45,675+i%2*9),0,Vector2(1.7,.35))
		draw_circle(Vector2.ZERO,46,Color(0.55,0.84,0.79,.10))
		draw_set_transform(Vector2.ZERO)
	for rock in [Rect2(19190,690,130,70),Rect2(19260,635,105,125),Rect2(19635,635,105,125),Rect2(19690,695,125,65)]:
		draw_colored_polygon(PackedVector2Array([rock.position+Vector2(0,rock.size.y),rock.position+Vector2(15,22),rock.position+Vector2(rock.size.x*.55,0),rock.position+Vector2(rock.size.x,28),rock.end]),Color("777166"))

func _draw_active_cave() -> void:
	# Pintura em painéis preserva a leitura lateral e cobre toda a Gruta Fria.
	for panel in 3:
		draw_texture_rect(CAVE_BACKGROUND,Rect2(LEFT_EDGE+panel*1934,-5,1934,765),false,Color("b9d3df"))
	draw_rect(Rect2(LEFT_EDGE,0,RIGHT_EDGE-LEFT_EDGE,760),Color(0.03,0.10,0.16,.24))
	# Sombras esporádicas de morcegos cruzam planos distantes em velocidades diferentes.
	var bat_time := Time.get_ticks_msec()*.000055
	for i in 5:
		var travel := fmod(bat_time*(1.0+i*.11)+i*.21,1.0)
		var shadow_center := Vector2(LEFT_EDGE-180+travel*(RIGHT_EDGE-LEFT_EDGE+360),150+(i%3)*105+sin(bat_time*8+i)*28)
		_draw_bat_shadow(shadow_center,.55+i*.08,.10+i*.012)
	for band in 4:
		var color: Color = [Color(0.13,0.23,0.27,.12),Color(0.16,0.29,0.32,.10),Color(0.19,0.35,0.36,.08),Color(0.10,0.20,0.24,.10)][band]
		for i in 9:
			var x := LEFT_EDGE+i*720+band*170
			draw_circle(Vector2(x,320+band*105),250-band*28,color)
	for x in range(LEFT_EDGE+180,RIGHT_EDGE,430):
		var length := 85+(x/10)%125
		draw_colored_polygon(PackedVector2Array([Vector2(x-34,0),Vector2(x+38,0),Vector2(x+8,length)]),Color("53666a"))
		draw_line(Vector2(x-18,8),Vector2(x+3,length*.72),Color("7e9693aa"),4,true)
	for x in range(LEFT_EDGE+350,RIGHT_EDGE,760):
		var glow := 8.0+sin(Time.get_ticks_msec()*.002+x)*2
		draw_circle(Vector2(x,690),glow,Color("72c7cbaa"))
	# Rocha escura substitui a terra do bosque sem sugerir piso de gelo.
	for rect in CAVE_PLATFORMS: _draw_cave_ground(rect)
	# Portais internos têm moldura mineral e névoa baixa.
	for point in [START,EXIT]:
		draw_set_transform(point+Vector2(0,-45),0,Vector2(.8,1.15))
		draw_circle(Vector2.ZERO,58,Color("617074"))
		draw_circle(Vector2(0,4),47,Color(0.18,0.39,0.43,.72))
		draw_arc(Vector2.ZERO,54,0,TAU,32,Color("91aaa4"),6,true)
		draw_set_transform(Vector2.ZERO)

func _draw_cave_ground(rect: Rect2) -> void:
	draw_rect(rect,Color("20333b"))
	# A faixa superior mantém o percurso legível e tem aparência de pedra úmida.
	draw_colored_polygon(PackedVector2Array([
		Vector2(rect.position.x,rect.position.y),Vector2(rect.end.x,rect.position.y),
		Vector2(rect.end.x,rect.position.y+20),Vector2(rect.position.x,rect.position.y+16)]),Color("29424b"))
	draw_line(rect.position,Vector2(rect.end.x,rect.position.y),Color("55747a"),5,true)
	var first_x := int(rect.position.x)+46
	for x in range(first_x,int(rect.end.x)-18,118):
		var available_depth := maxi(32,int(rect.size.y)-26)
		var depth := 38+int(x/7)%available_depth
		var y := minf(rect.end.y-12,rect.position.y+depth)
		draw_polyline(PackedVector2Array([Vector2(x-18,y-5),Vector2(x,y),Vector2(x+24,y-8)]),Color("3c5660aa"),3,true)
	for x in range(int(rect.position.x)+70,int(rect.end.x)-20,210):
		draw_set_transform(Vector2(x,rect.position.y+10),0,Vector2(1.5,.42))
		draw_circle(Vector2.ZERO,7,Color("76909766"))
		draw_set_transform(Vector2.ZERO)

func _draw_bat_shadow(center: Vector2, size: float, alpha: float) -> void:
	var flap := sin(Time.get_ticks_msec()*.009+center.x*.01)*7.0
	var color := Color(0.015,0.025,0.045,alpha)
	draw_set_transform(center,0,Vector2(size,size))
	draw_circle(Vector2.ZERO,8,color)
	draw_colored_polygon(PackedVector2Array([Vector2(-5,-2),Vector2(-27,-13-flap),Vector2(-47,-4),Vector2(-28,8+flap),Vector2(-8,5)]),color)
	draw_colored_polygon(PackedVector2Array([Vector2(5,-2),Vector2(27,-13-flap),Vector2(47,-4),Vector2(28,8+flap),Vector2(8,5)]),color)
	draw_set_transform(Vector2.ZERO)
