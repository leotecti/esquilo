extends Node2D
signal stomped(enemy: Node2D)

var level: Node2D
var origin := Vector2.ZERO
var clock := 0.0
var travel := 105.0
var defeated := false

func _ready() -> void:
	origin = position
	add_to_group("enemies")
	var art := preload("res://scripts/presentation/enemy_art.gd").new()
	art.name = "EnemyArt"
	art.kind = "spider"
	add_child(art)

func _physics_process(delta: float) -> void:
	if defeated or level.completed or level.respawning: return
	clock += delta
	position.y = origin.y+sin(clock*1.25)*travel
	var player: CharacterBody2D = level.tico
	if absf(player.position.x-position.x)<42 and absf(player.position.y-position.y)<48:
		if player.velocity.y>0 and player.previous_position.y<=position.y-26:
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
	defeated = false
	show()
