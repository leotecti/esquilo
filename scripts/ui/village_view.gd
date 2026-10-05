extends Control
signal closed

const BACKGROUND := preload("res://assets/narrative/opening_village.png")
const STATE_NAMES = ["Escassez","Recuperação","Preparação para o inverno","Comunidade abastecida"]
const STATE_MESSAGES = [
	"Os cestos ainda estão vazios. Cada alimento encontrado faz diferença.",
	"As primeiras provisões chegaram e os moradores voltaram a trabalhar.",
	"O depósito está crescendo. O vilarejo se prepara para o inverno.",
	"A comunidade está abastecida. Todos celebram a aventura de Tico e Pipo!"
]

var campaign: Node
var state := 0
var food := 0
var completed := 0
var close_button: Button
var title: Label
var message: Label
var progress: Label
var _time := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	process_mode = Node.PROCESS_MODE_ALWAYS
	var info: Dictionary = campaign.village_progress()
	state = int(info.state)
	food = int(info.food)
	completed = int(info.completed)
	title = _label("VILAREJO DE TICO  •  "+STATE_NAMES[state],30)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message = _label(STATE_MESSAGES[state],21)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress = _label("Provisões: %d  •  Trilhas concluídas: %d / 16" % [food,completed],18)
	progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	close_button = Button.new()
	close_button.text = "Voltar ao mapa"
	close_button.add_theme_font_size_override("font_size",22)
	close_button.add_theme_stylebox_override("normal",_box(Color("fff0d8ee"),Color("cfaa6b")))
	close_button.add_theme_stylebox_override("hover",_box(Color("fff9e8"),Color("f0cd82")))
	close_button.add_theme_stylebox_override("pressed",_box(Color("e4d1ac"),Color("b8945c")))
	close_button.pressed.connect(func(): closed.emit())
	add_child(close_button)
	resized.connect(_layout)
	_layout()
	close_button.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		closed.emit()

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _layout() -> void:
	if not is_instance_valid(close_button): return
	var inset: Vector4 = campaign.level.touch.safe_insets()
	title.position = Vector2((size.x-760)/2,22+inset.y)
	title.size = Vector2(760,48)
	progress.position = Vector2((size.x-620)/2,73+inset.y)
	progress.size = Vector2(620,34)
	message.position = Vector2((size.x-760)/2,size.y-132-inset.w)
	message.size = Vector2(760,78)
	close_button.position = Vector2(size.x-250-inset.z,size.y-112-inset.w)
	close_button.size = Vector2(220,76)

func _label(value: String, font_size: int) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size",font_size)
	item.add_theme_color_override("font_color",Color("fff4da"))
	item.add_theme_color_override("font_shadow_color",Color("173126cc"))
	item.add_theme_constant_override("shadow_offset_x",2)
	item.add_theme_constant_override("shadow_offset_y",3)
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(item)
	return item

func _box(fill: Color, edge: Color, radius := 20) -> StyleBoxFlat:
	var result := StyleBoxFlat.new()
	result.bg_color = fill
	result.border_color = edge
	result.set_border_width_all(2)
	result.set_corner_radius_all(radius)
	result.shadow_color = Color("152e3566")
	result.shadow_size = 5
	return result

func _draw() -> void:
	var image_size := BACKGROUND.get_size()
	var zoom := maxf(size.x/image_size.x,size.y/image_size.y)
	var board := Rect2((size-image_size*zoom)/2,image_size*zoom)
	draw_texture_rect(BACKGROUND,board,false)
	# A luz e a saturação crescem com a recuperação do vilarejo.
	var shade = [Color("243d3a88"),Color("4b432844"),Color("5e46191e"),Color("ffcf6020")][state]
	draw_rect(Rect2(Vector2.ZERO,size),shade)
	_draw_header()
	_draw_baskets()
	_draw_residents()
	if state>=2: _draw_bunting()
	if state==3: _draw_celebration()

func _draw_header() -> void:
	draw_style_box(_box(Color("173d34dc"),Color("e7ca87")),Rect2((size.x-820)/2,14,820,100))
	draw_style_box(_box(Color("173d34dc"),Color("e7ca87")),Rect2((size.x-820)/2,size.y-145,820,108))

func _draw_baskets() -> void:
	var count: int = [1,2,3,4][state]
	for i in count:
		var center := Vector2(205+i*112,size.y-205+sin(_time*1.8+i)*2)
		draw_arc(center,36,0,PI,18,Color("6f4326"),10)
		draw_line(center+Vector2(-34,0),center+Vector2(34,0),Color("d19a55"),8)
		var fill: int = 0 if state==0 else mini(5,state+2+i%2)
		for item in fill:
			var color: Color = [Color("d94c38"),Color("f1a43d"),Color("87a947")][(item+i)%3]
			draw_circle(center+Vector2(-22+(item%3)*22,-8-(item/3)*17),10,color)
	if state==0:
		draw_string(ThemeDB.fallback_font,Vector2(285,size.y-250),"cestos vazios",HORIZONTAL_ALIGNMENT_LEFT,180,18,Color("f7dfb8"))

func _draw_residents() -> void:
	var amount: int = [1,2,3,5][state]
	for i in amount:
		var x: float = size.x*.48+i*78
		var y: float = size.y-205+sin(_time*(1.5+i*.08)+i)*5
		var body: Color = Color("bd7543") if i%2==0 else Color("8b684a")
		draw_circle(Vector2(x,y-35),17,body)
		draw_circle(Vector2(x-10,y-51),7,body)
		draw_circle(Vector2(x+10,y-51),7,body)
		draw_circle(Vector2(x,y-9),24,body)
		draw_circle(Vector2(x+20,y-22),18,body.darkened(.12))
		if state==0:
			draw_arc(Vector2(x,y-32),7,.25,PI-.25,8,Color("3d2e27"),2)
		else:
			draw_arc(Vector2(x,y-36),7,0,PI,8,Color("fff2cf"),2)

func _draw_bunting() -> void:
	var y := 145.0
	draw_line(Vector2(80,y),Vector2(size.x-80,y+15),Color("f6dfae"),3)
	for i in 14:
		var p := Vector2(105+i*(size.x-210)/13.0,y+i*15.0/13.0)
		var color: Color = [Color("d86445"),Color("e7b94f"),Color("6b9c62")][i%3]
		draw_colored_polygon(PackedVector2Array([p,p+Vector2(25,2),p+Vector2(13,27)]),color)

func _draw_celebration() -> void:
	for i in 24:
		var x := fposmod(i*97.0+_time*(18+i%3*7),size.x)
		var y := fposmod(i*53.0+_time*(24+i%4*6),size.y-190)+125
		var color: Color = [Color("ffd45f"),Color("ef7656"),Color("8fc46b"),Color("fff0bb")][i%4]
		draw_circle(Vector2(x,y),3+i%3,color)

func details() -> Dictionary:
	return {"village_open":true,"village_state":state,"village_food":food,"village_completed":completed,
		"village_title":STATE_NAMES[state],"village_close_rect":[close_button.position.x,close_button.position.y,close_button.size.x,close_button.size.y]}
