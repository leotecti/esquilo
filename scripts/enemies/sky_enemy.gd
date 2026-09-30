extends Node2D
signal stomped(enemy: Node2D)
var level: Node2D
var origin := Vector2.ZERO
var clock := 0.0
var defeated := false

func _ready() -> void:
	origin = position
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if defeated or level.completed or level.respawning: return
	clock += delta
	position = origin+Vector2(sin(clock)*75,sin(clock*1.4)*24)
	var player: CharacterBody2D = level.tico
	if absf(player.position.x-position.x)<36 and player.position.y>position.y-22 and player.position.y<position.y+65:
		if player.velocity.y>0 and player.previous_position.y<=position.y-14:
			defeated = true
			player.bounce()
			hide()
			stomped.emit(self)
		else: player.take_damage(position)
	queue_redraw()

func reset_enemy() -> void:
	defeated = false
	position = origin
	clock = 0
	show()

func _draw() -> void:
	var tip := sin(clock*8)*12
	for direction in [-1,1]:
		draw_colored_polygon(PackedVector2Array([Vector2(direction*8,0),Vector2(direction*42,-20+tip),Vector2(direction*31,8),Vector2(direction*12,15)]),Color("778095"))
	draw_circle(Vector2.ZERO,18,Color("a099a6"))
	for x in [-7,7]:
		draw_circle(Vector2(x,-3),7,Color("f6e4bf"))
		draw_circle(Vector2(x,-3),3,Color("343b52"))
