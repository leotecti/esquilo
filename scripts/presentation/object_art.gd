extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const HEART = preload("res://assets/slice/heart.svg")
var kind := "nut"
var object: Node2D
var _time := 0.0

func _ready() -> void:
	object = get_parent()
	object.self_modulate.a = 0

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func prop(index: int, rect: Rect2, color: Color = Color.WHITE) -> void:
	draw_texture_rect(ATLAS.frame("props",index),rect,false,color)

func _draw() -> void:
	if not is_instance_valid(object): return
	match kind:
		"nut", "secret":
			if kind == "secret" and not object.revealed:
				prop(7,Rect2(-42,-25,84,57))
			else:
				var y := sin(_time*3)*3
				if object.healing: draw_texture_rect(HEART,Rect2(-18,-20+y,36,36),false)
				else: prop(0,Rect2(-15,-22+y,30,36))
			if kind == "secret" and object.scent_visible and not object.taken:
				var start: Vector2 = to_local(object.scent_from)
				for i in 5:
					var progress := fmod(_time*.7+i*.2,1)
					var point := start.lerp(Vector2.ZERO,progress)+Vector2(0,sin(progress*TAU)*12)
					draw_circle(point,3+progress*3,Color("ffdc80"))
		"block":
			prop([2,3,4][object.kind],Rect2(-28,-28,56,56),Color("b4a98d") if object.used else Color.WHITE)
		"stone": prop(6,Rect2(-38,-64,76,64))
		"heavy": prop(5,Rect2(-45,-140,90,140))
		"slug":
			draw_set_transform(Vector2.ZERO,0,Vector2(object.direction,0.35 if object.defeated else 1.0))
			prop(1,Rect2(-30,-43+sin(_time*6),60,43))
		"checkpoint":
			prop(11,Rect2(-14,-120,88,120),Color.WHITE if object.activated else Color("b0cfb3"))
			if object.activated:
				draw_arc(Vector2(0,-116),12+sin(_time*3)*2,0,TAU,24,Color("ffe6a1"),2)
		"exit":
			draw_arc(Vector2(0,-40),65,PI,TAU,32,Color("523e2a"),18)
			draw_arc(Vector2(0,-40),65,PI,TAU,32,Color("a47844"),10)
			for x in [-65,65]:
				draw_line(Vector2(x,-40),Vector2(x,0),Color("694a31"),15)
				prop(8,Rect2(x-22,-12,44,25))
			prop(7,Rect2(-84,-137,168,65))
			prop(0,Rect2(-14,-123,28,34))
