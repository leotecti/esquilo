extends StaticBody2D
## Bloco raro do bosque: revela e concede uma vida ao ser atingido por baixo.

var campaign: Node
var stage_id := 0
var reward_id := ""
var used := false
var taken := false
var _reveal_time := 0.0

func _ready() -> void:
	set_meta("extra_life",true)
	set_meta("life_cache",true)
	collision_layer = 1
	collision_mask = 0
	var collision := CollisionShape2D.new()
	collision.name = "Collision"
	var shape := RectangleShape2D.new()
	shape.size = Vector2(58,58)
	collision.shape = shape
	add_child(collision)
	queue_redraw()

func hit_from_below() -> void:
	if used or not is_instance_valid(campaign): return
	if not campaign.claim_life(stage_id,reward_id): return
	used = true
	taken = true
	_reveal_time = 0.9
	queue_redraw()

func _process(delta: float) -> void:
	if _reveal_time<=0.0: return
	_reveal_time = maxf(0.0,_reveal_time-delta)
	queue_redraw()

func _draw() -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = Color("9a7950") if used else Color("d49a42")
	box.border_color = Color("59402d")
	box.set_border_width_all(4)
	box.set_corner_radius_all(9)
	draw_style_box(box,Rect2(-29,-29,58,58))
	# A folha e a noz distinguem este bloco dos blocos comuns de provisão.
	draw_circle(Vector2(0,5),14,Color("6d482b") if used else Color("f4cd69"))
	draw_arc(Vector2(0,5),11,0,TAU,24,Color("fff0ad") if not used else Color("b39a75"),3,true)
	draw_line(Vector2(0,-8),Vector2(4,-17),Color("5a452d"),4,true)
	draw_colored_polygon(PackedVector2Array([Vector2(3,-16),Vector2(16,-20),Vector2(10,-9)]),Color("6f984d") if not used else Color("718069"))
	for x in [-20.0,20.0]:
		draw_circle(Vector2(x,-20),3,Color("ffe8a0") if not used else Color("806b50"))
	if _reveal_time>0.0:
		var progress := 1.0-_reveal_time/0.9
		var y := lerpf(-38,-105,minf(progress/.55,1.0))
		var alpha := 1.0 if progress<.65 else (1.0-progress)/.35
		draw_circle(Vector2(0,y),24,Color(0.96,0.78,0.35,alpha))
		draw_circle(Vector2(0,y),18,Color(1.0,0.95,0.72,alpha))
		var font := ThemeDB.fallback_font
		draw_string(font,Vector2(-12,y+7),"+1",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color(0.18,0.32,0.23,alpha))
