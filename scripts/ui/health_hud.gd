extends Control
var health: int = 3

func _draw() -> void:
	for i in 3:
		var center := Vector2(18 + i * 44, 18)
		var color := Color("d96c69") if i < health else Color("8eaaa0")
		draw_circle(center + Vector2(-7,-5),9,color)
		draw_circle(center + Vector2(7,-5),9,color)
		draw_colored_polygon(PackedVector2Array([center+Vector2(-16,-3),center+Vector2(16,-3),center+Vector2(0,18)]),color)
