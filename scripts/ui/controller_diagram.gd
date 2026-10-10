extends Control

var bindings: Dictionary = {}


func update_bindings(value: Dictionary) -> void:
	bindings = value.duplicate()
	queue_redraw()


func _draw() -> void:
	var center := size * Vector2(0.5, 0.52)
	var body := Rect2(center - Vector2(235, 92), Vector2(470, 184))
	draw_style_box(_box(Color("31543e"), Color("91ad78"), 46), body)
	draw_circle(center + Vector2(-172, 15), 70, Color("274535"))
	draw_circle(center + Vector2(172, 15), 70, Color("274535"))
	draw_rect(Rect2(center + Vector2(-196, -31), Vector2(48, 92)), Color("e4d7b5"), true)
	draw_rect(Rect2(center + Vector2(-218, -9), Vector2(92, 48)), Color("e4d7b5"), true)
	draw_circle(center + Vector2(-172, 15), 14, Color("6d624f"))
	draw_set_transform(center + Vector2(-36, 38), -0.18)
	draw_rect(Rect2(-28, -8, 56, 16), Color("d8c69e"), true)
	draw_set_transform(center + Vector2(36, 38), -0.18)
	draw_rect(Rect2(-28, -8, 56, 16), Color("e6b95c"), true)
	draw_set_transform(Vector2.ZERO, 0.0)
	var face := {0: Vector2(172, 52), 1: Vector2(209, 15), 2: Vector2(135, 15), 3: Vector2(172, -22)}
	var colors := {0: Color("e9c95d"), 1: Color("d97857"), 2: Color("7cb58a"), 3: Color("709ac2")}
	var labels := {0: "B", 1: "A", 2: "Y", 3: "X"}
	for index in face:
		var point: Vector2 = center + face[index]
		draw_circle(point, 22, colors[index])
		draw_circle(point, 22, Color("fff3ce"), false, 3)
		draw_string(ThemeDB.fallback_font, point + Vector2(-7, 7), labels[index], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("203d31"))
	draw_style_box(_box(Color("466e49"), Color("d9ca83"), 12), Rect2(center + Vector2(-205, -112), Vector2(112, 28)))
	draw_style_box(_box(Color("466e49"), Color("d9ca83"), 12), Rect2(center + Vector2(93, -112), Vector2(112, 28)))
	draw_string(ThemeDB.fallback_font, center + Vector2(-164, -91), "L", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("fff1ce"))
	draw_string(ThemeDB.fallback_font, center + Vector2(146, -91), "R", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("fff1ce"))


func _box(color: Color, border: Color, radius: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(3)
	box.set_corner_radius_all(radius)
	return box
