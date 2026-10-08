extends Node2D
## Área secundária de 1-4: refúgio úmido escondido atrás da cachoeira.
const ENTRY := Vector2(18400,520)
const RETURN := Vector2(24600,760)
const LEFT_EDGE := 72000
const RIGHT_EDGE := 78200
const START := Vector2(72180,760)
const EXIT := Vector2(77930,680)
const RIVER_EXIT := Vector2(77930,525)
const PORTAL_STYLE_VERSION := 1
const BACKGROUND_STYLE_VERSION := 1
const TERRAIN_STYLE_VERSION := 2
const RIVER_CAVE_STYLE_VERSION := 2
const GROTTO_BACKGROUND = preload("res://assets/environment/waterfall_grotto_background.png")
const RIVER_CAVE_BACKGROUND = preload("res://assets/environment/river_cave_background.png")
const RIVER_ENTRY := Vector2(18418,720)
const GROTTO_PLATFORMS := [
	Rect2(72000,760,6200,220), Rect2(72450,680,420,80), Rect2(73050,600,500,160),
	Rect2(73750,680,420,80), Rect2(74350,600,520,160), Rect2(75080,680,420,80),
	Rect2(75650,600,500,160), Rect2(76350,680,420,80), Rect2(77000,600,520,160),
	Rect2(77680,680,420,80)
]
const RIVER_CAVE_PLATFORMS := [
	# Degraus de 120–160 px formam uma rota vertical para Tico. Pipo consegue
	# explorar o piso inicial, mas precisa dar lugar ao companheiro para avançar.
	Rect2(72000,760,760,220), Rect2(72920,645,430,315),
	Rect2(73520,525,500,435), Rect2(74210,645,430,315),
	Rect2(74840,525,520,435), Rect2(75580,645,430,315),
	Rect2(76200,525,500,435), Rect2(76920,645,430,315),
	Rect2(77520,525,680,435)
]
var level: Node2D
var active := false
var checkpoint := false
var transitioning := false
var river_cave := false
var veil: ColorRect
var hints: Array[Label] = []

func build() -> void:
	river_cave = level.get("biome")==2 and level.get("section")==0
	var cave_platforms: Array = RIVER_CAVE_PLATFORMS if river_cave else GROTTO_PLATFORMS
	for rect in cave_platforms: level._platform(rect)
	for rect in [Rect2(LEFT_EDGE-50,-200,50,1300),Rect2(RIGHT_EDGE,-200,50,1300)]: level._solid("WaterfallGrottoBoundary",rect,Color.TRANSPARENT)
	if river_cave:
		_build_river_cave_contents()
	else:
		_build_waterfall_contents()
	level._golden_nut(Vector2(77250,601 if river_cave else 556),"refugio_cachoeira_14")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:refugio_cachoeira_14")
	_add_hint(entry_point(),"Caverna do Rio\nAÇÃO para entrar" if river_cave else "Refúgio da Cachoeira\nAÇÃO para atravessar",true)
	_add_hint(START,"Voltar à trilha • Ação",false)
	_add_hint(exit_point(),"Saída pela água • Ação",false)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("15363b")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _build_waterfall_contents() -> void:
	for row in [[72220,716,4],[72520,636,4],[73120,556,5],[73810,636,4],[74420,556,5],[75120,636,4],[75720,556,5],[76400,636,4],[77060,556,5],[77720,636,4]]:
		for i in int(row[2]): _nut(Vector2(row[0]+i*72,row[1]))
	for entry in [[72800,712,0],[73500,712,1],[74700,552,2],[75400,712,0],[76700,712,1],[77400,552,2]]: _food(Vector2(entry[0],entry[1]),entry[2])
	for point in [Vector2(74150,636),Vector2(76000,636),Vector2(77500,636)]: _nut(point,true)
	_add_enemy("slug",Vector2(72820,680),90)
	_add_enemy("beetle",Vector2(73950,680),105)
	_add_enemy("bat",Vector2(74750,390),0)
	_add_enemy("slug",Vector2(75300,680),90)
	_add_enemy("crow",Vector2(76100,470),0)
	_add_enemy("beetle",Vector2(77300,600),95)

func _build_river_cave_contents() -> void:
	var ledges := [
		[72180,716,6],[72955,601,5],[73555,481,6],[74245,601,5],
		[74875,481,6],[75615,601,5],[76235,481,6],[76955,601,5],[77555,481,7]
	]
	for row in ledges:
		for i in int(row[2]): _nut(Vector2(row[0]+i*66,row[1]))
	for entry in [[72490,712,0],[73200,597,1],[73820,477,2],[75140,477,0],[75820,597,1],[76500,477,2],[77830,477,0]]:
		_food(Vector2(entry[0],entry[1]),entry[2])
	for point in [Vector2(73300,601),Vector2(75300,481),Vector2(77180,601)]: _nut(point,true)
	_add_enemy("slug",Vector2(72480,760),90)
	_add_enemy("beetle",Vector2(73120,645),80)
	_add_enemy("bat",Vector2(73920,300),0)
	_add_enemy("slug",Vector2(75080,525),90)
	_add_enemy("crow",Vector2(75950,330),0)
	_add_enemy("beetle",Vector2(77120,645),85)

func _nut(point: Vector2, healing := false) -> void:
	level._nut(point,healing)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","waterfall:%d:%d" % [point.x,point.y])

func _food(point: Vector2, kind: int) -> void:
	level._food(point,kind)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","waterfall-food:%d:%d" % [point.x,point.y])

func _add_enemy(kind: String, point: Vector2, travel: float) -> void:
	var enemy: Node2D
	match kind:
		"slug": enemy = level._slug(point,travel)
		"beetle": enemy = level._beetle(point,travel)
		"bat":
			enemy = preload("res://scripts/enemies/sky_enemy.gd").new()
			enemy.level = level
			enemy.position = point
			level.actors.add_child(enemy)
			enemy.stomped.connect(level._on_stomp)
		_:
			enemy = preload("res://scripts/enemies/crow.gd").new()
			enemy.level = level
			enemy.position = point
			level.actors.add_child(enemy)
			enemy.stomped.connect(level._on_stomp)
	enemy.set_meta("waterfall_grotto_enemy",true)
	if level.get("biome")==2 and level.get("section")==0:
		enemy.set_meta("pipo_one_hit",true)

func _add_hint(point: Vector2, message: String, entry: bool) -> void:
	var label := Label.new()
	label.text = message
	label.position = point+Vector2(-180,-150 if entry else -120)
	label.size.x = 360
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",19)
	label.add_theme_color_override("font_color",Color("effff1"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("173b3cdd")
	style.border_color = Color("8bd7c1")
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	label.add_theme_stylebox_override("normal",style)
	label.set_meta("portal_point",point)
	label.set_meta("entry_portal",entry)
	label.hide()
	add_child(label)
	hints.append(label)

func _physics_process(delta: float) -> void:
	# O cenário e o terreno são estáticos: não redesenhá-los a cada quadro evita
	# reconstruir milhares de pixels e comandos enquanto o jogador explora a gruta.
	var _unused_delta := delta
	for hint in hints:
		hint.visible = not transitioning and not level.completed and not level.respawning and level.tico.position.distance_to(hint.get_meta("portal_point"))<(180 if hint.get_meta("entry_portal") else 115)
	if transitioning or level.completed or level.respawning: return
	if active and level.tico.position.y>980:
		level.tico.take_damage(level.tico.position+Vector2(0,30))
		if level.tico.health>0: restore_player()
	if Input.is_action_just_pressed("action") and level.tico.is_on_floor():
		if not active and level.tico.position.distance_to(entry_point())<135: travel(true)
		elif active and (level.tico.position.distance_to(START)<115 or level.tico.position.distance_to(exit_point())<115): travel(false)

func travel(entering: bool) -> void:
	if transitioning or level.completed or level.respawning: return
	transitioning = true
	level.tico.controls_enabled = false
	level.touch.release_all()
	for action in ["move_left","move_right","move_down","jump","action","switch_character"]: Input.action_release(action)
	var tween := create_tween()
	tween.tween_property(veil,"modulate:a",1.0,.18)
	tween.tween_callback(func():
		active=entering
		apply_camera()
		level.sounds.set_environment("night" if entering else "forest")
		level.tico.reset_at(START if entering else RETURN)
		level.camera.snap_to_target()
		level._save_progress()
		level._say(("Caverna do Rio • siga os cristais entre as pedras" if river_cave else "Refúgio da Cachoeira • siga o brilho entre as pedras") if entering else "De volta à trilha, perto da bandeira"))
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
func entry_point() -> Vector2: return RIVER_ENTRY if river_cave else ENTRY
func exit_point() -> Vector2: return RIVER_EXIT if river_cave else EXIT
func restore(state: Dictionary) -> void:
	active = state.get("active",false) and not level.completed
	checkpoint = false
	restore_player()

func _draw() -> void:
	if river_cave:
		_draw_river_cave_entrance()
	else:
		# Portal principal: abertura rochosa, lâmina d'água e névoa deixam clara a passagem.
		draw_colored_polygon(PackedVector2Array([Vector2(18110,760),Vector2(18145,520),Vector2(18230,390),Vector2(18400,345),Vector2(18570,390),Vector2(18655,520),Vector2(18690,760)]),Color("42554b"))
		draw_circle(Vector2(18400,570),150,Color("15363b"))
		for stripe in 11:
			var x := 18262+stripe*27
			draw_rect(Rect2(x,385,16,330),Color(0.48,0.87,0.91,.31))
			draw_line(Vector2(x+8,400),Vector2(x+4,700),Color(0.80,1.0,1.0,.38),3,true)
		for i in 7:
			draw_circle(Vector2(18240+i*54,715+(i%2)*7),42,Color(0.72,0.95,0.91,.10))
	# A ilustração cobre todo o refúgio, em painéis contínuos e sem colisões falsas.
	var area_background: Texture2D = RIVER_CAVE_BACKGROUND if river_cave else GROTTO_BACKGROUND
	for panel in 4:
		draw_texture_rect(area_background,Rect2(LEFT_EDGE+panel*1600,0,1600,760),false,Color("d0ece4"))
	draw_rect(Rect2(LEFT_EDGE,0,RIGHT_EDGE-LEFT_EDGE,760),Color(0.02,0.12,0.13,.18))
	var cave_platforms: Array = RIVER_CAVE_PLATFORMS if river_cave else GROTTO_PLATFORMS
	for rect in cave_platforms: _draw_grotto_ground(rect)
	for point in [START,exit_point()]:
		draw_circle(point+Vector2(0,-43),62,Color("345b55"))
		draw_circle(point+Vector2(0,-43),49,Color(0.35,0.76,0.72,.48))
		for stripe in 6:
			draw_line(point+Vector2(-36+stripe*14,-88),point+Vector2(-40+stripe*14,8),Color(0.74,0.97,0.91,.30),5,true)

func _draw_river_cave_entrance() -> void:
	var center := RIVER_ENTRY
	# O maciço encontra o piso em toda a base; não há fresta que faça a
	# entrada parecer flutuar. As pedras em camadas formam uma boca reconhecível.
	draw_colored_polygon(PackedVector2Array([
		center+Vector2(-300,40),center+Vector2(-286,-80),center+Vector2(-230,-205),
		center+Vector2(-135,-286),center+Vector2(0,-315),center+Vector2(145,-280),
		center+Vector2(240,-190),center+Vector2(295,-65),center+Vector2(310,40)
	]),Color("263a3d"))
	draw_circle(center+Vector2(0,-92),170,Color("132c31"))
	draw_rect(Rect2(center+Vector2(-170,-92),Vector2(340,132)),Color("132c31"))
	# Grandes blocos angulares formam um arco mineral legível como caverna.
	for stone in [Vector2(-238,-62),Vector2(-205,-165),Vector2(-135,-248),Vector2(-38,-292),Vector2(66,-286),Vector2(160,-232),Vector2(224,-145),Vector2(255,-48)]:
		draw_colored_polygon(PackedVector2Array([
			center+stone+Vector2(-58,34),center+stone+Vector2(-48,-25),
			center+stone+Vector2(-12,-58),center+stone+Vector2(42,-45),
			center+stone+Vector2(62,8),center+stone+Vector2(35,52)
		]),Color("52686a"))
		draw_polyline(PackedVector2Array([center+stone+Vector2(-42,-18),center+stone+Vector2(-8,-43),center+stone+Vector2(39,-31)]),Color("82989a"),4,true)
	for i in 7:
		var mist := center+Vector2(-120+i*40,-25+(i%2)*12)
		draw_circle(mist,34,Color(0.58,0.84,0.78,.10))
	for x in [-235.0,-195.0,185.0,225.0]:
		draw_colored_polygon(PackedVector2Array([center+Vector2(x,20),center+Vector2(x+18,-8),center+Vector2(x+35,20)]),Color("638552"))

func _draw_grotto_ground(rect: Rect2) -> void:
	if river_cave:
		_draw_river_cave_ground(rect)
		return
	# Face profunda: verde-petróleo com base irregular, coerente com a luz da água.
	draw_rect(rect,Color("193631"))
	var bottom: float = rect.end.y
	var face := PackedVector2Array([Vector2(rect.position.x,rect.position.y+15)])
	var x := int(rect.position.x)
	while x<int(rect.end.x):
		face.append(Vector2(x,rect.position.y+16+((x/37)%3)*4))
		x += 72
	face.append(Vector2(rect.end.x,rect.position.y+18))
	face.append(Vector2(rect.end.x,bottom))
	face.append(Vector2(rect.position.x,bottom))
	draw_colored_polygon(face,Color("294842"))
	# Lajes quebradas escondem a geometria retangular sem mudar a colisão aprovada.
	for slab_x in range(int(rect.position.x),int(rect.end.x),148):
		var slab_end := minf(slab_x+152,rect.end.x)
		var dip := 22.0+float((slab_x/31)%3)*3.0
		draw_colored_polygon(PackedVector2Array([
			Vector2(slab_x,rect.position.y+3),Vector2(slab_x+22,rect.position.y-2),
			Vector2(slab_end-28,rect.position.y),Vector2(slab_end,rect.position.y+5),
			Vector2(slab_end-12,rect.position.y+dip),Vector2(slab_x+18,rect.position.y+dip+4)
		]),Color("52766b"))
		draw_line(Vector2(slab_x+18,rect.position.y+dip+4),Vector2(slab_end-12,rect.position.y+dip),Color("365b52"),2,true)
	# Musgo descontínuo, brilho úmido e rachaduras dão profundidade com poucos traços.
	for detail_x in range(int(rect.position.x)+42,int(rect.end.x)-20,196):
		var top_y := rect.position.y-float((detail_x/29)%3)
		draw_polyline(PackedVector2Array([
			Vector2(detail_x-25,top_y+4),Vector2(detail_x-9,top_y-5),
			Vector2(detail_x+10,top_y+1),Vector2(detail_x+31,top_y-4)
		]),Color("557a45"),7,true)
		draw_line(Vector2(detail_x-18,top_y+8),Vector2(detail_x+26,top_y+5),Color(0.44,0.72,0.66,.50),2,true)
		if rect.size.y>65:
			draw_polyline(PackedVector2Array([
				Vector2(detail_x+38,rect.position.y+37),Vector2(detail_x+28,rect.position.y+57),
				Vector2(detail_x+42,rect.position.y+73)
			]),Color("182d2b"),3,true)

func _draw_river_cave_ground(rect: Rect2) -> void:
	# Ardósia azul-escura conecta o piso às paredes da pintura, enquanto a
	# borda turquesa separa com clareza a superfície jogável do lago ao fundo.
	draw_rect(rect,Color("172c35"))
	draw_rect(Rect2(rect.position,Vector2(rect.size.x,18)),Color("3f6468"))
	draw_line(rect.position+Vector2(0,2),Vector2(rect.end.x,rect.position.y+2),Color("88aaa0"),3,true)
	for x in range(int(rect.position.x)+18,int(rect.end.x),112):
		var width := minf(118.0,rect.end.x-x+8.0)
		draw_colored_polygon(PackedVector2Array([
			Vector2(x,rect.position.y+18),Vector2(x+width*.42,rect.position.y+12),
			Vector2(x+width,rect.position.y+19),Vector2(x+width-12,rect.position.y+43),
			Vector2(x+13,rect.position.y+47)
		]),Color("294852"))
		if rect.size.y>90:
			draw_polyline(PackedVector2Array([
				Vector2(x+32,rect.position.y+62),Vector2(x+19,rect.position.y+82),
				Vector2(x+38,rect.position.y+102)
			]),Color("0e222a"),3,true)
	for x in range(int(rect.position.x)+55,int(rect.end.x),245):
		draw_line(Vector2(x,rect.position.y+9),Vector2(x+44,rect.position.y+7),Color(0.45,0.75,0.70,.45),3,true)
