extends RefCounted
## Fase modelo: trechos curtos de subida, travessia e recuperação.
const WIDTH := 42000
const FINISH := Vector2(41780,550)
const COPA_X := 21000

static func build(level) -> void:
	level.main_right = WIDTH
	level.checkpoint.position = Vector2(24100,760)
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level._platform(Rect2(3800,760,WIDTH-3800,200))
	# Preserva as posições das recompensas das versões anteriores.
	for rect in [Rect2(3780,650,260,110),Rect2(4100,700,260,60),Rect2(4350,620,240,140),Rect2(4610,550,560,210)]: level._platform(rect)
	for point in [Vector2(3890,606),Vector2(4170,656),Vector2(4420,576),Vector2(4700,506),Vector2(4870,506),Vector2(4960,506)]: level._nut(point)
	# As duas lesmas antigas nas escadas foram removidas: o espaço estreito entre
	# paredes prejudicava a patrulha e a leitura da animação. Os trechos ampliados
	# mantêm os encontros em plataformas abertas.
	var profiles := [[760,680,590,500,590,680,760,760],
		[760,760,680,590,500,590,680,760],
		[760,680,600,600,680,600,680,760]]
	var old_profiles := [[760,680,590,500,590,680,760,760],
		[760,760,680,580,480,580,680,760],[760,660,560,560,660,560,660,760]]
	for section in 11:
		var origin := 5200+section*3200
		var heights: Array = profiles[section%3]
		for step in 8:
			var x := origin+step*400
			var y: int = heights[step]
			if y<760: level._platform(Rect2(x,y,400,760-y))
			# Grupos indicam a rota; pausas entre eles evitam uma linha contínua.
			if not (section==4 and step==7):
				for offset in [115,215]:
					level._nut(Vector2(x+offset,y-44))
					level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","%d:%d" % [x+offset,old_profiles[section%3][step]-44])
			if step==4 and section%2==0: level._slug(Vector2(x+270,y),65)
		if section in [1,4,7,10]:
			level._nut(Vector2(origin+260,715),true)
	# Área de chegada mais tranquila depois do último conjunto de subidas.
	for rect in [Rect2(20700,680,140,80),Rect2(20840,610,140,150)]: level._platform(rect)
	for point in [Vector2(20760,636),Vector2(20890,566)]: level._nut(point)
	for rect in [Rect2(40500,690,400,70),Rect2(40900,620,400,140),Rect2(41300,550,650,210)]: level._platform(rect)
	for point in [Vector2(40620,646),Vector2(40780,646),Vector2(41020,576),Vector2(41180,576),Vector2(41420,506),Vector2(41580,506)]: level._nut(point)
	level.exit_marker.position = FINISH
	# Apoios para regressar pelos desníveis antigos e subir à árvore pela direita.
	for rect in [Rect2(1240,690,140,70),Rect2(3730,620,140,140),
		Rect2(5170,640,160,120),Rect2(5330,710,160,50),
		Rect2(21100,610,140,150),Rect2(21240,680,140,80)]: level._platform(rect)
	# Ao elevar um apoio, mantém o ID histórico da recompensa e deixa-a acima do chão.
	for actor in level.actors.get_children():
		if not actor.has_method("reset_item"): continue
		if not actor.has_meta("save_id"): actor.set_meta("save_id","%d:%d" % [actor.position.x,actor.position.y])
		for rect in level.terrain:
			if actor.position.x>=rect.position.x and actor.position.x<rect.end.x and actor.position.y>rect.position.y-44:
				actor.position.y = rect.position.y-44
