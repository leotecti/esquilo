extends "res://scripts/objects/pushable.gd"
signal activated(device: Node2D)
var active := false

func _physics_process(delta: float) -> void:
	if active: return
	super._physics_process(delta)
	if position.x >= origin.x + max_travel - 4: activate()

func push_by(character: Node2D, direction: float, delta: float) -> bool:
	if active: return false
	return super.push_by(character,direction,delta)

func activate(announce := true) -> void:
	if active: return
	active = true
	$Collision.set_deferred("disabled",true)
	hide()
	if announce: activated.emit(self)

func _draw() -> void:
	draw_rect(Rect2(-38,-60,76,60),Color("997043"))
	for y in [-50,-30,-10]: draw_line(Vector2(-34,y),Vector2(35,y+3),Color("654831"),4)
	draw_circle(Vector2(27,-30),22,Color("d6ae73"))
	draw_arc(Vector2(27,-30),14,0,TAU,24,Color("96704a"),3)
