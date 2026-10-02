extends "res://scripts/enemies/forest_guardian.gd"
var biome := 2
var origin := Vector2.ZERO

func _ready() -> void:
	super._ready()
	origin = position

func _physics_process(delta: float) -> void:
	if level.completed or level.respawning or health==0: return
	var player: CharacterBody2D = level.tico
	if absf(player.position.x-origin.x)>750: return
	if biome==4 and not level.mechanisms["Arena"].active: return
	elapsed += delta
	invulnerable = maxf(0,invulnerable-delta)
	remaining -= delta
	if remaining<=0:
		match phase:
			"waiting":
				phase = "warning"
				remaining = 1.2
				level._say(["A água vai subir! Salte para o tronco.","O Gavião vai mergulhar! Espere na plataforma.","Engrenagens chegando! Pule e espere a abertura."][biome-2])
			"warning":
				phase = "attack"
				remaining = 0.7
			"attack":
				phase = "tired"
				remaining = 4.0
				level._say("Agora! Salte por cima com Tico." if biome>2 else "Agora! Salte ou use a investida de Pipo.")
			"tired":
				phase = "waiting"
				remaining = 1.4
	if biome==3:
		var height := 0.0 if phase=="tired" else 125.0
		if phase=="attack": height *= maxf(0,remaining/0.7)
		position.y = move_toward(position.y,origin.y-height,delta*260)
	var offset: Vector2 = player.position-origin
	if phase=="attack" and absf(offset.x)<(270 if biome==2 else 180) and offset.y>(-65 if biome==2 else -45) and offset.y<25:
		player.take_damage(position)
	var contact: Vector2 = player.position-position
	if absf(contact.x)<65 and contact.y>-115 and contact.y<20:
		var stomp: bool = player.velocity.y>0 and player.previous_position.y<=position.y-90
		var charge: bool = biome==2 and player.is_in_group("pipo") and player.ability=="charge"
		if phase=="tired" and ((stomp and (biome==2 or player==level.squirrel)) or charge):
			if receive_hit() and stomp: player.bounce()
		elif invulnerable<=0: player.take_damage(position)
	queue_redraw()

func reset_enemy() -> void:
	super.reset_enemy()
	position = origin

func _draw() -> void:
	var color: Color = [Color("659dac"),Color("755342"),Color("ab794f")][biome-2]
	if health==0: color = color.lightened(.15)
	if phase in ["warning","attack"]:
		var y: float = origin.y-position.y
		if biome==2:
			draw_rect(Rect2(-270,y-60 if phase=="attack" else y-6,540,65 if phase=="attack" else 6),Color("6cd3dda0"))
		else:
			for x in range(-180,181,60):
				draw_circle(Vector2(x,y-20),15 if phase=="attack" else 5,Color("f0c87b"))
	if biome==3:
		for side in [-1,1]:
			var lift := -25.0 if phase=="tired" else sin(elapsed*6)*25-45
			draw_colored_polygon(PackedVector2Array([Vector2(side*25,-55),Vector2(side*120,-85+lift),Vector2(side*90,-35),Vector2(side*35,-15)]),color.darkened(.12))
	elif biome==4:
		draw_set_transform(Vector2(-58,-22),-.5)
		draw_style_box(_trunk(color.darkened(.25)),Rect2(-40,-25,80,50))
		draw_set_transform(Vector2.ZERO)
	draw_style_box(_trunk(color.darkened(.2)),Rect2(-56,-115,112,115))
	draw_style_box(_trunk(color),Rect2(-50,-111,100,104))
	if biome==4:
		for x in [-38,38]: draw_circle(Vector2(x,-105),17,color)
		for x in [-9,9]: draw_rect(Rect2(x-7,-45,14,22),Color("fff1cf"))
	for x in [-22,22]:
		draw_circle(Vector2(x,-75),19,Color("e9d8b4"))
		draw_circle(Vector2(x,-74),7,Color("34454d"))
	if biome==3:
		draw_colored_polygon(PackedVector2Array([Vector2(-18,-61),Vector2(23,-57),Vector2(0,-37)]),Color("e6a83f"))
		draw_line(Vector2(-39,-101),Vector2(-8,-91),Color("3a2923"),7)
		draw_line(Vector2(39,-101),Vector2(8,-91),Color("3a2923"),7)
	else: draw_arc(Vector2(0,-42),18,0,PI,18,Color("493e34"),3)
	for i in 3: draw_circle(Vector2(-26+i*26,-148),8,Color("f6d584") if i<health else Color("677b80"))
	if phase=="tired": draw_arc(Vector2(0,-112),67,PI,TAU,32,Color("ffe6a0"),4)
