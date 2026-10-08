extends Node2D
## Cesto de provisões transportado por Pipo até a marca de entrega.
const BASKET = preload("res://assets/objects/food_basket.png")
const DONKEY_CART = preload("res://assets/objects/donkey_cart.png")
signal delivered(cargo: Node2D)
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
const CARRY_OFFSET := Vector2(0,-108)

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
	delivery_hint.text = "ENTREGA • AÇÃO"
	delivery_hint.size.x = 230
	delivery_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	delivery_hint.add_theme_font_size_override("font_size",17)
	delivery_hint.add_theme_color_override("font_color",Color("fff1bd"))
	delivery_hint.add_theme_color_override("font_outline_color",Color("31513d"))
	delivery_hint.add_theme_constant_override("outline_size",5)
	add_child(delivery_hint)
	queue_redraw()

func _process(delta: float) -> void:
	carry_time += delta
	if carried and is_instance_valid(carrier):
		pickup_progress = minf(1.0,pickup_progress+delta/0.34)
		var lift := pickup_progress*pickup_progress*(3.0-2.0*pickup_progress)
		var anchor: Vector2 = carrier.position+CARRY_OFFSET+Vector2(0,-absf(sin(carry_time*6.0))*2.0)
		position = pickup_from.lerp(anchor,lift)
	if active:
		hint.hide()
	else:
		var near: bool = level.tico.position.distance_to(position)<115
		hint.visible = near and not carried
		if hint.visible: hint.text = "Pipo • AÇÃO para erguer a cesta" if level.tico.is_in_group("pipo") else "A cesta é pesada • Chame Pipo"
	var target := destination-position
	delivery_hint.position = target+Vector2(-115,-142)
	delivery_hint.visible = carried and carrier.position.distance_to(destination)<330
	queue_redraw()

func interact(character: CharacterBody2D) -> bool:
	if active or not character.is_in_group("pipo"): return false
	if carried:
		if character.position.distance_to(destination)<125:
			activate()
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
	if announce: delivered.emit(self)
	queue_redraw()

func _draw() -> void:
	var target := destination-position
	_draw_delivery_area(target)
	if active: _draw_basket(target+Vector2(0,-8))
	elif not carried: _draw_basket(Vector2.ZERO)

func _draw_delivery_area(at: Vector2) -> void:
	# A carroça e o sinal de entrega permanecem legíveis sobre o rio.
	var pulse := 2.0+sin(carry_time*3.0)*2.0 if carried else 0.0
	var cart_height := 122.0
	var cart_size := DONKEY_CART.get_size()*(cart_height/DONKEY_CART.get_height())
	# O centro da carroça coincide com o ponto de entrega; o burrinho aguarda à direita.
	draw_texture_rect(DONKEY_CART,Rect2(at+Vector2(-62,-cart_height),cart_size),false)
	if carried:
		draw_circle(at+Vector2(0,-56),40+pulse,Color(0.95,0.81,0.34,.10))
		draw_arc(at+Vector2(0,-56),38+pulse,0,TAU,32,Color("f4d878"),4,true)
		draw_colored_polygon(PackedVector2Array([at+Vector2(0,-92),at+Vector2(-10,-76),at+Vector2(10,-76)]),Color("ffe89a"))

func _draw_basket(at: Vector2) -> void:
	var height := 88.0
	var size := BASKET.get_size()*(height/BASKET.get_height())
	draw_texture_rect(BASKET,Rect2(at+Vector2(-size.x/2,-height),size),false)
