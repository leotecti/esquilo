extends Node2D
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
var level: Node2D

func _process(_delta: float) -> void:
	visible = not level.rescued

func _draw() -> void:
	# Cipó preso ao bloco rachado: o caminho visual explica o resgate.
	draw_polyline(PackedVector2Array([Vector2(490,610),Vector2(490,560),Vector2(665,560),Vector2(665,750)]),Color("6e7845"),7,true)
	for x in [570,600,630,660]:
		draw_line(Vector2(x,660),Vector2(x,755),Color("73834ce0"),5,true)
	draw_line(Vector2(560,660),Vector2(670,660),Color("859655"),8,true)
	draw_line(Vector2(560,750),Vector2(670,750),Color("5b743e"),7,true)
	for x in [702,720]: draw_line(Vector2(x,455),Vector2(x,760),Color("6b7040"),8,true)
	for y in range(475,750,38):
		draw_texture_rect(ATLAS.frame("props",7),Rect2(682,y-22,58,44),false)
