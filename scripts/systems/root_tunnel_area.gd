extends Node2D
## Área secundária de 2-2: túnel de raízes úmido sob a margem do rio.

const ENTRY := Vector2(18400,720)
const RETURN := Vector2(24600,680)
const LEFT_EDGE := 80000
const RIGHT_EDGE := 85800
const START := Vector2(80180,755)
const EXIT := Vector2(85540,680)
const PERFORMANCE_STYLE_VERSION := 1
const BACKGROUND = preload("res://assets/environment/river_cave_background.png")
const PLATFORMS := [
	Rect2(80000,760,760,220),Rect2(80920,680,420,300),
	Rect2(81520,600,500,380),Rect2(82220,680,420,300),
	Rect2(82820,590,520,390),Rect2(83560,680,430,300),
	Rect2(84180,600,500,380),Rect2(84880,680,320,300),
	Rect2(85360,680,440,300)
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
		level._solid("RootTunnelBoundary",rect,Color.TRANSPARENT)
	for row in [[80210,715,5],[80970,635,5],[81570,555,6],[82270,635,5],[82870,545,6],[83610,635,5],[84230,555,6],[84920,635,4],[85400,635,4]]:
		for i in int(row[2]): _nut(Vector2(row[0]+i*68,row[1]))
	for entry in [[80480,712,0],[81200,632,1],[81850,552,2],[83150,542,0],[83900,632,1],[84520,552,2],[85500,632,0]]:
		_food(Vector2(entry[0],entry[1]),entry[2])
	for point in [Vector2(81780,555),Vector2(83300,545),Vector2(85020,635)]: _nut(point,true)
	level._golden_nut(Vector2(84500,555),"tunel_raizes_22")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:tunel_raizes_22")
	_add_enemy("slug",Vector2(80480,760),85)
	_add_enemy("beetle",Vector2(81180,680),85)
	_add_enemy("bat",Vector2(81920,350),0)
	_add_enemy("slug",Vector2(83080,590),90)
	_add_enemy("bat",Vector2(84020,330),0)
	_add_enemy("beetle",Vector2(85100,680),80)
	_add_hint(ENTRY,"Túnel das Raízes\nAÇÃO para entrar",true)
	_add_hint(START,"Voltar à margem • Ação",false)
	_add_hint(EXIT,"Saída entre as raízes • Ação",false)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("112d31")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _nut(point: Vector2, healing := false) -> void:
	level._nut(point,healing)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","root-tunnel:%d:%d" % [point.x,point.y])

func _food(point: Vector2, kind: int) -> void:
	level._food(point,kind)
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","root-food:%d:%d" % [point.x,point.y])

func _add_enemy(kind: String, point: Vector2, travel: float) -> void:
	var enemy: Node2D
	if kind=="slug": enemy = level._slug(point,travel)
	elif kind=="beetle": enemy = level._beetle(point,travel)
	else:
		enemy = preload("res://scripts/enemies/sky_enemy.gd").new()
		enemy.level = level
		enemy.position = point
		level.actors.add_child(enemy)
		enemy.stomped.connect(level._on_stomp)
	enemy.set_meta("root_tunnel_enemy",true)

func _add_hint(point: Vector2, message: String, entry: bool) -> void:
	var label := Label.new()
	label.text = message
	label.position = point+Vector2(-175,-145 if entry else -120)
	label.size.x = 350
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",19)
	label.add_theme_color_override("font_color",Color("eef4d5"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("173735e8")
	style.border_color = Color("9ab66c")
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
		level._say("Túnel das Raízes • atravesse as pedras úmidas" if entering else "De volta às balsas, perto da bandeira"))
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
	if active:
		_draw_tunnel()
		return
	# Uma parede de raízes deixa uma abertura baixa, diferente das cavernas anteriores.
	draw_circle(ENTRY+Vector2(0,-82),165,Color("263a2c"))
	draw_circle(ENTRY+Vector2(0,-72),125,Color("102b2e"))
	draw_rect(Rect2(ENTRY+Vector2(-125,-72),Vector2(250,72)),Color("102b2e"))
	for i in 9:
		var x := ENTRY.x-170+i*43
		draw_line(Vector2(x,ENTRY.y),Vector2(x+sin(i)*55,ENTRY.y-235-(i%3)*26),Color("65482f"),18,true)
		draw_line(Vector2(x+4,ENTRY.y),Vector2(x+sin(i)*55+4,ENTRY.y-235-(i%3)*26),Color("92704a"),4,true)
	for i in 7: draw_circle(ENTRY+Vector2(-100+i*34,-35+(i%2)*8),28,Color(0.45,0.78,0.65,.10))

func _draw_tunnel() -> void:
	draw_rect(Rect2(LEFT_EDGE,-120,RIGHT_EDGE-LEFT_EDGE,1120),Color("10272d"))
	var panel_width := (RIGHT_EDGE-LEFT_EDGE)/4.0
	for panel in 4:
		draw_texture_rect(BACKGROUND,Rect2(LEFT_EDGE+panel*panel_width,-120,panel_width,1120),false,Color("8daea1"))
	draw_rect(Rect2(LEFT_EDGE,-120,RIGHT_EDGE-LEFT_EDGE,1120),Color(0.03,0.12,0.12,.36))
	# Raízes no teto e pedras verde-ardósia diferenciam esta passagem.
	for x in range(LEFT_EDGE+120,RIGHT_EDGE,310):
		draw_line(Vector2(x,-20),Vector2(x+45,170+(x/31)%110),Color("4d4934"),15,true)
		draw_line(Vector2(x+4,-18),Vector2(x+49,165+(x/31)%110),Color("7d7250"),3,true)
	for rect in PLATFORMS: _draw_ground(rect)
	for point in [START,EXIT]:
		draw_circle(point+Vector2(0,-45),58,Color("3e5b4d"))
		draw_circle(point+Vector2(0,-45),46,Color(0.35,0.70,0.60,.42))

func _draw_ground(rect: Rect2) -> void:
	draw_rect(rect,Color("182f35"))
	draw_rect(Rect2(rect.position,Vector2(rect.size.x,18)),Color("49645b"))
	draw_line(rect.position+Vector2(0,2),Vector2(rect.end.x,rect.position.y+2),Color("93ad7a"),3,true)
	for x in range(int(rect.position.x)+25,int(rect.end.x),120):
		draw_colored_polygon(PackedVector2Array([Vector2(x,rect.position.y+18),Vector2(x+45,rect.position.y+12),Vector2(x+105,rect.position.y+20),Vector2(x+92,rect.position.y+47),Vector2(x+12,rect.position.y+45)]),Color("294950"))
