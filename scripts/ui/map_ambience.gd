extends Control
var world := 0
var time := 0.0
var _redraw_left := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _process(delta: float) -> void:
	time += delta
	_redraw_left -= delta
	if _redraw_left<=0:
		_redraw_left = 1.0/30.0
		queue_redraw()

func _draw() -> void:
	for i in 10:
		var p := Vector2(fposmod(i*173.0+time*(6+i%3),size.x),170+fposmod(i*71.0+sin(time*.35+i)*22,maxf(1,size.y-330)))
		var alpha := .12+.22*(.5+.5*sin(time*1.4+i))
		var color := Color(1,.93,.63,alpha) if world!=2 else Color(1,1,1,alpha)
		draw_circle(p,5,Color(color,.08))
		draw_circle(p,1.8,color)
