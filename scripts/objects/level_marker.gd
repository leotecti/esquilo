extends Area2D
signal reached(marker: Node2D)
@export var finish: bool = false
var activated: bool = false

func _ready() -> void:
	body_entered.connect(_on_body)
	queue_redraw()

func _on_body(body: Node2D) -> void:
	if activated or not body.is_in_group("player") or not body.controls_enabled:
		return
	activated = true
	queue_redraw()
	reached.emit(self)

func _draw() -> void:
	if finish:
		draw_arc(Vector2(0,-40), 65, PI, TAU, 30, Color("664b35"), 14)
		draw_line(Vector2(-65,-40),Vector2(-65,0),Color("664b35"),14)
		draw_line(Vector2(65,-40),Vector2(65,0),Color("664b35"),14)
		for x in [-50, -25, 0, 25, 50]:
			draw_circle(Vector2(x,-100 + abs(x) * 0.4),20,Color("7caa62"))
		draw_circle(Vector2(0,-107),10,Color("f3ce71"))
	else:
		draw_line(Vector2.ZERO,Vector2(0,-108),Color("765b3b"),7)
		draw_colored_polygon(PackedVector2Array([Vector2(4,-105),Vector2(67,-87),Vector2(4,-66)]),Color("f4cd73") if activated else Color("81a8a0"))
		draw_circle(Vector2(22,-87),6,Color("fff3d9"))
		draw_circle(Vector2(0,-112),6,Color("f4cd73"))

func reset_marker() -> void:
	activated = false
	queue_redraw()
