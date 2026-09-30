extends StaticBody2D
signal activated(device: Node2D)
var mode := "weight"
var active := false
var level: Node2D
var held := 0.0

func _ready() -> void:
	collision_layer = 1 if mode=="charge" else 0
	collision_mask = 0
	if mode=="charge":
		var shape := RectangleShape2D.new()
		shape.size = Vector2(50,90)
		var collision := CollisionShape2D.new()
		collision.name = "Collision"
		collision.shape = shape
		collision.position.y = -45
		add_child(collision)

func _physics_process(delta: float) -> void:
	if active or mode!="weight" or level.completed: return
	var player: CharacterBody2D = level.tico
	if player.is_in_group("pipo") and player.is_on_floor() and absf(player.position.x-position.x)<48 and absf(player.position.y-position.y)<8:
		held += delta
		if held>=0.45: activate()
	else: held = 0
	queue_redraw()

func receive_charge(character: Node2D) -> bool:
	if active or mode!="charge" or not character.is_in_group("pipo") or character.ability!="charge": return false
	activate()
	return true

func activate(announce := true) -> void:
	if active: return
	active = true
	if has_node("Collision"): $Collision.set_deferred("disabled",true)
	if announce: activated.emit(self)
	queue_redraw()

func _draw() -> void:
	var color := Color("9bc778") if active else Color("dbac59")
	if mode=="weight":
		draw_rect(Rect2(-48,-6,96,8),Color("5a523e"))
		draw_rect(Rect2(-40,-10 if active else -16,80,8),color)
		draw_circle(Vector2(0,-28),8,color)
		if held>0: draw_arc(Vector2(0,-28),14,-PI/2,-PI/2+TAU*minf(held/.45,1),24,Color("fff0a3"),3)
	else:
		draw_rect(Rect2(-25,-90,50,90),Color("665e47"))
		for angle in range(0,360,45):
			var v := Vector2.from_angle(deg_to_rad(angle))*29
			draw_line(Vector2(0,-50)+v*.5,Vector2(0,-50)+v,color,8)
		draw_circle(Vector2(0,-50),21,color)
		draw_circle(Vector2(0,-50),9,Color("665e47"))
