extends Control
## Mapa desenhado com formas vetoriais e controles nativos, sem textura adicional.
const WORLDS = ["Bosque das Folhas","Rio das Pedras","Montanha das Corujas","Vila dos Castores"]
const SHORT = ["Bosque","Rio","Montanha","Vila dos Castores"]
const COLORS = [Color("82ab69"),Color("79b9bd"),Color("9faec2"),Color("c4a879")]
const NAMES = ["Primeiros Passos","Blocos e Segredos","Um Novo Amigo","Guardião do Bosque",
	"Atravessando o Rio","Correnteza","A Grande Ponte","Guardião do Rio",
	"Vento nas Alturas","Cavernas da Montanha","O Ninho das Corujas","Encontro na Montanha",
	"A Vila Mecânica","A Grande Barragem","As Engrenagens","Rei Castor"]
var campaign: Node
var world := 0
var selected := 0
var summary: Dictionary
var tabs: Array[Button] = []
var nodes: Array[Button] = []
var title: Label
var subtitle: Label
var description: Label
var legend: Label
var village: Label
var primary: Button
var back: Button
var board := Rect2()

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	selected = int(campaign.data.survival.return_stage) if campaign.awaiting_return() else int(campaign.data.stage)
	world = selected/4
	title = label("Nossa jornada",34)
	subtitle = label("",23)
	description = label("",24)
	legend = label("Atual  •  Disponível  •  Concluída  •  Bloqueada",21)
	village = label("Vilarejo\nInício da jornada",21)
	village.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	for i in 4:
		var tab := button(SHORT[i])
		tab.pressed.connect(select_world.bind(i))
		tabs.append(tab)
		var node := button("")
		node.pressed.connect(select_stage.bind(i))
		nodes.append(node)
	primary = button("")
	primary.pressed.connect(func(): campaign.enter_from_map(selected))
	back = button("Fase atual")
	back.pressed.connect(func(): campaign.close_map())
	resized.connect(layout)
	refresh()
	primary.grab_focus()

func label(text: String, font_size: int) -> Label:
	var item := Label.new()
	item.text = text
	item.add_theme_font_size_override("font_size",font_size)
	item.add_theme_color_override("font_color",Color("244b37"))
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(item)
	return item

func style(fill: Color, edge: Color, border := 3) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = edge
	box.set_border_width_all(border)
	box.set_corner_radius_all(22)
	return box

func button(text: String) -> Button:
	var item := Button.new()
	item.text = text
	item.add_theme_font_size_override("font_size",24)
	for state in ["normal","hover","pressed"]:
		item.add_theme_stylebox_override(state,style(Color("fff3d9") if state=="normal" else Color("e4eec8"),Color("537952")))
	item.add_theme_stylebox_override("disabled",style(Color("dfdfd0"),Color("a7ae9e")))
	item.add_theme_stylebox_override("focus",style(Color(0,0,0,0),Color("b36e24"),5))
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color","font_disabled_color"]:
		item.add_theme_color_override(state,Color("244b37") if state!="font_disabled_color" else Color("596256"))
	add_child(item)
	return item

func stage_state(index: int) -> String:
	var state: Dictionary = summary.levels[str(index)]
	if not state.available: return "LOCKED"
	if state.current: return "CURRENT"
	return "COMPLETED" if state.completed else "AVAILABLE"

func refresh() -> void:
	summary = campaign.progress_summary()
	subtitle.text = ("Fim das vidas • Retorno ao %s • %d vidas renovadas" % [WORLDS[int(campaign.data.survival.return_stage)/4],campaign.data.survival.lives]) if campaign.awaiting_return() else "%s • %d de 16 fases concluídas" % [WORLDS[world],summary.completed.size()]
	for i in 4:
		tabs[i].add_theme_stylebox_override("normal",style(Color("d5e7b5") if i==world else Color("fff3d9"),Color("537952")))
		var index := world*4+i
		var state := stage_state(index)
		var status: String = {"LOCKED":"Bloqueada","CURRENT":"Atual","COMPLETED":"Concluída","AVAILABLE":"Disponível"}[state]
		nodes[i].text = "%d-%d\n%s" % [world+1,i+1,status]
		nodes[i].disabled = state=="LOCKED"
		nodes[i].tooltip_text = NAMES[index]
		nodes[i].add_theme_stylebox_override("normal",style(Color("f9d87d") if selected==index else (Color("d5e7b5") if state=="COMPLETED" else Color("fff3d9")),Color("537952")))
	var state: Dictionary = summary.levels[str(selected)]
	var visible_selection := selected/4==world
	primary.disabled = not visible_selection or not state.available
	var continuing: bool = selected==int(campaign.data.stage) and not campaign.level.completed
	primary.text = "Escolha uma fase" if primary.disabled else ("Voltar à aventura" if campaign.awaiting_return() else ("Continuar fase" if continuing else ("Jogar novamente" if state.completed else "Entrar na fase")))
	description.text = "%d-%d • %s\n%s" % [selected/4+1,selected%4+1,NAMES[selected],"Concluída • Conquistas preservadas" if state.completed else "Siga a trilha e explore com seus amigos."] if visible_selection else "Explore os caminhos deste mundo.\nAs próximas fases abrem ao concluir as anteriores."
	if campaign.store.locked: description.text = "Save indisponível. Seu registro original foi preservado.\nConsulte o menu de pausa ao entrar na fase."
	back.visible = not campaign.awaiting_return()
	village.text = "Vilarejo\nInício da jornada" if world==0 else "Do mundo\nanterior"
	layout()
	queue_redraw()

func select_world(index: int) -> void:
	world = index
	refresh()

func select_stage(section: int) -> void:
	var index := world*4+section
	if index>int(campaign.data.unlocked): return
	selected = index
	refresh()
	primary.grab_focus()

func layout() -> void:
	if not is_instance_valid(primary): return
	var inset: Vector4 = campaign.level.touch.safe_insets()
	var left := 32.0+inset.x
	var width := size.x-left-32-inset.z
	title.position = Vector2(left,18+inset.y)
	subtitle.position = Vector2(left,61+inset.y)
	for i in 4:
		tabs[i].position = Vector2(left+i*(width+12)/4,103+inset.y)
		tabs[i].size = Vector2((width-36)/4,80)
	board = Rect2(left,198+inset.y,width,maxf(220,size.y-428-inset.y-inset.w))
	for i in 4:
		nodes[i].position = point(i)-Vector2(81,45)
		nodes[i].size = Vector2(162,90)
	village.position = board.position+Vector2(4,board.size.y*0.62)
	village.size = Vector2(board.size.x*.16,60)
	legend.position = Vector2(left,board.end.y+8)
	description.position = Vector2(left,size.y-192-inset.w)
	primary.position = Vector2(size.x-348-inset.z,size.y-112-inset.w)
	primary.size = Vector2(316,88)
	back.position = Vector2(left,size.y-112-inset.w)
	back.size = Vector2(250,88)
	queue_redraw()

func point(section: int) -> Vector2:
	return board.position+Vector2(board.size.x*(0.28+section*.205),board.size.y*([0.64,0.39,0.62,0.35][section]))

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO,size),Color("f7efd9"))
	if board.size.x<=0: return
	draw_style_box(style(COLORS[world].lightened(0.4),COLORS[world]),board)
	# Biomas ilustrados com o mesmo vocabulário de formas dos cenários existentes.
	for i in 12:
		if i==1: continue
		var p := board.position+Vector2(board.size.x*(i+.5)/12,board.size.y*(.2 if i%2==0 else .82))
		if world==0:
			draw_line(p,p+Vector2(0,28),Color("806340"),10)
			draw_circle(p,24,Color("598552"))
			draw_circle(p+Vector2(-12,-8),17,Color("80a762"))
		elif world==2:
			draw_colored_polygon(PackedVector2Array([p+Vector2(-42,28),p+Vector2(0,-39),p+Vector2(42,28)]),Color("8293a6"))
			draw_colored_polygon(PackedVector2Array([p+Vector2(-13,-18),p+Vector2(0,-39),p+Vector2(13,-18)]),Color("f7f4e8"))
		elif world==3:
			house(p,Color("b37c4f"))
	if world==1:
		var river := PackedVector2Array()
		for i in 25: river.append(board.position+Vector2(28+(board.size.x-56)*i/24.0,board.size.y*(.5+.28*sin(i*.34))))
		draw_polyline(river,Color("5b9eb7"),50,true)
		draw_polyline(river,Color("b1dbd5"),4,true)
	var start := board.position+Vector2(board.size.x*.08,board.size.y*.49)
	var previous := start
	for i in 4:
		var target := point(i)
		draw_line(previous,target,Color("8a7456"),17,true)
		draw_line(previous,target,Color("f4db9b") if world*4+i<=int(campaign.data.unlocked) else Color("b3b4a6"),10,true)
		previous = target
	house(start,Color("cf9056"))

func house(p: Vector2, color: Color) -> void:
	var walls := style(Color("fff0c8"),Color("997248"),2)
	walls.set_corner_radius_all(4)
	draw_style_box(walls,Rect2(p+Vector2(-23,-7),Vector2(46,35)))
	draw_colored_polygon(PackedVector2Array([p+Vector2(-33,-6),p+Vector2(0,-36),p+Vector2(33,-6)]),color)
	draw_rect(Rect2(p+Vector2(-6,8),Vector2(12,20)),Color("846746"))

func details() -> Dictionary:
	var states := {}
	var rects := {}
	for i in 4:
		states[str(world*4+i)] = stage_state(world*4+i)
		rects[str(world*4+i)] = rect(nodes[i])
	return {"map_open":true,"map_world":world,"map_selected":selected,"map_states":states,"map_nodes":rects,
		"map_tabs":tabs.map(func(tab): return rect(tab)),"map_enter_rect":rect(primary),"map_enter_disabled":primary.disabled,"map_back_rect":rect(back)}

func rect(control: Control) -> Array:
	var r := control.get_global_rect()
	return [r.position.x,r.position.y,r.size.x,r.size.y]
