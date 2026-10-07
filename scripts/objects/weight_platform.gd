extends "res://scripts/objects/power_device.gd"
## Plataforma larga que reconhece o peso de Pipo e permanece acionada.
const WIDTH := 176.0

func _ready() -> void:
	mode = "weight"
	super._ready()

func _physics_process(delta: float) -> void:
	if active or level.completed: return
	var player: CharacterBody2D = level.tico
	if player.is_in_group("pipo") and player.is_on_floor() and absf(player.position.x-position.x)<WIDTH*.46 and absf(player.position.y-position.y)<10:
		held += delta
		if held>=0.38: activate()
	else:
		held = maxf(0.0,held-delta*2.5)
	queue_redraw()

func _draw() -> void:
	var depression := 7.0 if active else minf(7.0,held/.38*7.0)
	var color := Color("83b56f") if active else Color("d0a653")
	draw_rect(Rect2(-WIDTH*.5,-9,WIDTH,13),Color("40534d"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(-WIDTH*.46,-18+depression),Vector2(WIDTH*.46,-18+depression),
		Vector2(WIDTH*.40,-5+depression),Vector2(-WIDTH*.40,-5+depression)
	]),color)
	for x in [-58.0,-29.0,0.0,29.0,58.0]:
		draw_circle(Vector2(x,-12+depression),5,Color("f1d77f"))
	if held>0 and not active:
		draw_arc(Vector2(0,-39),17,-PI/2,-PI/2+TAU*minf(held/.38,1),28,Color("fff0a3"),4,true)
