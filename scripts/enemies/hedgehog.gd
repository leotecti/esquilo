extends Node2D
## Obstáculo vivo: espinhos sempre visíveis, rota de salto larga e segura.
var level: Node2D
var origin := Vector2.ZERO
var time := 0.0
var facing := 1.0
var defeated := false

func _ready() -> void:
	origin = position
	add_to_group("enemies")
	var art := preload("res://scripts/presentation/enemy_art.gd").new()
	art.name = "EnemyArt"
	art.kind = "hedgehog"
	add_child(art)

func _physics_process(delta: float) -> void:
	if defeated or level.completed or level.respawning: return
	time += delta
	position.x = origin.x + sin(time * 0.7) * 45
	facing = signf(cos(time*0.7))
	var player: CharacterBody2D = level.tico
	if player.controls_enabled and absf(player.position.x-position.x)<43 and player.position.y>position.y-45 and player.position.y<position.y+30:
		player.take_damage(global_position)
	queue_redraw()

func reset_enemy() -> void:
	time = 0
	position = origin
	facing = 1.0
	defeated = false
	show()

func receive_tail(_character: Node2D) -> bool:
	if defeated: return false
	defeated = true
	hide()
	return true

func _draw() -> void:
	for i in 7:
		var x := -28.0+i*8
		draw_colored_polygon(PackedVector2Array([Vector2(x-7,-16),Vector2(x,-44+absf(x)*0.3),Vector2(x+8,-16)]),Color("644531"))
	draw_circle(Vector2(0,-14),24,Color("ac7947"))
	draw_circle(Vector2(24,-11),12,Color("e5c293"))
	draw_circle(Vector2(28,-15),3,Color("342b28"))
	for x in [-14,12]: draw_circle(Vector2(x,-1),6,Color("60432e"))
