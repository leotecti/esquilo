extends Node2D
const VISUAL_STYLE_VERSION := 2
## Goteira previsível: brilha, cai, forma uma poça breve e reinicia.
var level: Node2D
var origin := Vector2.ZERO
var clock := 0.0
var cycle := 3.2
var delay := 0.0
var drop_y := 650.0
var current_y := 0.0
var dangerous := false

func _ready() -> void:
	origin = position
	clock = delay
	z_index = 5
	queue_redraw()

func _physics_process(delta: float) -> void:
	if level.completed or level.respawning: return
	clock = fmod(clock+delta,cycle)
	var phase := clock/cycle
	dangerous = phase>=.42 and phase<.77
	if phase<.42: current_y = lerpf(0.0,12.0,phase/.42)
	elif phase<.68: current_y = lerpf(12.0,drop_y,(phase-.42)/.26)
	else: current_y = drop_y
	if dangerous:
		var hit := origin+Vector2(0,current_y)
		if level.tico.position.distance_to(hit)<34:
			level.tico.take_damage(hit)
	queue_redraw()

func _draw() -> void:
	var phase := clock/cycle
	if phase<.42:
		var forming := clampf(phase/.34,0.0,1.0)
		var tremble := sin(clock*13.0)*2.5 if phase>.28 else 0.0
		draw_line(Vector2(0,-5),Vector2(tremble,5+forming*8),Color("bdefff99"),2,true)
		draw_set_transform(Vector2(tremble,8+forming*7),0,Vector2(.65+.25*forming,1.0+forming*.65))
		draw_circle(Vector2.ZERO,4+forming*4,Color("8adcf2"))
		draw_circle(Vector2(-2,-2),1.8+forming,Color("e5fbffcc"))
		draw_set_transform(Vector2.ZERO)
		var warning_alpha := .20+.15*sin(clock*7.0)
		draw_arc(Vector2(0,drop_y),18,PI,TAU,20,Color(0.45,0.83,0.95,warning_alpha),3,true)
	elif phase<.68:
		var fall_progress := (phase-.42)/.26
		var stretch := 1.25+fall_progress*.9
		draw_line(Vector2(0,maxf(14,current_y-42)),Vector2(0,current_y-8),Color(0.55,0.88,0.97,.32),3,true)
		for trail in 3:
			draw_circle(Vector2((trail-1)*2,current_y-17-trail*11),3.0-trail*.55,Color(0.60,0.90,0.98,.42-trail*.09))
		draw_set_transform(Vector2(0,current_y),0,Vector2(.58,stretch))
		draw_circle(Vector2.ZERO,9,Color("75cfe9"))
		draw_circle(Vector2(-3,-3),2.5,Color("e7fcffdd"))
		draw_set_transform(Vector2.ZERO)
	else:
		var impact := clampf((phase-.68)/.16,0.0,1.0)
		var radius := lerpf(8.0,42.0,impact)
		draw_set_transform(Vector2(0,drop_y+3),0,Vector2(1.8,.35))
		draw_circle(Vector2.ZERO,18+impact*16,Color(0.30,0.69,0.84,.20*(1.0-impact)))
		draw_set_transform(Vector2.ZERO)
		draw_arc(Vector2(0,drop_y),radius,PI,TAU,24,Color(0.45,0.83,0.95,.82*(1.0-impact)),4,true)
		for splash in [-1,1]:
			var splash_pos := Vector2(splash*(10+impact*28),drop_y-impact*25)
			draw_circle(splash_pos,4.5-impact*2,Color(0.62,0.91,0.98,.78*(1.0-impact)))
