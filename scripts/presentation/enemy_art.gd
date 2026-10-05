extends Node2D

const MOVE_SHEETS := {
	"slug":preload("res://assets/enemies/animation/slug_move.png"),
	"beetle":preload("res://assets/enemies/animation/beetle_move.png"),
	"spider":preload("res://assets/enemies/animation/spider_move.png"),
	"bat":preload("res://assets/enemies/animation/bat_move.png"),
	"hedgehog":preload("res://assets/enemies/animation/hedgehog_move.png"),
	"crow":preload("res://assets/enemies/animation/crow_move.png")
}
const HEIGHTS := {"slug":68.0,"beetle":72.0,"spider":82.0,"bat":88.0,"hedgehog":88.0,"crow":92.0}
const FRAME_SIZE := Vector2(512,384)
const GROUND_BASELINE_PX := 368.0
const FPS := {"slug":5.0,"beetle":7.0,"spider":6.0,"bat":9.0,"hedgehog":6.0,"crow":8.0}

var kind := "slug"
var enemy: Node2D
var clock := 0.0
var animation_frame := 0

func _ready() -> void:
	enemy = get_parent()
	enemy.self_modulate.a = 0.0
	z_index = 2
	queue_redraw()

func _process(delta: float) -> void:
	if not is_instance_valid(enemy) or not enemy.visible: return
	clock += delta
	var rate: float = FPS.get(kind,6.0)
	if kind=="beetle" and enemy.alert: rate = 11.0
	animation_frame = int(clock*rate)%4
	var screen_position := get_viewport().get_canvas_transform()*global_position
	var viewport_size := get_viewport_rect().size
	if screen_position.x < -140 or screen_position.x > viewport_size.x+140 or screen_position.y < -200 or screen_position.y > viewport_size.y+160: return
	queue_redraw()

func _draw() -> void:
	if not is_instance_valid(enemy) or not MOVE_SHEETS.has(kind): return
	var texture: Texture2D = MOVE_SHEETS[kind]
	var height: float = HEIGHTS[kind]
	var size := FRAME_SIZE*(height/FRAME_SIZE.y)
	var facing := 1.0
	if kind in ["slug","beetle"]: facing = float(enemy.direction)
	elif kind in ["hedgehog","crow"]: facing = float(enemy.facing)
	if kind=="spider":
		var anchor_y: float = enemy.origin.y-enemy.position.y-170.0
		draw_line(Vector2(0,anchor_y),Vector2(0,-height*.62),Color("e9e3d0b0"),2)
	if kind=="beetle" and enemy.alert: draw_arc(Vector2(0,-42),32,PI,TAU,18,Color("ffd86f"),3)
	if kind=="crow" and enemy.chasing: draw_arc(Vector2(0,-55),38,PI,TAU,18,Color("f2c95f"),3)
	var scale_value := Vector2(facing,1.0)
	if enemy.defeated: scale_value.y = 0.35
	draw_set_transform(Vector2.ZERO,0.0,scale_value)
	var ground_offset := 0.0
	if kind in ["slug","beetle","hedgehog"]:
		ground_offset = (FRAME_SIZE.y-GROUND_BASELINE_PX)*(height/FRAME_SIZE.y)
	var destination := Rect2(Vector2(-size.x*.5,-size.y+ground_offset),size)
	var source := Rect2(Vector2(animation_frame*FRAME_SIZE.x,0),FRAME_SIZE)
	draw_texture_rect_region(texture,destination,source)
