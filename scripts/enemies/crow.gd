extends Node2D
signal stomped(enemy: Node2D)

var level: Node2D
var origin := Vector2.ZERO
var clock := 0.0
var facing := -1.0
var chasing := false
var defeated := false

func _ready() -> void:
	origin = position
	add_to_group("enemies")
	var art := preload("res://scripts/presentation/enemy_art.gd").new()
	art.name = "EnemyArt"
	art.kind = "crow"
	add_child(art)

func _physics_process(delta: float) -> void:
	if defeated or level.completed or level.respawning: return
	clock += delta
	var player: CharacterBody2D = level.tico
	var distance := player.position.distance_to(position)
	chasing = distance<280 and player.controls_enabled
	var target := player.position+Vector2(0,-55) if chasing else origin+Vector2(sin(clock*.8)*105,sin(clock*1.3)*28)
	var previous_x := position.x
	position = position.move_toward(target,(145.0 if chasing else 80.0)*delta)
	if not is_zero_approx(position.x-previous_x): facing = signf(position.x-previous_x)
	if absf(player.position.x-position.x)<44 and absf(player.position.y-position.y)<55:
		if player.velocity.y>0 and player.previous_position.y<=position.y-28:
			_defeat(player)
		else: player.take_damage(position)

func _defeat(player: CharacterBody2D = null) -> bool:
	if defeated: return false
	defeated = true
	if is_instance_valid(player): player.bounce()
	stomped.emit(self)
	hide()
	return true

func receive_tail(_character: Node2D) -> bool: return _defeat()

func reset_enemy() -> void:
	position = origin
	clock = 0
	facing = -1
	chasing = false
	defeated = false
	show()
