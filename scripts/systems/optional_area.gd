extends Node2D
## Protótipo de área secundária: identidade e pontos de retorno estáveis.
const SIDE_OFFSET := Vector2(54100,0)
const ENTRY := Vector2(21000,340)
const START := Vector2(6100,755)+SIDE_OFFSET
const FLAG := Vector2(6550,655)+SIDE_OFFSET
const EXIT := Vector2(7350,360)+SIDE_OFFSET
const FAR_EXIT := Vector2(9580,460)+SIDE_OFFSET
const RIGHT_EDGE := 64000
const LIFE_ID := "copa_life"
const PORTAL_TREE = preload("res://assets/environment/canopy_portal_tree.png")
# A imagem possui uma pequena margem transparente sob as raízes. O deslocamento
# abaixo apoia a parte visível da árvore exatamente na plataforma de y=680.
const PORTAL_TREE_RECT := Rect2(20340,-565,1230,1278)
const PORTAL_MIST_CENTER := Vector2(20955,385)
const BRANCHES := [Rect2(1250,540,240,24),Rect2(1390,450,220,24),Rect2(1220,360,280,28),
	Rect2(6400,660,300,28),Rect2(6700,560,230,28),Rect2(6940,460,230,28),Rect2(7190,360,360,32),
	Rect2(7600,450,400,30),Rect2(8040,560,380,30),Rect2(8460,460,280,28),
	Rect2(8780,360,300,28),Rect2(9120,460,620,32),Rect2(8570,660,310,28)]
var level: Node2D
var active := false
var checkpoint := false
var transitioning := false
var flag: Area2D
var veil: ColorRect
var hints: Array[Label] = []
var bonus_life: Area2D
var slugs: Array[Node2D] = []

static func location(point: Vector2) -> Vector2:
	return point+SIDE_OFFSET if point.x>=5900 else point+Vector2(19660,0)

func area_nut(point: Vector2, healing := false) -> void:
	level._nut(location(point),healing)
	var item = level.actors.get_child(level.actors.get_child_count()-1)
	# IDs históricos: deslocar a área não recria recompensas já coletadas.
	item.set_meta("save_id","%d:%d" % [point.x,point.y])

func area_food(point: Vector2, kind: int) -> void:
	level._food(location(point),kind)
	var item = level.actors.get_child(level.actors.get_child_count()-1)
	item.set_meta("save_id","food:%d:%d" % [point.x,point.y])

func build() -> void:
	level._platform(Rect2(60000,760,4000,200))
	for rect in BRANCHES:
		var branch = level._solid("CopaBranch",Rect2(location(rect.position),rect.size),Color.TRANSPARENT)
		# Galhos da entrada permitem saltar por baixo, inclusive com o corpo de Pipo.
		if rect.position.x<5900: branch.get_node("Collision").one_way_collision = true
	for rect in [Rect2(59950,-300,50,1500),Rect2(RIGHT_EDGE,-300,50,1500)]:
		level._solid("CopaBoundary",rect,Color.TRANSPARENT)
	for point in [Vector2(6500,615),Vector2(6810,515),Vector2(7060,415),Vector2(7290,315)]: area_nut(point)
	for row in [[7690,405,4],[8130,515,3],[8520,415,3],[8840,315,3],[9320,415,3],[8620,615,3],[8030,715,3]]:
		for i in int(row[2]): area_nut(Vector2(row[0]+i*75,row[1]))
	for point in [Vector2(7970,405),Vector2(8700,615),Vector2(9500,415)]: area_nut(point,true)
	for entry in [[7750,405,1],[8350,515,0],[8580,415,2],[8990,315,1],[9180,415,0],[8800,615,2]]:
		area_food(Vector2(entry[0],entry[1]),entry[2])
	level._golden_nut(location(Vector2(9030,315)),"copa_01")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:copa_01")
	for point in [Vector2(7830,450),Vector2(8220,560),Vector2(9350,760)]:
		level._slug(location(point),65)
		slugs.append(level.actors.get_child(level.actors.get_child_count()-1))
	if LIFE_ID not in level.campaign.data.story.events:
		bonus_life = preload("res://scripts/objects/extra_life.gd").new()
		bonus_life.campaign = level.campaign
		bonus_life.stage_id = 0
		bonus_life.reward_id = LIFE_ID
		bonus_life.position = location(Vector2(9240,412))
		level.actors.add_child(bonus_life)
	for entry in [[ENTRY,"Portal da Copa\nAÇÃO para entrar"],[START+Vector2(0,5),"Voltar à trilha"],[EXIT,"Voltar à trilha"],[FAR_EXIT,"Voltar à trilha"]]:
		var label := Label.new()
		label.text = entry[1] if entry[0]==ENTRY else "%s • Ação" % entry[1]
		label.position = entry[0]+Vector2(-165,-145 if entry[0]==ENTRY else -120)
		label.size.x = 330
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size",19)
		label.add_theme_color_override("font_color",Color("244b37"))
		var style := StyleBoxFlat.new()
		style.bg_color = Color("fff0d8eb")
		style.set_corner_radius_all(12)
		style.content_margin_top = 7
		style.content_margin_bottom = 7
		label.add_theme_stylebox_override("normal",style)
		label.set_meta("portal_point",entry[0])
		label.set_meta("entry_portal",entry[0]==ENTRY)
		label.hide()
		add_child(label)
		hints.append(label)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("244b37")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _physics_process(_delta: float) -> void:
	queue_redraw()
	for hint in hints:
		var radius := 250.0 if hint.get_meta("entry_portal",false) else 115.0
		hint.visible = not transitioning and not level.completed and not level.respawning and level.tico.position.distance_to(hint.get_meta("portal_point"))<radius
	if transitioning or level.completed or level.respawning: return
	if active and level.tico.position.y>980:
		level.tico.take_damage(level.tico.position+Vector2(0,30))
		if level.tico.health>0: restore_player()
	if Input.is_action_just_pressed("action") and level.tico.is_on_floor():
		var point: Vector2 = level.tico.position
		if not active and point.distance_to(ENTRY)<95: travel(true)
		elif active and (point.distance_to(START)<95 or point.distance_to(EXIT)<95 or point.distance_to(FAR_EXIT)<95): travel(false)

func travel(entering: bool) -> void:
	if transitioning or level.completed or level.respawning: return
	transitioning = true
	level.tico.controls_enabled = false
	level.touch.release_all()
	for action in ["move_left","move_right","jump","action","switch_character"]: Input.action_release(action)
	var tween := create_tween()
	tween.tween_property(veil,"modulate:a",1.0,.16)
	tween.tween_callback(func():
		active = entering
		apply_camera()
		level.tico.reset_at(START if entering else ENTRY+Vector2(0,-5))
		level.tico.controls_enabled = false
		level.camera.snap_to_target()
		level._save_progress()
		level._say("Copa dos Segredos" if entering else "De volta à trilha"))
	tween.tween_property(veil,"modulate:a",0.0,.16)
	tween.tween_callback(func():
		level.tico.controls_enabled = true
		transitioning = false)

func apply_camera() -> void:
	level.camera.limit_left = 60000 if active else 0
	level.camera.limit_right = RIGHT_EDGE if active else level.main_right

func restore_player() -> void:
	apply_camera()
	if active: level.tico.reset_at(START)
	level.camera.snap_to_target()

func snapshot() -> Dictionary:
	return {"active":active,"checkpoint":checkpoint}

func restore(state: Dictionary) -> void:
	active = state.get("active",false) and not level.completed
	# Saves antigos com bandeira local continuam válidos; a copa usa sua entrada.
	checkpoint = false
	restore_player()

func _draw() -> void:
	var atlas := preload("res://scripts/presentation/atlas_library.gd")
	draw_texture_rect(PORTAL_TREE,PORTAL_TREE_RECT,false)
	# Névoa orgânica dentro do vão: comunica passagem sem parecer um aro de
	# tecnologia. Camadas lentas preservam a leitura da arte e do personagem.
	var mist_time := Time.get_ticks_msec()*.001
	for i in 6:
		var phase := mist_time*(.28+i*.035)+i*1.17
		var center := PORTAL_MIST_CENTER+Vector2(sin(phase)*34,cos(phase*.73)*24+i*5-13)
		draw_set_transform(center,0,Vector2(1.65+i*.08,.42+i*.035))
		draw_circle(Vector2.ZERO,34+i*3,Color(0.72,0.92,0.79,.075+i*.012))
		draw_set_transform(Vector2.ZERO)
	for i in 7:
		var phase := mist_time*.55+i*.9
		var mote := PORTAL_MIST_CENTER+Vector2(sin(phase)*95,55-fmod(mist_time*18+i*29,150))
		draw_circle(mote,2.5+sin(phase)*.8,Color("dff6c7aa"))
	# Silhuetas orgânicas e galhos finos; as superfícies jogáveis não mudam.
	for trunk in [Rect2(6520,370,100,390),Rect2(7210,140,110,620),
		Rect2(7770,200,100,560),Rect2(8620,270,110,490),Rect2(9400,170,125,590)]:
		trunk = Rect2(location(trunk.position),trunk.size)
		var x: float = trunk.position.x
		var y: float = trunk.position.y
		var w: float = trunk.size.x
		var h: float = trunk.size.y
		draw_colored_polygon(PackedVector2Array([Vector2(x-20,y+h),Vector2(x+8,y+h*.55),Vector2(x+15,y),Vector2(x+w-12,y-10),Vector2(x+w-4,y+h*.6),Vector2(x+w+25,y+h)]),Color("71583d"))
		draw_polyline(PackedVector2Array([Vector2(x+w*.4,y+15),Vector2(x+w*.3,y+h*.45),Vector2(x+w*.4,y+h-10)]),Color("a1815566"),8,true)
		for offset in [-90,10,105]: draw_texture_rect(atlas.frame("props",7),Rect2(trunk.position+Vector2(offset-60,-95+sin(offset)*12),Vector2(185,135)),false,Color("c9d9ad"))
	for branch in BRANCHES:
		branch = Rect2(location(branch.position),branch.size)
		var wood := StyleBoxFlat.new()
		wood.bg_color = Color("725437")
		wood.set_corner_radius_all(10)
		draw_style_box(wood,branch)
		draw_line(branch.position+Vector2(10,7),Vector2(branch.end.x-10,branch.position.y+7),Color("af9060"),3,true)
		for x in range(int(branch.position.x)+12,int(branch.end.x)-25,65):
			draw_texture_rect(atlas.frame("props",8),Rect2(x,branch.position.y-9,38,15),false,Color("bfcea9"))
	for point in [ENTRY,START+Vector2(0,5),EXIT,FAR_EXIT]:
		if point==ENTRY:
			var pulse := 42.0+sin(Time.get_ticks_msec()*.004)*4.0
			draw_arc(PORTAL_MIST_CENTER,pulse*1.9,PI*.12,PI*.88,40,Color("ffe7a088"),4,true)
			continue
		draw_set_transform(point+Vector2(0,-40),0,Vector2(.66,1))
		draw_circle(Vector2.ZERO,42,Color("72583e"))
		draw_circle(Vector2(0,2),34,Color("314d40"))
		draw_arc(Vector2.ZERO,38,PI*.95,TAU*.94,32,Color("9a8158"),3,true)
		draw_set_transform(Vector2.ZERO)
		for offset in [-32,4]: draw_texture_rect(atlas.frame("props",8),Rect2(point+Vector2(offset,-12),Vector2(34,15)),false)
		draw_texture_rect(atlas.frame("props",8),Rect2(point+Vector2(-23,-86),Vector2(48,20)),false,Color("cbd6aa"))
