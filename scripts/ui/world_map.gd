extends Control
## Paisagem ilustrada; controles, caminhos e personagens acompanham o progresso.
const WORLDS = ["Bosque das Folhas","Rio das Pedras","Montanha das Corujas","Vila dos Castores"]
const BACKGROUNDS = ["res://assets/map/forest.png","res://assets/map/river.png","res://assets/map/mountain.png","res://assets/map/village.png"]
const NAMES = ["Primeiros Passos","Blocos e Segredos","Um Novo Amigo","Periquito do Bosque",
	"Atravessando o Rio","Correnteza","A Grande Ponte","Guardião do Rio",
	"Vento nas Alturas","Cavernas da Montanha","O Ninho das Corujas","Encontro na Montanha",
	"A Vila Mecânica","A Grande Barragem","As Engrenagens","Rei Castor"]
const POINTS = [Vector2(.22,.58),Vector2(.43,.40),Vector2(.64,.56),Vector2(.84,.40)]
var campaign: Node
var world := 0
var selected := 0
var summary: Dictionary
var nodes: Array[Button] = []
var title: Label
var subtitle: Label
var description: Label
var detail: Label
var progress: Label
var notice: Label
var primary: Button
var back: Button
var previous_world: Button
var next_world: Button
var village_button: Button
var village_view: Control
var ambience: Control
var squirrel: TextureRect
var companion: TextureRect
var sound: AudioStreamPlayer
var backdrop: Texture2D
var board := Rect2()
var header := Rect2()
var footer := Rect2()
var _time := 0.0
var _actor_point := Vector2.ZERO
var _travel: Tween
var _walking := false
var _walk_distance := 0.0

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or campaign._map_portrait(): return
	var direction := 0
	if event.keycode in [KEY_RIGHT,KEY_UP]: direction = 1
	elif event.keycode in [KEY_LEFT,KEY_DOWN]: direction = -1
	if direction==0: return
	get_viewport().set_input_as_handled()
	if _walking: return
	var target := selected+direction
	if target<0 or target>int(campaign.data.unlocked): return
	move_to_stage(target)

func move_to_stage(index: int) -> void:
	if index<0 or index>int(campaign.data.unlocked): return
	var origin := _actor_point
	var same_world := world==index/4 and squirrel.visible
	if is_instance_valid(_travel): _travel.kill()
	focus_stage(index)
	var destination := _actor_point
	if same_world and origin.is_equal_approx(destination):
		_walking = false
		primary.grab_focus()
		return
	if not same_world:
		origin = destination+Vector2(-160 if index%4==0 else 160,0)
	var curve := Curve2D.new()
	var distance := destination.x-origin.x
	curve.add_point(origin,Vector2.ZERO,Vector2(distance*.48,0))
	curve.add_point(destination,Vector2(-distance*.48,0),Vector2.ZERO)
	squirrel.flip_h = distance<0
	companion.flip_h = distance<0
	_actor_point = origin
	_walk_distance = 0.0
	_walking = true
	position_characters()
	_travel = create_tween()
	_travel.tween_method(func(weight: float):
		var next_point := curve.sample_baked(curve.get_baked_length()*weight)
		_walk_distance += _actor_point.distance_to(next_point)
		_actor_point = next_point
		position_characters()
		queue_redraw(),0.0,1.0,clampf(curve.get_baked_length()/420.0,.45,.95)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_travel.tween_callback(func():
		_walking = false
		_actor_point = destination
		position_characters()
		queue_redraw())
	primary.grab_focus()
	play_selection()

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	selected = int(campaign.data.survival.return_stage) if campaign.awaiting_return() else int(campaign.data.stage)
	world = selected/4
	backdrop = load(BACKGROUNDS[world])
	ambience = preload("res://scripts/ui/map_ambience.gd").new()
	add_child(ambience)
	title = label("",30)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle = label("",16)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress = label("",20)
	progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress.add_theme_color_override("font_color",Color("fff0cc"))
	description = label("",27)
	detail = label("",20)
	notice = label("",22)
	notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	previous_world = button("<")
	previous_world.tooltip_text = "Mundo anterior"
	previous_world.pressed.connect(func(): select_world(posmod(world-1,4)))
	next_world = button(">")
	next_world.tooltip_text = "Próximo mundo"
	next_world.pressed.connect(func(): select_world((world+1)%4))
	village_button = button("Visitar vilarejo")
	village_button.tooltip_text = "Veja como suas provisões estão mudando o vilarejo"
	village_button.pressed.connect(open_village)
	for i in 4:
		var node := preload("res://scripts/ui/map_marker.gd").new()
		node.pressed.connect(select_stage.bind(i))
		add_child(node)
		nodes.append(node)
	squirrel = portrait("tico",Vector2(116,92))
	companion = portrait("pipo",Vector2(102,82))
	primary = button("")
	primary.add_theme_stylebox_override("normal",box(Color("315c47"),Color("edd596")))
	primary.add_theme_stylebox_override("hover",box(Color("416f52"),Color("fff0ae")))
	primary.add_theme_stylebox_override("pressed",box(Color("244936"),Color("edd596")))
	for key in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]: primary.add_theme_color_override(key,Color("fff1d0"))
	primary.pressed.connect(func(): campaign.enter_from_map(selected))
	back = button("Fase atual")
	back.pressed.connect(func(): campaign.close_map())
	sound = AudioStreamPlayer.new()
	sound.stream = preload("res://assets/audio/slice/interface.wav")
	sound.volume_db = -18
	add_child(sound)
	resized.connect(layout)
	refresh()
	primary.grab_focus()

func open_village() -> void:
	if is_instance_valid(village_view): return
	village_view = preload("res://scripts/ui/village_view.gd").new()
	village_view.campaign = campaign
	village_view.z_index = 100
	village_view.closed.connect(close_village)
	add_child(village_view)
	play_selection()

func close_village() -> void:
	if not is_instance_valid(village_view): return
	village_view.queue_free()
	village_view = null
	village_button.grab_focus()
	play_selection()

func portrait(atlas: String, dimensions: Vector2) -> TextureRect:
	var item := TextureRect.new()
	item.texture = preload("res://scripts/presentation/atlas_library.gd").frame(atlas,0)
	item.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item.size = dimensions
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.material = ShaderMaterial.new()
	item.material.shader = preload("res://scripts/presentation/chroma_key.gdshader")
	add_child(item)
	return item

func label(text: String, font_size: int) -> Label:
	var item := Label.new()
	item.text = text
	item.add_theme_font_size_override("font_size",font_size)
	item.add_theme_color_override("font_color",Color("294a3b"))
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.clip_text = true
	add_child(item)
	return item

func box(fill: Color, edge: Color, radius := 22) -> StyleBoxFlat:
	var result := StyleBoxFlat.new()
	result.bg_color = fill
	result.border_color = edge
	result.set_border_width_all(2)
	result.set_corner_radius_all(radius)
	result.shadow_color = Color("152e3566")
	result.shadow_size = 5
	result.shadow_offset = Vector2(0,5)
	return result

func button(text: String) -> Button:
	var item := Button.new()
	item.text = text
	item.add_theme_font_size_override("font_size",24)
	item.add_theme_stylebox_override("normal",box(Color("fff0d0"),Color("bfa26c")))
	item.add_theme_stylebox_override("hover",box(Color("fff8df"),Color("ecc77e")))
	item.add_theme_stylebox_override("pressed",box(Color("e1cfa6"),Color("bfa26c")))
	item.add_theme_stylebox_override("disabled",box(Color("bec5b7"),Color("8d9a8c")))
	var focus := box(Color(0,0,0,0),Color("fff7c2"))
	focus.set_border_width_all(4)
	item.add_theme_stylebox_override("focus",focus)
	for key in ["font_color","font_hover_color","font_pressed_color","font_focus_color","font_disabled_color"]: item.add_theme_color_override(key,Color("294a3b"))
	item.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_child(item)
	return item

func stage_state(index: int) -> String:
	var state: Dictionary = summary.levels[str(index)]
	if not state.available: return "LOCKED"
	if state.current: return "CURRENT"
	return "COMPLETED" if state.completed else "AVAILABLE"

func refresh() -> void:
	summary = campaign.progress_summary()
	title.text = WORLDS[world]
	subtitle.text = "NOSSA JORNADA  /  MUNDO %d DE 4" % (world+1)
	progress.text = "TRILHAS CONCLUÍDAS\n%d / 16" % summary.completed.size()
	ambience.world = world
	for i in 4:
		var index := world*4+i
		var state := stage_state(index)
		nodes[i].configure(i+1,state,selected==index,summary.levels[str(index)].completed)
		nodes[i].tooltip_text = "%d-%d • %s • %s" % [world+1,i+1,NAMES[index],{"LOCKED":"Bloqueada","CURRENT":"Atual","COMPLETED":"Concluída","AVAILABLE":"Disponível"}[state]]
	var state: Dictionary = summary.levels[str(selected)]
	var visible_selection := selected/4==world
	primary.disabled = not visible_selection or not state.available
	var continuing: bool = selected==int(campaign.data.stage) and not campaign.level.completed
	primary.text = "Escolha uma fase" if primary.disabled else ("Voltar à aventura" if campaign.awaiting_return() else ("Continuar" if continuing else ("Jogar novamente" if state.completed else "Jogar")))
	description.text = "%d-%d  •  %s" % [selected/4+1,selected%4+1,NAMES[selected]] if visible_selection else "Novos caminhos esperam por você"
	if visible_selection:
		detail.text = "Concluída • Conquistas preservadas" if state.completed else "Toque em um marco e siga a aventura."
		if state.secret: detail.text += " • Segredo encontrado"
		if not state.golden_nuts.is_empty(): detail.text += " • %d Nozes Douradas" % state.golden_nuts.size()
	else: detail.text = "Conclua as fases anteriores para abrir a próxima trilha."
	if campaign.store.locked:
		description.text = "Seu progresso original está preservado"
		detail.text = "Save indisponível • Consulte o menu de pausa ao entrar na fase."
	back.visible = not campaign.awaiting_return()
	notice.visible = campaign.awaiting_return()
	notice.text = "Vamos tentar de novo! %d vidas • Retorno ao mundo anterior" % campaign.data.survival.lives
	if campaign.awaiting_return() and int(campaign.data.stage)<4: notice.text = "Vamos tentar de novo! %d vidas • De volta ao Bosque" % campaign.data.survival.lives
	var actor_stage := selected
	squirrel.visible = actor_stage/4==world
	companion.visible = squirrel.visible and campaign.data.survival.pipo_unlocked
	layout()
	queue_redraw()

func select_world(index: int) -> void:
	if index<0 or index>3 or index==world: return
	world = index
	backdrop = load(BACKGROUNDS[world])
	refresh()
	play_selection()

func focus_stage(index: int) -> void:
	selected = index
	world = index/4
	backdrop = load(BACKGROUNDS[world])
	refresh()

func celebrate_unlock(index: int) -> void:
	focus_stage(index)
	notice.text = "Uma nova trilha espera por você!"
	notice.show()
	var marker: Button = nodes[index%4]
	marker.pivot_offset = marker.size/2
	marker.scale = Vector2.ONE * .75
	var tween := create_tween()
	tween.tween_property(marker,"scale",Vector2.ONE*1.16,.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(marker,"scale",Vector2.ONE,.3).set_trans(Tween.TRANS_SINE)
	play_selection()

func select_stage(section: int) -> void:
	var index := world*4+section
	if section<0 or section>3 or index>int(campaign.data.unlocked): return
	move_to_stage(index)

func play_selection() -> void:
	if campaign.data.settings.effects: sound.play()

func layout() -> void:
	if not is_instance_valid(primary): return
	if is_instance_valid(_travel): _travel.kill()
	_walking = false
	var inset: Vector4 = campaign.level.touch.safe_insets()
	var left := 24.0+inset.x
	var right := size.x-24-inset.z
	var image_size := backdrop.get_size()
	var zoom := maxf(size.x/image_size.x,size.y/image_size.y)
	board = Rect2((size-image_size*zoom)/2,image_size*zoom)
	header = Rect2((size.x-620)/2,18+inset.y,620,102)
	title.position = header.position+Vector2(80,40)
	title.size = Vector2(460,45)
	subtitle.position = header.position+Vector2(80,17)
	subtitle.size = Vector2(460,24)
	previous_world.position = header.position+Vector2(-34,7)
	previous_world.size = Vector2(88,88)
	next_world.position = Vector2(header.end.x-54,header.position.y+7)
	next_world.size = Vector2(88,88)
	village_button.position = Vector2(left,132+inset.y)
	village_button.size = Vector2(225,64)
	back.position = Vector2(left,29+inset.y)
	back.size = Vector2(192,88)
	progress.position = Vector2(right-210,43+inset.y)
	progress.size = Vector2(210,62)
	notice.position = Vector2((size.x-780)/2,132+inset.y)
	notice.size = Vector2(780,36)
	footer = Rect2(left,size.y-134-inset.w,right-left,110)
	description.position = footer.position+Vector2(26,20)
	description.size = Vector2(footer.size.x-330,38)
	detail.position = footer.position+Vector2(26,62)
	detail.size = Vector2(footer.size.x-330,32)
	primary.position = Vector2(footer.end.x-282,footer.position.y+13)
	primary.size = Vector2(266,84)
	for i in 4:
		nodes[i].position = point(i)-Vector2(56,56)
		nodes[i].size = Vector2(112,112)
	var actor_stage := selected
	_actor_point = point(actor_stage%4)
	position_characters()
	queue_redraw()

func point(section: int) -> Vector2:
	var p: Vector2 = board.position+board.size*POINTS[section]
	p.y = clampf(p.y,280,footer.position.y-96)
	return p

func _process(delta: float) -> void:
	_time += delta
	position_characters()

func position_characters() -> void:
	if not is_instance_valid(squirrel): return
	var atlas := preload("res://scripts/presentation/atlas_library.gd")
	squirrel.texture = atlas.frame("run",int(_walk_distance/28.0)%4) if _walking else atlas.frame("tico",0)
	companion.texture = atlas.frame("run",4+int(_walk_distance/30.0)%4) if _walking else atlas.frame("pipo",0)
	# Altura e apoio dos pés constantes: os recortes têm larguras diferentes.
	place_portrait(squirrel,92,_actor_point+Vector2(-32 if companion.visible else 0,-42))
	place_portrait(companion,82,_actor_point+Vector2(55,-42))

func place_portrait(item: TextureRect, height: float, feet: Vector2) -> void:
	item.stretch_mode = TextureRect.STRETCH_SCALE
	item.size = item.texture.get_size()*(height/item.texture.get_height())
	item.position = feet-Vector2(item.size.x/2,item.size.y)

func _draw() -> void:
	if not is_instance_valid(backdrop) or board.size.x<=0: return
	draw_texture_rect(backdrop,board,false)
	var previous := board.position+board.size*Vector2(.08,.36)
	for i in 4:
		var target := point(i)
		var curve := Curve2D.new()
		var distance := target.x-previous.x
		curve.add_point(previous,Vector2.ZERO,Vector2(distance*.48,0))
		curve.add_point(target,Vector2(-distance*.48,0),Vector2.ZERO)
		var line := curve.get_baked_points()
		var unlocked: bool = world*4+i<=int(campaign.data.unlocked)
		draw_polyline(line,Color("5d4b3355"),25,true)
		draw_polyline(line,Color("f4d392") if unlocked else Color("71846d99"),18,true)
		if unlocked: draw_polyline(line,Color("ffe7b080"),4,true)
		else:
			for dot in range(0,line.size(),4): draw_circle(line[dot],2,Color("dbe4c6a0"))
		previous = target
	if squirrel.visible:
		draw_set_transform(_actor_point+Vector2(0,-42),0,Vector2(1,.22))
		draw_circle(Vector2.ZERO,61 if companion.visible else 37,Color("203e3555"))
		draw_set_transform(Vector2.ZERO)
	draw_style_box(box(Color("fff0d9f5"),Color("c4a775")),header)
	draw_style_box(box(Color("244a3ee8"),Color("c4a775")),Rect2(progress.position-Vector2(8,14),progress.size+Vector2(16,24)))
	draw_style_box(box(Color("fff2dcee"),Color("c4a775")),footer)
	if notice.visible: draw_style_box(box(Color("fff0d9f5"),Color("c4a775"),14),Rect2(notice.position-Vector2(12,4),notice.size+Vector2(24,8)))

func details() -> Dictionary:
	var states := {}
	var rects := {}
	for i in 4:
		states[str(world*4+i)] = stage_state(world*4+i)
		rects[str(world*4+i)] = rect(nodes[i])
	var village_details: Dictionary = village_view.details() if is_instance_valid(village_view) else {"village_open":false}
	return {"map_open":true,"map_world":world,"map_selected":selected,"map_states":states,"map_nodes":rects,"map_walking":_walking,"map_actor_x":_actor_point.x,
		"map_previous_rect":rect(previous_world),"map_next_rect":rect(next_world),"map_enter_rect":rect(primary),"map_enter_disabled":primary.disabled,"map_back_rect":rect(back),
		"map_pipo_visible":companion.visible,"map_tico_visible":squirrel.visible,"map_art":BACKGROUNDS[world],
		"map_village_rect":rect(village_button),"village":village_details}

func rect(control: Control) -> Array:
	var r := control.get_global_rect()
	return [r.position.x,r.position.y,r.size.x,r.size.y]
