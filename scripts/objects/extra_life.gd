extends Area2D
var campaign: Node
var stage_id := 0
var taken := false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 25
	shape.shape = circle
	add_child(shape)
	var label := Label.new()
	label.text = "+1\nVIDA"
	label.position = Vector2(-22,-24)
	label.size = Vector2(44,48)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color",Color("244b37"))
	label.add_theme_font_size_override("font_size",18)
	add_child(label)
	body_entered.connect(_collect)

func _draw() -> void:
	draw_circle(Vector2.ZERO,29,Color("244b37"))
	draw_circle(Vector2.ZERO,25,Color("ffe09a"))

func _collect(body: Node2D) -> void:
	if taken or body!=campaign.level.tico or body.health<=0 or not body.controls_enabled: return
	if campaign.claim_life(stage_id):
		taken = true
		hide()
		set_deferred("monitoring",false)
