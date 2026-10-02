extends Area2D
signal collected(item: Node2D)
@export var healing: bool = false
var taken: bool = false
var campaign: Node
var life_reward := false
var _time: float = 0.0

func _ready() -> void:
	body_entered.connect(_collect)
	queue_redraw()

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _physics_process(_delta: float) -> void:
	# Um coração recusado com saúde cheia continua utilizável sem sair da área.
	if not healing or taken: return
	for body in get_overlapping_bodies():
		_collect(body)
		if taken: break

func _draw() -> void:
	var offset := Vector2(0, sin(_time * 3.0) * 3.0)
	if healing:
		draw_circle(offset, 20, Color("fff2cf"))
		draw_line(offset + Vector2(-10, 0), offset + Vector2(10, 0), Color("ce5c61"), 7)
		draw_line(offset + Vector2(0, -10), offset + Vector2(0, 10), Color("ce5c61"), 7)
	else:
		draw_circle(offset, 16, Color("6e412d"))
		draw_circle(offset + Vector2(0, 3), 12, Color("d8964e"))
		draw_arc(offset + Vector2(0, -2), 14, PI, TAU, 16, Color("8d623c"), 7)
		draw_line(offset + Vector2(1, -16), offset + Vector2(4, -23), Color("5b753f"), 4)
		draw_line(offset + Vector2(-3, 1), offset + Vector2(-3, 9), Color("f5c47b"), 3)

func _collect(body: Node2D) -> void:
	if taken or not body.is_in_group("player") or not body.controls_enabled:
		return
	var body_shape: CollisionShape2D = body.get_node("Collision")
	var body_rect: Rect2 = body_shape.global_transform * body_shape.shape.get_rect()
	var area_rect: Rect2 = $Collision.global_transform * $Collision.shape.get_rect()
	if not area_rect.intersects(body_rect):
		return
	if healing and not body.recover():
		if body.health!=body.max_health or not is_instance_valid(campaign) or campaign.data.survival.lives>=99: return
		life_reward = true
	taken = true
	hide()
	collected.emit(self)

func reset_item() -> void:
	taken = false
	life_reward = false
	show()
