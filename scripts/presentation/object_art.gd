extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const HEART = preload("res://assets/slice/heart.svg")
const PUSHABLE_BOULDER = preload("res://assets/objects/pushable_boulder.png")
var kind := "nut"
var object: Node2D
var _time := 0.0

func _ready() -> void:
	object = get_parent()
	object.self_modulate.a = 0
	# A arte comercial substitui integralmente o desenho-base dos coletáveis.
	# Evita centenas de callbacks invisíveis em fases longas.
	if object.has_method("reset_item"): object.set_process(false)

func _process(delta: float) -> void:
	_time += delta
	if not is_instance_valid(object) or not object.visible: return
	var screen_position := get_viewport().get_canvas_transform()*global_position
	var viewport_size := get_viewport_rect().size
	if screen_position.x < -100 or screen_position.x > viewport_size.x+100 or screen_position.y < -120 or screen_position.y > viewport_size.y+120: return
	queue_redraw()

func prop(index: int, rect: Rect2, color: Color = Color.WHITE) -> void:
	draw_texture_rect(ATLAS.frame("props",index),rect,false,color)

func _draw() -> void:
	if not is_instance_valid(object): return
	match kind:
		"nut", "secret", "golden":
			if kind == "secret" and not object.revealed:
				prop(7,Rect2(-42,-25,84,57))
			else:
				var y := sin(_time*3)*3
				if object.healing: draw_texture_rect(HEART,Rect2(-18,-20+y,36,36),false)
				else:
					prop(0,Rect2(-17,-24+y,34,41),Color("ffe178") if kind=="golden" else Color.WHITE)
					if kind=="golden":
						draw_arc(Vector2(0,-3+y),25,0,TAU,24,Color("ffe9a688"),3)
			if kind == "secret" and object.scent_visible and not object.taken:
				var start: Vector2 = to_local(object.scent_from)
				for i in 5:
					var progress := fmod(_time*.7+i*.2,1)
					var point := start.lerp(Vector2.ZERO,progress)+Vector2(0,sin(progress*TAU)*12)
					draw_circle(point,3+progress*3,Color("ffdc80"))
		"food":
			var y := sin(_time*3+object.food_kind)*3
			if object.food_kind==0:
				draw_circle(Vector2(0,y),17,Color("713f32"))
				draw_circle(Vector2(0,y),14,Color("d95b45"))
				draw_circle(Vector2(-7,-5+y),9,Color("ec7455"))
				draw_circle(Vector2(-6,-8+y),3,Color("ffd0a1aa"))
				draw_line(Vector2(1,-14+y),Vector2(4,-23+y),Color("65462f"),4,true)
				draw_colored_polygon(PackedVector2Array([Vector2(4,-21+y),Vector2(15,-25+y),Vector2(10,-16+y)]),Color("6b9147"))
			elif object.food_kind==1:
				for point in [Vector2(-9,-5),Vector2(7,-7),Vector2(-3,7),Vector2(11,6)]:
					draw_circle(point+Vector2(0,y),10,Color("51394f"))
					draw_circle(point+Vector2(0,y),8,Color("8b557d"))
					draw_circle(point+Vector2(-2,-2+y),2,Color("e5a5c7aa"))
				draw_colored_polygon(PackedVector2Array([Vector2(-8,-14+y),Vector2(0,-25+y),Vector2(7,-13+y)]),Color("668b4b"))
			else:
				var carrot_outline := PackedVector2Array([Vector2(-17,-13+y),Vector2(-10,-20+y),Vector2(7,-19+y),Vector2(17,-11+y),Vector2(14,-2+y),Vector2(9,9+y),Vector2(4,20+y),Vector2(0,25+y),Vector2(-4,19+y),Vector2(-10,8+y),Vector2(-15,-2+y)])
				var carrot_body := PackedVector2Array([Vector2(-13,-12+y),Vector2(-8,-16+y),Vector2(6,-15+y),Vector2(12,-10+y),Vector2(10,-2+y),Vector2(6,8+y),Vector2(2,18+y),Vector2(0,20+y),Vector2(-3,15+y),Vector2(-8,5+y),Vector2(-12,-3+y)])
				draw_colored_polygon(carrot_outline,Color("6a3c2c"))
				draw_colored_polygon(carrot_body,Color("df782f"))
				draw_colored_polygon(PackedVector2Array([Vector2(-9,-13+y),Vector2(-3,-15+y),Vector2(1,-10+y),Vector2(-1,1+y),Vector2(-5,9+y),Vector2(-9,2+y)]),Color("f29a43"))
				draw_line(Vector2(5,-7+y),Vector2(0,-2+y),Color("ffca70"),2,true)
				draw_line(Vector2(3,3+y),Vector2(-2,8+y),Color("ffca70"),2,true)
				draw_line(Vector2(1,12+y),Vector2(-2,15+y),Color("bf5e2e"),2,true)
				draw_colored_polygon(PackedVector2Array([Vector2(-7,-15+y),Vector2(-10,-25+y),Vector2(-2,-21+y),Vector2(1,-31+y),Vector2(5,-21+y),Vector2(12,-26+y),Vector2(8,-14+y)]),Color("537c43"))
				draw_line(Vector2(-6,-15+y),Vector2(-8,-23+y),Color("8eac5a"),2,true)
				draw_line(Vector2(2,-17+y),Vector2(2,-27+y),Color("8eac5a"),2,true)
		"block":
			prop([2,3,4][object.kind],Rect2(-28,-28,56,56),Color("b4a98d") if object.used else Color.WHITE)
		"stone":
			# A silhueta larga, o musgo e a base pesada deixam claro que esta pedra
			# pertence ao cenário, mas pode ser empurrada.
			draw_texture_rect(PUSHABLE_BOULDER,Rect2(-52,-80,104,80),false)
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
