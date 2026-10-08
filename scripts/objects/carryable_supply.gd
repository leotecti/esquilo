extends Node2D
## Cesto de provisões transportado por Pipo até a marca de entrega.
const BASKET = preload("res://assets/objects/food_basket.png")
const DONKEY_CART = preload("res://assets/objects/donkey_cart.png")
const DONKEY_CART_WALK = preload("res://assets/objects/donkey_cart_walk_sheet.png")
signal delivered(cargo: Node2D)
signal placement_finished(cargo: Node2D)
signal departure_finished(cargo: Node2D)
var level: Node2D
var destination := Vector2.ZERO
var origin := Vector2.ZERO
var carried := false
var active := false
var carrier: CharacterBody2D
var hint: Label
var delivery_hint: Label
var pickup_progress := 1.0
var pickup_from := Vector2.ZERO
var carry_time := 0.0
var placing := false
var placement_time := 0.0
var placement_progress := 0.0
var placement_from := Vector2.ZERO
var departing := false
var departed := false
var departure_time := 0.0
var departure_offset := 0.0
var cart_frame := 0
var _cart_frames: Array[Texture2D] = []
var required_mechanism: StringName = &""
const CARRY_OFFSET := Vector2(0,-108)
const PLACEMENT_DURATION := 0.90
const DEPARTURE_DELAY := 0.65
const DEPARTURE_DURATION := 2.35
const CART_GROUND_OFFSET := 5.0
const BASKET_GROUND_OFFSET := 14.0

func _ready() -> void:
	origin = position
	z_index = 3
	hint = Label.new()
	hint.size.x = 310
	hint.position = Vector2(-155,-125)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size",18)
	hint.add_theme_color_override("font_color",Color("fff0c2"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("3d5038dc")
	style.border_color = Color("dcbf69")
	style.set_border_width_all(2)
	style.set_corner_radius_all(11)
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	hint.add_theme_stylebox_override("normal",style)
	add_child(hint)
	delivery_hint = Label.new()
	delivery_hint.text = "APROXIME-SE • ENTREGA"
	delivery_hint.size.x = 230
	delivery_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	delivery_hint.add_theme_font_size_override("font_size",17)
	delivery_hint.add_theme_color_override("font_color",Color("fff1bd"))
	delivery_hint.add_theme_color_override("font_outline_color",Color("31513d"))
	delivery_hint.add_theme_constant_override("outline_size",5)
	add_child(delivery_hint)
	for index in 4:
		var frame := AtlasTexture.new()
		frame.atlas = DONKEY_CART_WALK
		var frame_width := DONKEY_CART_WALK.get_width()/4.0
		# A arte possui uma margem transparente grande abaixo das patas. Recortar
		# somente a faixa ocupada mantém rodas e cascos apoiados durante a partida.
		frame.region = Rect2(frame_width*index,170,frame_width,315)
		frame.filter_clip = true
		_cart_frames.append(frame)
	queue_redraw()

func _process(delta: float) -> void:
	carry_time += delta
	if departing:
		departure_time += delta
		var travel_progress := clampf((departure_time-DEPARTURE_DELAY)/DEPARTURE_DURATION,0.0,1.0)
		var eased := travel_progress*travel_progress*(3.0-2.0*travel_progress)
		departure_offset = eased*720.0
		cart_frame = int(maxf(0.0,departure_time-DEPARTURE_DELAY)*7.0)%4
		if travel_progress>=1.0:
			departing = false
			departed = true
			departure_finished.emit(self)
	if carried and is_instance_valid(carrier):
		pickup_progress = minf(1.0,pickup_progress+delta/0.34)
		var lift := pickup_progress*pickup_progress*(3.0-2.0*pickup_progress)
		var anchor: Vector2 = carrier.position+CARRY_OFFSET+Vector2(0,-absf(sin(carry_time*6.0))*2.0)
		position = pickup_from.lerp(anchor,lift)
		if carrier.position.distance_to(destination)<145.0 and level.has_method("_start_supply_placement"):
			level._start_supply_placement(self)
	if placing:
		placement_time += delta
		placement_progress = clampf(placement_time/PLACEMENT_DURATION,0.0,1.0)
		var eased_place := placement_progress*placement_progress*(3.0-2.0*placement_progress)
		# Um arco curto faz Pipo baixar o cesto para dentro do compartimento.
		var fitted_anchor := destination+Vector2(-24,-66)
		position = placement_from.lerp(fitted_anchor,eased_place)+Vector2(0,-sin(placement_progress*PI)*18.0)
		if placement_progress>=1.0:
			placing = false
			position = destination
			placement_finished.emit(self)
	if active:
		hint.hide()
	else:
		var near: bool = level.tico.position.distance_to(position)<115
		hint.visible = near and not carried and not placing
		if hint.visible:
			if not _passage_is_open(): hint.text = "A passagem precisa ser aberta primeiro"
			else: hint.text = "Pipo • AÇÃO para erguer a cesta" if level.tico.is_in_group("pipo") else "A cesta é pesada • Chame Pipo"
	var target := destination-position
	delivery_hint.position = target+Vector2(-115,-142)
	delivery_hint.visible = carried and carrier.position.distance_to(destination)<330
	queue_redraw()

func interact(character: CharacterBody2D) -> bool:
	if active or not character.is_in_group("pipo") or not _passage_is_open(): return false
	if carried:
		if character.position.distance_to(destination)<160 and level.has_method("_start_supply_placement"):
			level._start_supply_placement(self)
		else:
			drop_at(character.position)
		return true
	if character.position.distance_to(position)>105: return false
	carried = true
	carrier = character
	pickup_from = position
	pickup_progress = 0.0
	carry_time = 0.0
	hint.hide()
	queue_redraw()
	return true

func _passage_is_open() -> bool:
	return required_mechanism==&"" or (level.mechanisms.has(required_mechanism) and level.mechanisms[required_mechanism].active)

func delivery_preview() -> bool:
	return placing or (carried and is_instance_valid(carrier) and carrier.position.distance_to(destination)<145.0)

func start_placement() -> void:
	if placing or active or not carried: return
	placing = true
	placement_time = 0.0
	placement_progress = 0.0
	placement_from = position
	carried = false
	carrier = null
	hint.hide()
	queue_redraw()

func drop_at(point: Vector2) -> void:
	carried = false
	carrier = null
	position = point
	queue_redraw()

func activate(announce := true) -> void:
	if active: return
	active = true
	carried = false
	carrier = null
	position = destination
	if not announce: departed = true
	if announce: delivered.emit(self)
	queue_redraw()

func start_departure() -> void:
	if departing or departed: return
	departing = true
	departure_time = 0.0
	departure_offset = 0.0
	cart_frame = 0
	queue_redraw()

func _draw() -> void:
	var target := destination-position
	var cart_at := target+Vector2(departure_offset,0)
	# A cesta fica atrás da parede frontal da carroça, encaixada no compartimento.
	if active and not departed: _draw_basket_in_cart(cart_at)
	elif placing: _draw_basket(Vector2(0,lerpf(BASKET_GROUND_OFFSET,0.0,placement_progress)),lerpf(88.0,46.0,placement_progress))
	elif should_draw_waiting_basket(): _draw_basket(Vector2(0,BASKET_GROUND_OFFSET))
	_draw_delivery_area(cart_at)

func should_draw_waiting_basket() -> bool:
	# Depois da entrega, a cesta pertence à carroça e não pode reaparecer
	# no ponto onde foi recolhida quando a partida termina.
	return not carried and not active and not placing and not departing and not departed

func _draw_delivery_area(at: Vector2) -> void:
	if departed: return
	# A carroça e o sinal de entrega permanecem legíveis sobre o rio.
	var pulse := 2.0+sin(carry_time*3.0)*2.0 if carried else 0.0
	var cart_texture: Texture2D = _cart_frames[cart_frame] if departing else DONKEY_CART
	var cart_height := 130.0 if departing else 122.0
	var cart_size := cart_texture.get_size()*(cart_height/cart_texture.get_height())
	# O centro da carroça coincide com o ponto de entrega; o burrinho aguarda à direita.
	draw_texture_rect(cart_texture,Rect2(at+Vector2(-65,-cart_height+CART_GROUND_OFFSET),cart_size),false)
	if departing and departure_time>DEPARTURE_DELAY:
		for i in 4:
			var dust_x := at.x-52-i*15-fmod(departure_time*70+i*11,24)
			var dust_alpha := .24-float(i)*.035
			draw_circle(Vector2(dust_x,at.y-5-i%2*5),7+i*2,Color(0.82,0.73,0.55,dust_alpha))
	if carried:
		draw_circle(at+Vector2(0,-56),40+pulse,Color(0.95,0.81,0.34,.10))
		draw_arc(at+Vector2(0,-56),38+pulse,0,TAU,32,Color("f4d878"),4,true)
		draw_colored_polygon(PackedVector2Array([at+Vector2(0,-92),at+Vector2(-10,-76),at+Vector2(10,-76)]),Color("ffe89a"))

func _draw_basket(at: Vector2, height := 88.0) -> void:
	var size := BASKET.get_size()*(height/BASKET.get_height())
	draw_texture_rect(BASKET,Rect2(at+Vector2(-size.x/2,-height),size),false)

func _draw_basket_in_cart(at: Vector2) -> void:
	var height := 46.0
	var size := BASKET.get_size()*(height/BASKET.get_height())
	# Centro do cesto alinhado ao interior da caixa; a carroça desenhada depois
	# cobre a parte inferior e cria o encaixe visual.
	draw_texture_rect(BASKET,Rect2(at+Vector2(-24-size.x/2,-112),size),false)
