extends Node2D
var level: Node2D
var hint: Label

func _ready() -> void:
	hint = Label.new()
	hint.text = "Pipo • AÇÃO para lançar Tico"
	hint.position = Vector2(-160,-112)
	hint.size.x = 320
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size",19)
	hint.add_theme_color_override("font_color",Color("fff2c7"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("274d3bdd")
	style.border_color = Color("dfc56e")
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.content_margin_top = 7
	style.content_margin_bottom = 7
	hint.add_theme_stylebox_override("normal",style)
	hint.hide()
	add_child(hint)
	queue_redraw()

func _process(_delta: float) -> void:
	hint.visible = not level.completed and not level.respawning and level.tico.is_in_group("pipo") and level.tico.position.distance_to(position)<115

func _draw() -> void:
	# Folhas em leque e seta ascendente comunicam impulso sem animação contínua.
	for direction in [-1.0,1.0]:
		draw_colored_polygon(PackedVector2Array([Vector2(direction*8,-5),Vector2(direction*58,-25),Vector2(direction*46,5),Vector2(direction*15,13)]),Color("5f8f54"))
	draw_arc(Vector2(0,-16),34,0,PI,20,Color("e0bd62"),6,true)
	draw_line(Vector2(0,-48),Vector2(0,-82),Color("fff0a3"),5,true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-95),Vector2(-12,-76),Vector2(12,-76)]),Color("fff0a3"))
