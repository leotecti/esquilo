extends Node2D
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
	var warning := clock/cycle<.42
	if warning:
		draw_circle(Vector2(0,8+sin(clock*8)*3),6,Color("9ee9ff"))
		draw_line(Vector2(-15,drop_y),Vector2(15,drop_y),Color(0.45,0.83,0.95,.35),3)
	elif clock/cycle<.68:
		draw_set_transform(Vector2(0,current_y),0,Vector2(.65,1.35))
		draw_circle(Vector2.ZERO,10,Color("8adcf2"))
		draw_set_transform(Vector2.ZERO)
	else:
		var radius := 22.0+(clock/cycle-.68)*30.0
		draw_arc(Vector2(0,drop_y),radius,PI,TAU,20,Color(0.45,0.83,0.95,.7),4,true)
