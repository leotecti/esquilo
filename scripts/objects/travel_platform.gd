extends AnimatableBody2D
var travel := Vector2(220,0)
var width := 180.0
var duration := 5.0
var clock := 0.0
var origin := Vector2.ZERO
var enabled := true
var wood := true

func _ready() -> void:
	origin = position
	sync_to_physics = false
	process_physics_priority = -20
	collision_layer = 1
	collision_mask = 0
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width,24)
	collision.shape = shape
	collision.position.y = 12
	add_child(collision)

func _physics_process(delta: float) -> void:
	if not enabled: return
	clock += delta
	position = origin + travel * (0.5-0.5*cos(clock*TAU/duration))
	# A aparência não muda durante o percurso. O CanvasItem acompanha a posição
	# sem reconstruir madeira, parafusos e cordas a cada quadro.

func _draw() -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = Color("b5814f") if wood else Color("8c9dab")
	box.border_color = Color("694c35") if wood else Color("4d6378")
	box.set_border_width_all(3)
	box.set_corner_radius_all(10)
	draw_style_box(box,Rect2(-width/2,0,width,24))
	for x in range(-int(width/2)+15,int(width/2)-10,30):
		draw_line(Vector2(x,4),Vector2(x,20),box.border_color,2)
		draw_circle(Vector2(x+7,7),2,Color("efdcab"))
	if travel.y!=0:
		draw_line(Vector2(-width/2+12,-30),Vector2(-width/2+12,0),Color("bcac7c"),3)
		draw_line(Vector2(width/2-12,-30),Vector2(width/2-12,0),Color("bcac7c"),3)
