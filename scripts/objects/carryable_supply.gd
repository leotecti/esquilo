extends Node2D
## Cesto de provisões transportado por Pipo até a marca de entrega.
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
	if not active: _draw_basket(Vector2.ZERO)
	else: _draw_basket(target+Vector2(0,-8))

func _draw_delivery_area(at: Vector2) -> void:
	# Estrado de recebimento, placa e brilho suave permanecem legíveis sobre o rio.
	var pulse := 2.0+sin(carry_time*3.0)*2.0 if carried else 0.0
	draw_circle(at+Vector2(0,-5),58+pulse,Color(0.86,0.75,0.32,.10))
	draw_arc(at+Vector2(0,-5),55+pulse,0,TAU,40,Color("efd77b"),5,true)
	draw_colored_polygon(PackedVector2Array([at+Vector2(-65,0),at+Vector2(65,0),at+Vector2(52,-18),at+Vector2(-52,-18)]),Color("6f4b2d"))
	for x in [-38.0,-12.0,14.0,40.0]: draw_line(at+Vector2(x,-16),at+Vector2(x-5,-2),Color("c5964e"),4,true)
	draw_line(at+Vector2(62,-16),at+Vector2(62,-100),Color("755033"),7,true)
	draw_colored_polygon(PackedVector2Array([at+Vector2(62,-98),at+Vector2(126,-88),at+Vector2(112,-62),at+Vector2(62,-70)]),Color("3e7750"))
	draw_colored_polygon(PackedVector2Array([at+Vector2(89,-84),at+Vector2(78,-69),at+Vector2(100,-69)]),Color("f4d878"))
	if active: draw_circle(at+Vector2(0,-70),8,Color("a9df78"))

func _draw_basket(at: Vector2) -> void:
	# Cesta trançada com aro, tecido e alimentos reconhecíveis.
	draw_arc(at+Vector2(0,-43),34,PI,TAU,24,Color("6d4527"),7,true)
	draw_arc(at+Vector2(0,-43),27,PI,TAU,24,Color("d8a45b"),3,true)
	draw_colored_polygon(PackedVector2Array([at+Vector2(-42,-43),at+Vector2(42,-43),at+Vector2(33,0),at+Vector2(-33,0)]),Color("9b6032"))
	draw_line(at+Vector2(-39,-38),at+Vector2(39,-38),Color("e0ae62"),7,true)
	for y in [-29.0,-17.0,-6.0]: draw_line(at+Vector2(-36,y),at+Vector2(36,y),Color("c98946"),4,true)
	for x in [-25.0,-8.0,9.0,26.0]: draw_line(at+Vector2(x,-38),at+Vector2(x*.78,-2),Color("e0ae62"),3,true)
	draw_circle(at+Vector2(-23,-51),12,Color("d8583f"))
	draw_circle(at+Vector2(-1,-54),13,Color("e8b848"))
	draw_colored_polygon(PackedVector2Array([at+Vector2(13,-43),at+Vector2(27,-70),at+Vector2(39,-43)]),Color("e77b39"))
	draw_line(at+Vector2(-23,-62),at+Vector2(-18,-70),Color("477743"),4,true)
	draw_colored_polygon(PackedVector2Array([at+Vector2(25,-66),at+Vector2(35,-74),at+Vector2(32,-62)]),Color("5d9248"))
