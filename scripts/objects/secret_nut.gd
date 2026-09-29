extends "res://scripts/objects/nut.gd"
var revealed: bool = false
var scent_visible: bool = false
var scent_from: Vector2

func _draw() -> void:
	if revealed:
		super._draw()
	else:
		for x in [-22,0,22]:
			draw_circle(Vector2(x,12),20,Color("639550"))
	if scent_visible and not taken:
		var start := to_local(scent_from)
		for i in 5:
			var progress: float = fmod(_time * 0.7 + i * 0.2,1.0)
			var point := start.lerp(Vector2.ZERO,progress) + Vector2(0,sin(progress * TAU) * 12)
			draw_circle(point,4 + progress * 3,Color(1,0.9,0.55,0.8))

func reveal() -> void:
	revealed = true
	queue_redraw()
	for body in get_overlapping_bodies():
		_collect(body)

func _collect(body: Node2D) -> void:
	if revealed:
		super._collect(body)

func reset_item() -> void:
	revealed = false
	scent_visible = false
	super.reset_item()
