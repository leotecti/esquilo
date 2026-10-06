extends CharacterBody2D
const BALANCE = preload("res://scripts/systems/game_balance.gd")
signal stomped(enemy: Node2D)
@export var patrol_distance: float = 130.0
@export var speed: float = BALANCE.SLUG_SPEED
var defeated: bool = false
var direction: float = -1.0
var origin: Vector2
var _defeat_time: float = 0.0

func _ready() -> void:
	origin = position
	var art := preload("res://scripts/presentation/enemy_art.gd").new()
	art.name = "EnemyArt"
	art.kind = "slug"
	add_child(art)

func _physics_process(delta: float) -> void:
	if defeated:
		_defeat_time += delta
		modulate.a = maxf(0.0, 1.0 - _defeat_time)
		queue_redraw()
		return
	if is_on_wall() and velocity.x==0:
		direction = signf(get_wall_normal().x)
	elif (position.x-origin.x)*direction>=patrol_distance:
		direction *= -1.0
	$FloorAhead.position.x = direction * 30.0
	$FloorAhead.force_raycast_update()
	var can_walk := true
	if is_on_floor() and not $FloorAhead.is_colliding():
		# Só vira se houver chão do outro lado; evita oscilar em espaços estreitos.
		$FloorAhead.position.x = -direction * 30.0
		$FloorAhead.force_raycast_update()
		if $FloorAhead.is_colliding(): direction *= -1.0
		else: can_walk = false
	velocity = Vector2(direction * speed if can_walk else 0.0, minf(velocity.y + 1200.0 * delta, 900.0))
	move_and_slide()
	for body in $Contact.get_overlapping_bodies():
		if not body.is_in_group("player") or not body.controls_enabled:
			continue
		var player_shape: CollisionShape2D = body.get_node("Collision")
		var player_rect: Rect2 = player_shape.global_transform * player_shape.shape.get_rect()
		var contact_rect: Rect2 = $Contact/Collision.global_transform * $Contact/Collision.shape.get_rect()
		if not contact_rect.intersects(player_rect):
			continue
		if body.is_in_group("pipo") and body.ability == "charge":
			defeated = true
			stomped.emit(self)
			break
		if _is_stomp(body,player_rect,contact_rect):
			defeated = true
			body.bounce()
			stomped.emit(self)
			break
		body.take_damage(global_position)
	queue_redraw()

func _is_stomp(body: CharacterBody2D, player_rect: Rect2, contact_rect: Rect2) -> bool:
	# A Area2D pode ser processada um quadro depois do cruzamento. Nesse quadro a
	# física já pode ter reduzido a velocidade vertical; usa também a trajetória
	# anterior e exige que os pés estejam na metade superior da lesma.
	if body.velocity.y < -20.0: return false
	var feet_y := player_rect.end.y
	var came_from_above: bool = body.previous_position.y <= global_position.y-14.0
	var still_above: bool = feet_y <= contact_rect.get_center().y+5.0 and body.global_position.y < global_position.y-6.0
	return came_from_above or still_above

func _draw() -> void:
	var h: float = 0.45 if defeated else 1.0
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, h))
	draw_style_box(_body_style(), Rect2(-30,-24,60,24))
	for spot in [Vector2(-18,-15), Vector2(-4,-17), Vector2(8,-13)]:
		draw_circle(spot, 4, Color("a8be76"))
	for x in [16.0, 25.0]:
		var eye := Vector2(x * direction, -34)
		draw_line(Vector2(x * direction,-17),eye,Color("57764e"),4)
		draw_circle(eye,5,Color("fff3d9"))
		if defeated:
			draw_line(eye + Vector2(-3,0),eye + Vector2(3,0),Color("344931"),2)
		else:
			draw_circle(eye + Vector2(direction,0),2,Color("344931"))

func _body_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("719b60")
	style.set_corner_radius_all(12)
	return style

func reset_enemy() -> void:
	position = origin
	velocity = Vector2.ZERO
	direction = -1.0
	defeated = false
	_defeat_time = 0.0
	modulate.a = 1.0
	queue_redraw()

func receive_tail(_character: Node2D) -> bool:
	if defeated: return false
	defeated = true
	stomped.emit(self)
	return true
