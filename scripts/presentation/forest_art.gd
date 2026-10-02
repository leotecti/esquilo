extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const GROUND = preload("res://assets/slice/ground.svg")
const DEEP_GROUND = preload("res://assets/slice/ground_deep.svg")
var coop_details := true
var platforms: Array[Rect2] = []

func _ready() -> void:
	z_index = -1

func _draw() -> void:
	var ground_rects: Array[Rect2] = [Rect2(0,760,3800,200)]
	ground_rects.append_array(platforms)
	for rect in ground_rects: ground(rect)
	for rect in platforms:
		organic_side(rect,true,ground_rects)
		organic_side(rect,false,ground_rects)
	if coop_details:
		_draw_coop()
	# Vegetação compartilhada por todas as trilhas.
	for x in [90,400,930,1230,1820,2380,2630,3100]:
		draw_texture_rect(ATLAS.frame("props",9),Rect2(x-40,687,76,73),false)
	for x in [240,720,1940,2490,2750,3180]:
		draw_texture_rect(ATLAS.frame("props",10),Rect2(x-20,730,44,30),false)
	for x in range(0,3800,125):
		if coop_details and x>1300 and x<1760: continue
		draw_texture_rect(ATLAS.frame("props",8),Rect2(x,744,53,20),false)

func _draw_coop() -> void:
	for i in 3: ground(Rect2(3260+i*160,690-i*70,180,300))
	# O volume visual termina exatamente no teto físico de 696 px.
	draw_rect(Rect2(1350,0,400,696),Color("5f4930"))
	for x in range(1360,1740,34):
		draw_line(Vector2(x,0),Vector2(x+sin(x)*16,683),Color("88643b"),12)
		draw_line(Vector2(x+10,0),Vector2(x+17,675),Color("ac8250"),3)
	for x in range(1300,1740,95):
		draw_texture_rect(ATLAS.frame("props",7),Rect2(x,475,155,135),false,Color("bacb89"))

func ground(rect: Rect2) -> void:
	draw_rect(rect,Color("53412d"))
	var top_height: float = minf(160,rect.size.y)
	var x: float = rect.position.x
	while x < rect.end.x:
		var width: float = minf(256,rect.end.x-x)
		draw_texture_rect_region(GROUND,Rect2(x,rect.position.y,width,top_height),Rect2(0,0,width,top_height))
		x += width
	if rect.size.y>top_height:
		var deep := Rect2(rect.position.x,rect.position.y+top_height,rect.size.x,rect.size.y-top_height)
		# Uma única faixa esticada evita centenas de quadrados fora da tela nas
		# bases muito extensas; abaixo de y=920 o preenchimento não fica visível.
		if deep.position.y<900: draw_texture_rect(DEEP_GROUND,deep,false)

func organic_side(rect: Rect2, left: bool, all_rects: Array[Rect2]) -> void:
	# A colisão continua precisa e retangular; esta saia cobre o encontro visual
	# entre alturas com uma borda de terra erodida.
	var edge_x: float = rect.position.x if left else rect.end.x
	var sample_x: float = edge_x+(-2 if left else 2)
	var join_y: float = rect.end.y
	for other in all_rects:
		if other==rect or sample_x<other.position.x or sample_x>=other.end.x: continue
		# Uma superfície vizinha da mesma altura (ou mais alta) já cobre a face.
		if other.position.y<=rect.position.y+20: return
		if other.position.y>rect.position.y+20:
			join_y = minf(join_y,other.position.y)
	if join_y<=rect.position.y+48: return
	var side: float = -1 if left else 1
	var top: float = rect.position.y+17
	var middle: float = lerpf(top,join_y,.58)
	var points := PackedVector2Array([
		Vector2(edge_x,top),Vector2(edge_x+side*8,top+15),
		Vector2(edge_x+side*14,middle),Vector2(edge_x+side*7,join_y-10),
		Vector2(edge_x,join_y)])
	draw_colored_polygon(points,Color("6f4b32"))
