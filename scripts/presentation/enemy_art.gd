extends Node2D

const TEXTURES := {
	"slug":preload("res://assets/enemies/slug.png"),
	"beetle":preload("res://assets/enemies/beetle.png"),
	"spider":preload("res://assets/enemies/spider.png"),
	"bat":preload("res://assets/enemies/bat.png"),
	"hedgehog":preload("res://assets/enemies/hedgehog.png"),
	"crow":preload("res://assets/enemies/crow.png")
}
const HEIGHTS := {"slug":68.0,"beetle":72.0,"spider":82.0,"bat":88.0,"hedgehog":88.0,"crow":92.0}

var kind := "slug"
var enemy: Node2D
var clock := 0.0

func _ready() -> void:
	enemy = get_parent()
	enemy.self_modulate.a = 0.0
	z_index = 2
	queue_redraw()

func _process(delta: float) -> void:
	clock += delta
	if not is_instance_valid(enemy) or not enemy.visible: return
	var screen_position := get_viewport().get_canvas_transform()*global_position
	var viewport_size := get_viewport_rect().size
	if screen_position.x < -140 or screen_position.x > viewport_size.x+140 or screen_position.y < -200 or screen_position.y > viewport_size.y+160: return
	queue_redraw()

func _draw() -> void:
	if not is_instance_valid(enemy) or not TEXTURES.has(kind): return
	var texture: Texture2D = TEXTURES[kind]
	var height: float = HEIGHTS[kind]
	var size := texture.get_size()*(height/texture.get_height())
	var facing := 1.0
	if kind in ["slug","beetle"]: facing = float(enemy.direction)
	elif kind in ["hedgehog","crow"]: facing = float(enemy.facing)
	var bob := 0.0
	var angle := 0.0
	var squash := Vector2.ONE
	if kind=="slug":
		bob = sin(clock*4.0)*1.5
	elif kind=="beetle":
		bob = -absf(sin(clock*(11.0 if enemy.alert else 6.0)))*2.0
		angle = sin(clock*8.0)*0.025
		if enemy.alert: draw_arc(Vector2(0,-42),32,PI,TAU,18,Color("ffd86f"),3)
	elif kind=="spider":
		draw_line(Vector2(0,-170),Vector2(0,-height*.65),Color("e9e3d0b0"),2)
		bob = sin(clock*5.0)*1.0
	elif kind=="bat":
		squash.y = 0.92+sin(clock*8.0)*0.08
		angle = sin(clock*3.0)*0.04
	elif kind=="hedgehog":
		bob = sin(clock*3.0)*1.0
	elif kind=="crow":
		squash.y = 0.94+sin(clock*7.0)*0.06
		angle = sin(clock*2.5)*0.035
		if enemy.chasing: draw_arc(Vector2(0,-55),38,PI,TAU,18,Color("f2c95f"),3)
	if enemy.get("defeated")==true: squash.y = 0.35
	draw_set_transform(Vector2(0,bob),angle,Vector2(facing*squash.x,squash.y))
	draw_texture_rect(texture,Rect2(Vector2(-size.x*.5,-size.y),size),false)
