extends Node2D
signal calmed
var level: Node2D
var health := 3
var phase := "waiting"
var remaining := 1.2
var invulnerable := 0.0
var elapsed := 0.0

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if level.completed or level.respawning or health == 0: return
	var player: CharacterBody2D = level.tico
	if absf(player.position.x-position.x)>650: return
	elapsed += delta
	invulnerable = maxf(0,invulnerable-delta)
	remaining -= delta
	if remaining <= 0:
		match phase:
			"waiting":
				phase = "warning"
				remaining = 1.2
				level._say("Raízes chegando! Pule quando o chão brilhar.")
			"warning":
				phase = "attack"
				remaining = 0.45
			"attack":
				phase = "tired"
				remaining = 3.2
				level._say("Agora! Pule no Guardião ou use a investida de Pipo.")
			"tired":
				phase = "waiting"
				remaining = 1.4
	var offset: Vector2 = player.position-position
	if phase == "attack" and absf(offset.x)<250 and offset.y > -38 and offset.y < 20:
		player.take_damage(position)
	if absf(offset.x)<68 and offset.y > -125 and offset.y<20:
		var stomp: bool = player.velocity.y>0 and player.previous_position.y<=position.y-100
		var charge: bool = player.is_in_group("pipo") and player.ability=="charge"
		if phase == "tired" and (stomp or charge):
			if receive_hit():
				if stomp: player.bounce()
		elif invulnerable<=0:
			player.take_damage(position)
	queue_redraw()

func receive_hit() -> bool:
	if phase != "tired" or invulnerable>0 or health<=0: return false
	health -= 1
	# Permite terminar a recuperação da investida e sair do corpo do Guardião.
	invulnerable = 2.0
	level.puff(position+Vector2(0,-90),Color("ffd877"),12)
	level.sounds.play_effect("impact")
	if health == 0:
		phase = "calm"
		calmed.emit()
	else:
		phase = "waiting"
		remaining = 1.4
	queue_redraw()
	return true

func reset_enemy() -> void:
	if health == 0: return
	health = 3
	phase = "waiting"
	remaining = 1.2
	invulnerable = 0
	queue_redraw()

func _draw() -> void:
	var bark := Color("a98555") if phase == "tired" else Color("715333")
	if phase == "calm": bark = Color("ad9964")
	if phase in ["warning","attack"]:
		for x in range(-240,241,40):
			draw_line(Vector2(x,0),Vector2(x+15,-30 if phase=="attack" else -3),Color("efbb58"),8)
	for x in [-50,50]:
		draw_line(Vector2(x,0),Vector2(x*0.7,-45),bark,22)
	draw_style_box(_trunk(bark),Rect2(-55,-120,110,115))
	for x in [-48,0,48]:
		draw_circle(Vector2(x,-133+absf(x)*0.4),48,Color("547748") if health>0 else Color("80a659"))
	for x in [-22,22]:
		draw_circle(Vector2(x,-78),10,Color("fff0cf"))
		draw_circle(Vector2(x,-76),4,Color("393b2b"))
	draw_arc(Vector2(0,-53),15,0,PI,16,Color("3b3828"),3)
	if phase == "tired": draw_arc(Vector2(0,-125),68,PI,TAU,32,Color("ffe29b"),5)
	for i in 3:
		draw_circle(Vector2(-26+i*26,-195),8,Color("f4cf73") if i<health else Color("687552"))

func _trunk(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(22)
	return style
