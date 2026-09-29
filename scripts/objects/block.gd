extends StaticBody2D
signal opened(block: Node2D, reward: bool)
@export_enum("Comum", "Quebrável", "Noz") var kind: int = 0
var used: bool = false

func _draw() -> void:
	draw_style_box(_style(), Rect2(-28, -28, 56, 56))
	if kind == 1 and not used:
		draw_polyline(PackedVector2Array([Vector2(-4,-23),Vector2(6,-6),Vector2(-8,8),Vector2(4,23)]),Color("4d352a"),4)
	elif kind == 2:
		draw_circle(Vector2.ZERO, 12, Color("a58965") if used else Color("ffe0a0"))
		draw_line(Vector2(-10,-5),Vector2(10,-5),Color("715337"),4)

func _style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("776b58") if used else (Color("d59b44") if kind == 2 else Color("ac7954"))
	style.border_color = Color("5a4334")
	style.set_border_width_all(3)
	style.set_corner_radius_all(7)
	return style

func hit_from_below() -> void:
	if used or kind == 0:
		return
	used = true
	if kind == 1:
		hide()
		$Collision.set_deferred("disabled", true)
	queue_redraw()
	opened.emit(self, kind == 2)

func reset_block() -> void:
	used = false
	show()
	$Collision.set_deferred("disabled", false)
	queue_redraw()
