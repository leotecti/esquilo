extends CharacterBody2D
@export var push_speed: float = 95.0
@export var max_travel: float = 340.0
var origin: Vector2

func _ready() -> void:
	origin = position

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, minf(velocity.y + 1200 * delta,900))
	move_and_slide()
	force_update_transform()

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
	draw_colored_polygon(PackedVector2Array([Vector2(-38,0),Vector2(-38,-44),Vector2(-25,-64),Vector2(22,-64),Vector2(38,-43),Vector2(38,0)]),Color("73817a"))
	draw_polyline(PackedVector2Array([Vector2(-29,-12),Vector2(-23,-47),Vector2(14,-51)]),Color("a9b5a0"),5)
	draw_line(Vector2(-5,-20),Vector2(18,-20),Color("d7dec6"),4)

func reset_puzzle() -> void:
	position = origin
	velocity = Vector2.ZERO
