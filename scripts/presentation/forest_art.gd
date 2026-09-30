extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const GROUND = preload("res://assets/slice/ground.svg")

func _ready() -> void:
	z_index = -1

func _draw() -> void:
	ground(Rect2(0,760,3800,200))
	for i in 3: ground(Rect2(3260+i*160,690-i*70,180,300))
	# O volume visual termina exatamente no teto físico de 696 px.
	draw_rect(Rect2(1350,0,400,696),Color("5f4930"))
	for x in range(1360,1740,34):
		draw_line(Vector2(x,0),Vector2(x+sin(x)*16,683),Color("88643b"),12)
		draw_line(Vector2(x+10,0),Vector2(x+17,675),Color("ac8250"),3)
	for x in range(1300,1740,95):
		draw_texture_rect(ATLAS.frame("props",7),Rect2(x,475,155,135),false,Color("bacb89"))
	# Decoração atrás do jogador, afastada dos blocos e passagens interativas.
	for x in [90,400,930,1230,1820,2380,2630,3100]:
		draw_texture_rect(ATLAS.frame("props",9),Rect2(x-40,687,76,73),false)
	for x in [240,720,1940,2490,2750,3180]:
		draw_texture_rect(ATLAS.frame("props",10),Rect2(x-20,730,44,30),false)
	for x in range(0,3800,125):
		if x>1300 and x<1760: continue
		draw_texture_rect(ATLAS.frame("props",8),Rect2(x,744,53,20),false)

func ground(rect: Rect2) -> void:
	draw_rect(rect,Color("53412d"))
	var x := rect.position.x
	while x < rect.end.x:
		var width := minf(256,rect.end.x-x)
		draw_texture_rect_region(GROUND,Rect2(x,rect.position.y,width,160),Rect2(0,0,width,160))
		x += width
