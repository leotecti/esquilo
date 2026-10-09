extends "res://scripts/objects/pushable.gd"
signal activated(device: Node2D)
const MOSSY_BOULDER = preload("res://assets/objects/pushable_boulder.png")
const VISUAL_STYLE_VERSION := 2
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
	# Rocha arredondada e pesada, com base assentada, fissuras e musgo do rio.
	# A colisão aprovada permanece igual; somente a leitura visual é refinada.
	draw_set_transform(Vector2(0,-2),0.0,Vector2(1.45,.28))
	draw_circle(Vector2(0,5),32,Color(0.08,0.14,0.13,.30))
	draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)
	draw_set_transform(Vector2(0,-2),0.0,Vector2(1.10,1.0))
	draw_texture_rect(MOSSY_BOULDER,Rect2(-54,-78,108,78),false,Color("d7e0d5"))
	draw_set_transform(Vector2.ZERO,0.0,Vector2.ONE)
	# Detalhes claros continuam legíveis em telas pequenas.
	draw_polyline(PackedVector2Array([Vector2(-15,-56),Vector2(-5,-43),Vector2(-12,-29),Vector2(2,-18)]),Color("52625b"),3,true)
	draw_polyline(PackedVector2Array([Vector2(20,-63),Vector2(11,-49),Vector2(22,-39)]),Color("718077"),2,true)
	for point in [Vector2(-28,-61),Vector2(-12,-69),Vector2(5,-68),Vector2(25,-58)]:
		draw_circle(point,6,Color("68864e"))
		draw_circle(point+Vector2(2,-2),3,Color("91ad62"))
	if position.x<origin.x+max_travel-4:
		var lift := sin(_time*3.2)*2.0
		draw_colored_polygon(PackedVector2Array([Vector2(-17,-99+lift),Vector2(8,-99+lift),Vector2(8,-108+lift),Vector2(27,-93+lift),Vector2(8,-78+lift),Vector2(8,-87+lift),Vector2(-17,-87+lift)]),Color("f5dda0"))
		draw_polyline(PackedVector2Array([Vector2(-17,-99+lift),Vector2(8,-99+lift),Vector2(8,-108+lift),Vector2(27,-93+lift),Vector2(8,-78+lift),Vector2(8,-87+lift),Vector2(-17,-87+lift)]),Color("5b4b39"),3,true)
