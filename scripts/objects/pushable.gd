extends CharacterBody2D
const BOULDER = preload("res://assets/objects/pushable_boulder.png")
@export var push_speed: float = 95.0
@export var max_travel: float = 340.0
var origin: Vector2
var guide_target_x: float = INF
var _time := 0.0

func _ready() -> void:
	origin = position

func _physics_process(delta: float) -> void:
	_time += delta
	velocity = Vector2(0, minf(velocity.y + 1200 * delta,900))
	move_and_slide()
	force_update_transform()
	queue_redraw()

func push_by(character: Node2D, direction: float, delta: float) -> bool:
	if not character.is_in_group("pipo") or not character.controls_enabled:
		return false
	var motion := clampf(position.x + direction * push_speed * delta, origin.x, origin.x + max_travel) - position.x
	if absf(motion) < 0.01:
		return false
	var before: float = position.x
	velocity = Vector2(motion / delta,0)
	move_and_slide()
	force_update_transform()
	return absf(position.x - before) > 0.01

func _draw() -> void:
	# Rocha ilustrada com volume, fissuras e musgo. O recorte mantém a base
	# alinhada à colisão para não parecer que a pedra flutua sobre o terreno.
	draw_texture_rect(BOULDER,Rect2(-50,-73,100,73),false)
	if position.x < guide_target_x:
		var lift := sin(_time*4.0)*3.0
		var arrow := PackedVector2Array([Vector2(-20,-100+lift),Vector2(8,-100+lift),Vector2(8,-109+lift),Vector2(27,-94+lift),Vector2(8,-79+lift),Vector2(8,-88+lift),Vector2(-20,-88+lift)])
		draw_colored_polygon(arrow,Color("ffe09a"))
		draw_polyline(arrow,Color("6b4d2e"),3.0,true)

func reset_puzzle() -> void:
	position = origin
	velocity = Vector2.ZERO
