extends Node2D
## Área secundária de 2-3: galeria de drenagem sob a Grande Ponte.

const ENTRY := Vector2(18400,720)
const RETURN := Vector2(24380,720)
const LEFT_EDGE := 90000
const RIGHT_EDGE := 96000
const START := Vector2(90180,755)
const EXIT := Vector2(95700,680)
const STYLE_VERSION := 1
const BACKGROUND = preload("res://assets/environment/river_cave_background.png")
const PLATFORMS := [
	Rect2(90000,760,760,220),Rect2(90920,680,520,300),Rect2(91600,600,500,380),
	Rect2(92280,680,480,300),Rect2(92920,560,560,420),Rect2(93640,680,460,300),
	Rect2(94280,600,520,380),Rect2(94960,680,420,300),Rect2(95520,680,480,300)
]

var level: Node2D
var active := false
var checkpoint := false
var transitioning := false
var veil: ColorRect
var hints: Array[Label] = []

func build() -> void:
	for rect in PLATFORMS: level._platform(rect)
	for rect in [Rect2(LEFT_EDGE-50,-200,50,1300),Rect2(RIGHT_EDGE,-200,50,1300)]:
		level._solid("StormDrainBoundary",rect,Color.TRANSPARENT)
	for row in [[90200,715,6],[90980,635,6],[91660,555,6],[92340,635,6],[92980,515,7],[93700,635,5],[94340,555,6],[95010,635,5],[95570,635,5]]:
		for i in int(row[2]): _nut(Vector2(row[0]+i*68,row[1]))
	for item in [[90480,712,0],[91240,632,1],[91920,552,2],[93250,512,0],[93920,632,1],[94600,552,2],[95650,632,0]]:
		_food(Vector2(item[0],item[1]),item[2])
	for point in [Vector2(92000,555),Vector2(93400,515),Vector2(95200,635)]: _nut(point,true)
	level._golden_nut(Vector2(94620,555),"galeria_tempestade_23")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:galeria_tempestade_23")
	_add_enemy("slug",Vector2(90480,760),82)
	_add_enemy("beetle",Vector2(91220,680),82)
	_add_enemy("bat",Vector2(91920,345),0)
	_add_enemy("armored",Vector2(93300,560),75)
	_add_enemy("bat",Vector2(94400,330),0)
	_add_enemy("slug",Vector2(95150,680),82)
	_add_enemy("beetle",Vector2(92520,680),95)
	_add_enemy("slug",Vector2(93840,680),90)
	_add_enemy("armored",Vector2(94520,600),82)
	_add_enemy("bat",Vector2(95280,390),0)
	_add_hint(ENTRY,"Galeria da Tempestade\nAÇÃO para entrar",true)
	_add_hint(START,"Voltar à ponte • AÇÃO",false)
	_add_hint(EXIT,"Saída da galeria • AÇÃO",false)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("102b36")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _nut(point: Vector2, healing := false) -> void:
	level._nut(point,healing)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","storm-nut:%d:%d" % [point.x,point.y])

func _food(point: Vector2, kind: int) -> void:
	level._food(point,kind)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","storm-food:%d:%d" % [point.x,point.y])

func _add_enemy(kind: String, point: Vector2, travel: float) -> void:
	var enemy: Node2D
	if kind=="slug": enemy = level._slug(point,travel)
	elif kind=="beetle": enemy = level._beetle(point,travel)
	elif kind=="armored": enemy = level._armored_enemy(point,travel)
	else:
		enemy = preload("res://scripts/enemies/sky_enemy.gd").new()
		enemy.level = level
		enemy.position = point
		level.actors.add_child(enemy)
		enemy.stomped.connect(level._on_stomp)
	enemy.set_meta("storm_drain_enemy",true)

func _add_hint(point: Vector2, message: String, entry: bool) -> void:
	var label := Label.new()
	label.text = message
	label.position = point+Vector2(-175,-145 if entry else -120)
	label.size.x = 350
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",19)
	label.add_theme_color_override("font_color",Color("e7f5f5"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("153541ee")
	style.border_color = Color("83b9bf")
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

func _physics_process(_delta: float) -> void:
	if not active and not transitioning and level.tico.position.distance_to(ENTRY)>=900.0:
		for hint in hints: hint.hide()
		return
	for hint in hints:
		hint.visible = not transitioning and not level.completed and not level.respawning and level.tico.position.distance_to(hint.get_meta("portal_point"))<(175 if hint.get_meta("entry_portal") else 115)
	if transitioning or level.completed or level.respawning: return
	if active and level.tico.position.y>980:
		level.tico.take_damage(level.tico.position+Vector2(0,30))
		if level.tico.health>0: restore_player()
	if Input.is_action_just_pressed("action") and level.tico.is_on_floor():
		if not active and level.tico.position.distance_to(ENTRY)<130: travel(true)
		elif active and (level.tico.position.distance_to(START)<115 or level.tico.position.distance_to(EXIT)<115): travel(false)

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
		queue_redraw()
		_set_main_scenery_enabled(not entering)
		apply_camera()
		level.sounds.set_environment("night" if entering else "forest")
		level.tico.reset_at(START if entering else RETURN)
		level.camera.snap_to_target()
		level._save_progress()
		level._say("Galeria da Tempestade • avance pelos canais frios" if entering else "De volta à ponte, perto da bandeira"))
	tween.tween_property(veil,"modulate:a",0.0,.18)
	tween.tween_callback(func(): level.tico.controls_enabled=true; transitioning=false)

func apply_camera() -> void:
	level.camera.limit_left = LEFT_EDGE if active else 0
	level.camera.limit_right = RIGHT_EDGE if active else level.main_right

func restore_player() -> void:
	_set_main_scenery_enabled(not active)
	apply_camera()
	if active: level.tico.reset_at(START)
	level.camera.snap_to_target()

func snapshot() -> Dictionary: return {"active":active,"checkpoint":false}
func restore(state: Dictionary) -> void:
	active = state.get("active",false) and not level.completed
	checkpoint = false
	queue_redraw()
	restore_player()

func _set_main_scenery_enabled(enabled: bool) -> void:
	var main_scenery: Node = level.get("scenery")
	if not is_instance_valid(main_scenery): return
	main_scenery.visible = enabled
	main_scenery.set_process(enabled)

func _draw() -> void:
	if active: _draw_gallery()
	else: _draw_entrance()

func _draw_entrance() -> void:
	# Bueiro de pedra com água e brilho azul: passagem legível sem parecer árvore/caverna.
	draw_circle(ENTRY+Vector2(0,-70),145,Color("40545a"))
	draw_circle(ENTRY+Vector2(0,-65),105,Color("112b35"))
	draw_rect(Rect2(ENTRY+Vector2(-105,-65),Vector2(210,65)),Color("112b35"))
	for i in 7:
		var x := ENTRY.x-78+i*26
		draw_line(Vector2(x,ENTRY.y-150),Vector2(x,ENTRY.y),Color("71898b"),7,true)
	draw_rect(Rect2(ENTRY+Vector2(-93,-16),Vector2(186,16)),Color(0.32,0.68,0.78,.55))
	for i in 6: draw_circle(ENTRY+Vector2(-75+i*30,-20-(i%2)*7),7,Color(0.70,0.92,0.96,.45))

func _draw_gallery() -> void:
	draw_rect(Rect2(LEFT_EDGE,-150,RIGHT_EDGE-LEFT_EDGE,1150),Color("10252d"))
	# Paisagem rochosa e água subterrânea dão profundidade atrás do aqueduto.
	# O modo tile repete a textura em uma única chamada, sem criar nós por painel.
	draw_texture_rect(BACKGROUND,Rect2(LEFT_EDGE,-150,RIGHT_EDGE-LEFT_EDGE,1150),true,Color("789ba2"))
	draw_rect(Rect2(LEFT_EDGE,-150,RIGHT_EDGE-LEFT_EDGE,1150),Color(0.02,0.10,0.14,.48))
	# Arcos repetidos formam um aqueduto contínuo e evitam emendas de bitmap.
	for x in range(LEFT_EDGE-80,RIGHT_EDGE+200,420):
		draw_circle(Vector2(x+210,310),235,Color("293f46"))
		draw_circle(Vector2(x+210,330),190,Color("142d35"))
		draw_rect(Rect2(x+20,310,380,500),Color("142d35"))
		draw_line(Vector2(x+15,310),Vector2(x+15,810),Color("50666a"),12,true)
		draw_line(Vector2(x+405,310),Vector2(x+405,810),Color("50666a"),12,true)
	for x in range(LEFT_EDGE+80,RIGHT_EDGE,260):
		draw_line(Vector2(x,0),Vector2(x-20,105+(x/13)%120),Color(0.58,0.82,0.87,.40),3,true)
	for rect in PLATFORMS: _draw_wet_stone(rect)
	for point in [START,EXIT]:
		draw_circle(point+Vector2(0,-46),58,Color("36545b"))
		draw_circle(point+Vector2(0,-46),45,Color(0.30,0.72,0.78,.35))

func _draw_wet_stone(rect: Rect2) -> void:
	draw_rect(rect,Color("1d343b"))
	draw_rect(Rect2(rect.position,Vector2(rect.size.x,18)),Color("526d70"))
	draw_line(rect.position+Vector2(0,2),Vector2(rect.end.x,rect.position.y+2),Color("9bc5c5"),3,true)
	for x in range(int(rect.position.x)+20,int(rect.end.x),115):
		draw_colored_polygon(PackedVector2Array([Vector2(x,rect.position.y+18),Vector2(x+50,rect.position.y+12),Vector2(x+105,rect.position.y+22),Vector2(x+90,rect.position.y+50),Vector2(x+10,rect.position.y+46)]),Color("2e4a50"))
