extends Node2D
## Mola artesanal regulada pelo peso: Pipo alcança a rota alta; Tico só dá um salto curto.

var level: Node2D
var hint: Label
var cooldown := 0.0
var compression := 0.0
var last_strength := 0.0
const PIPO_LAUNCH := Vector2(340.0,-1020.0)
const TICO_LAUNCH := Vector2(75.0,-330.0)

func _ready() -> void:
	hint = Label.new()
	hint.position = Vector2(-175,-132)
	hint.size.x = 350
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size",19)
	hint.add_theme_color_override("font_color",Color("fff2c7"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("274d3be8")
	style.border_color = Color("dfc56e")
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.content_margin_top = 7
	style.content_margin_bottom = 7
	hint.add_theme_stylebox_override("normal",style)
	add_child(hint)
	queue_redraw()

func _physics_process(delta: float) -> void:
	cooldown = maxf(0.0,cooldown-delta)
	compression = move_toward(compression,0.0,delta*5.5)
	if not is_instance_valid(level) or level.completed or level.respawning:
		hint.hide()
		return
	var character: CharacterBody2D = level.tico
	var nearby := absf(character.position.x-position.x)<135.0 and absf(character.position.y-position.y)<150.0
	hint.visible = nearby
	if nearby:
		hint.text = "Pule na mola • Pipo tem o peso certo" if character.is_in_group("pipo") else "Tico é leve demais • Chame Pipo"
	if cooldown<=0.0 and absf(character.position.x-position.x)<48.0 and character.position.y>position.y-92.0 and character.position.y<position.y+10.0 and character.velocity.y>=25.0:
		launch(character)
	queue_redraw()

func launch(character: CharacterBody2D) -> bool:
	if cooldown>0.0: return false
	var is_pipo := character.is_in_group("pipo")
	var impulse: Vector2 = PIPO_LAUNCH if is_pipo else TICO_LAUNCH
	character.velocity = impulse
	# O impulso da mola é completo mesmo sem manter o botão de pulo pressionado.
	character._jump_cut_applied = true
	character.position.y = minf(character.position.y,position.y-42.0)
	last_strength = -impulse.y
	cooldown = 0.48
	compression = 1.0
	if is_instance_valid(level):
		level._feedback(position+Vector2(0,-48),"Impulso de Pipo!" if is_pipo else "Peso insuficiente",Color("ffe394"))
		level._say("A mola respondeu ao peso de Pipo. Alcance a plataforma alta!" if is_pipo else "Tico é leve demais para comprimir a mola. Pipo consegue ativá-la.")
		level.sounds.play_notes([196,330,587] if is_pipo else [294,247],.055)
	return true

func _draw() -> void:
	# Madeira, aço envelhecido e folhas combinam com os mecanismos do rio.
	draw_colored_polygon(PackedVector2Array([Vector2(-55,0),Vector2(55,0),Vector2(43,-17),Vector2(-43,-17)]),Color("76502f"))
	draw_line(Vector2(-46,-10),Vector2(46,-10),Color("c99a52"),7,true)
	var squash := compression*13.0
	var bottom := -18.0
	var top := -62.0+squash
	var points := PackedVector2Array()
	for i in 9:
		var t := i/8.0
		points.append(Vector2((-22.0 if i%2==0 else 22.0)*(1.0-t*.18),lerpf(bottom,top,t)))
	draw_polyline(points,Color("66706b"),7,true)
	draw_polyline(points,Color("c7d0b1"),2,true)
	draw_colored_polygon(PackedVector2Array([Vector2(-51,top),Vector2(51,top),Vector2(42,top-15),Vector2(-42,top-15)]),Color("719a45"))
	draw_line(Vector2(-40,top-11),Vector2(40,top-11),Color("b9d45e"),6,true)
	for x in [-30.0,0.0,30.0]: draw_circle(Vector2(x,top-13),4,Color("e1c66c"))
