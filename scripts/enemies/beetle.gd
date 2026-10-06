extends Node2D
const BALANCE = preload("res://scripts/systems/game_balance.gd")
signal stomped(enemy: Node2D)

var level: Node2D
var origin := Vector2.ZERO
var direction := -1.0
var speed := BALANCE.BEETLE_SPEED
var patrol_distance := 110.0
var alert := false
var defeated := false

func _ready() -> void:
	origin = position
	add_to_group("enemies")
	var art := preload("res://scripts/presentation/enemy_art.gd").new()
	art.name = "EnemyArt"
	art.kind = "beetle"
	add_child(art)

func _physics_process(delta: float) -> void:
	if defeated or level.completed or level.respawning: return
	var player: CharacterBody2D = level.tico
	alert = absf(player.position.x-position.x)<210 and absf(player.position.y-position.y)<65
	if alert: direction = signf(player.position.x-position.x)
	position.x += direction*(BALANCE.BEETLE_ALERT_SPEED if alert else speed)*delta
	if absf(position.x-origin.x)>patrol_distance:
		position.x = origin.x+clampf(position.x-origin.x,-patrol_distance,patrol_distance)
		direction = -signf(position.x-origin.x)
	if absf(player.position.x-position.x)<38 and player.position.y>position.y-52 and player.position.y<position.y+24:
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
	direction = -1
	alert = false
	defeated = false
	show()
