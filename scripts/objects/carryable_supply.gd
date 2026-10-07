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

func _ready() -> void:
	origin = position
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
	queue_redraw()

func _process(_delta: float) -> void:
	if carried and is_instance_valid(carrier): position = carrier.position+Vector2(0,-82)
	if active:
		hint.hide()
		return
	var near: bool = level.tico.position.distance_to(position)<115
	hint.visible = near and not carried
	if hint.visible: hint.text = "Pipo • AÇÃO para carregar" if level.tico.is_in_group("pipo") else "Chame Pipo para levar as provisões"
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
	# Marca de entrega permanece no mundo mesmo enquanto o cesto acompanha Pipo.
	var target := destination-position
	draw_arc(target+Vector2(0,-3),54,0,TAU,36,Color("e4ca72"),5,true)
	draw_circle(target+Vector2(0,-3),42,Color(0.35,0.63,0.43,.16))
	if active:
		draw_circle(target+Vector2(0,-24),8,Color("9ed17b"))
		return
	# Cesto compacto com alimentos legíveis e baixo custo de desenho.
	draw_rect(Rect2(-38,-42,76,38),Color("a76d37"))
	for stripe in [-24.0,-8.0,8.0,24.0]: draw_line(Vector2(stripe,-40),Vector2(stripe,-6),Color("d49a53"),4,true)
	draw_arc(Vector2(0,-40),32,PI,TAU,20,Color("6e492c"),5,true)
	draw_circle(Vector2(-20,-48),12,Color("d9583f"))
	draw_circle(Vector2(2,-51),13,Color("e7b24e"))
	draw_colored_polygon(PackedVector2Array([Vector2(16,-42),Vector2(31,-68),Vector2(38,-42)]),Color("e9783d"))
	draw_line(Vector2(-20,-60),Vector2(-15,-68),Color("527b43"),4,true)
