extends Button
## Marco interativo: símbolos vetoriais independentes da arte e do save.
var number := 1
var status := "LOCKED"
var selected := false
var completed := false
var _time := 0.0

func _ready() -> void:
	for state in ["normal","hover","pressed","disabled","focus"]:
		add_theme_stylebox_override(state,StyleBoxEmpty.new())
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)

func configure(value: int, state: String, active: bool, done: bool) -> void:
	number = value
	status = state
	selected = active
	completed = done
	disabled = state=="LOCKED"
	set_process(active or state=="AVAILABLE")
	queue_redraw()

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _draw() -> void:
	var center := size/2
	var fill := Color("8c9d8f") if disabled else (Color("e9bc62") if selected or status=="CURRENT" else (Color("4d8061") if completed else Color("fff0c2")))
	var ink := Color("263f35") if not completed or selected else Color("fff3cc")
	draw_circle(center+Vector2(0,7),47,Color("1b342f70"))
	if selected or has_focus() or (is_hovered() and not disabled):
		var radius := 50.0+sin(_time*2.8)*1.5
		draw_arc(center,radius,0,TAU,64,Color("fff1b5"),3,true)
	draw_circle(center,44,Color("59462f"))
	draw_circle(center+Vector2(0,-2),41,fill)
	draw_arc(center+Vector2(0,-2),37,PI*1.08,PI*1.88,24,fill.lightened(.5),2,true)
	if disabled:
		draw_arc(center+Vector2(0,-10),10,PI,TAU,20,Color("e6e7d3"),5,true)
		var box := StyleBoxFlat.new()
		box.bg_color = Color("e6e7d3")
		box.set_corner_radius_all(5)
		draw_style_box(box,Rect2(center+Vector2(-15,-10),Vector2(30,24)))
		draw_circle(center+Vector2(0,-1),3,Color("697c70"))
		draw_line(center,center+Vector2(0,7),Color("697c70"),3)
	else:
		var font := ThemeDB.fallback_font
		var text_width := font.get_string_size(str(number),HORIZONTAL_ALIGNMENT_LEFT,-1,34).x
		draw_string(font,center+Vector2(-text_width/2,10),str(number),HORIZONTAL_ALIGNMENT_LEFT,-1,34,ink)
	if completed:
		var pole := center+Vector2(29,-44)
		draw_line(pole+Vector2(0,29),pole,Color("64492e"),4,true)
		draw_colored_polygon(PackedVector2Array([pole,pole+Vector2(29,4),pole+Vector2(23,21),pole+Vector2(0,17)]),Color("315e45"))
		draw_polyline(PackedVector2Array([pole+Vector2(7,9),pole+Vector2(11,13),pole+Vector2(20,6)]),Color("fff2b4"),2.5,true)
	var caption := "BLOQUEADA" if disabled else ("VOCÊ ESTÁ AQUI" if status=="CURRENT" else ("CONCLUÍDA" if completed else "DISPONÍVEL"))
	var small_font := ThemeDB.fallback_font
	var width := small_font.get_string_size(caption,HORIZONTAL_ALIGNMENT_LEFT,-1,15).x
	var tag := StyleBoxFlat.new()
	tag.bg_color = Color("263f35ee")
	tag.set_corner_radius_all(9)
	draw_style_box(tag,Rect2(center+Vector2(-width/2-10,49),Vector2(width+20,24)))
	draw_string(small_font,center+Vector2(-width/2,66),caption,HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("fff1cf"))
