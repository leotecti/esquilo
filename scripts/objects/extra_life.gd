extends Area2D
var campaign: Node
var stage_id := 0
var taken := false

func _ready() -> void:
	set_meta("extra_life",true)
	collision_layer = 0
	collision_mask = 2
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 25
	shape.shape = circle
	add_child(shape)
	var portrait := Sprite2D.new()
	portrait.texture = preload("res://scripts/presentation/atlas_library.gd").frame("tico",0)
	portrait.scale = Vector2.ONE*(36.0/portrait.texture.get_height())
	portrait.position = Vector2(0,-9)
	portrait.material = ShaderMaterial.new()
	portrait.material.shader = preload("res://scripts/presentation/chroma_key.gdshader")
	add_child(portrait)
	body_entered.connect(_collect)

func _draw() -> void:
	draw_circle(Vector2(0,2),34,Color("34523e80"))
	draw_circle(Vector2.ZERO,32,Color("956628"))
	draw_circle(Vector2.ZERO,29,Color("f5ca64"))
	draw_circle(Vector2(0,-2),24,Color("fff1bf"))
	draw_arc(Vector2.ZERO,27,PI*1.05,PI*1.8,20,Color("fff8d6"),3,true)
	var badge := StyleBoxFlat.new()
	badge.bg_color = Color("31543e")
	badge.border_color = Color("ffe7a0")
	badge.set_border_width_all(2)
	badge.set_corner_radius_all(9)
	draw_style_box(badge,Rect2(-22,9,44,25))
	var font := ThemeDB.fallback_font
	var width := font.get_string_size("+1",HORIZONTAL_ALIGNMENT_LEFT,-1,20).x
	draw_string(font,Vector2(-width/2,29),"+1",HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("fff6d8"))

func _collect(body: Node2D) -> void:
	if taken or body!=campaign.level.tico or body.health<=0 or not body.controls_enabled: return
	if campaign.claim_life(stage_id):
		taken = true
		hide()
		set_deferred("monitoring",false)
