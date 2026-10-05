extends RefCounted
## Fase modelo: trechos curtos de subida, travessia e recuperação.
const WIDTH := 42000
const FINISH := Vector2(41780,550)
const COPA_X := 21000
const DIFFICULTY_CURVE := [
	{"id":"learn","label":"Aprender","start":0.0,"end":5200.0,"slug_speed":45.0},
	{"id":"practice","label":"Praticar","start":5200.0,"end":14800.0,"slug_speed":45.0},
	{"id":"combine","label":"Combinar","start":14800.0,"end":27600.0,"slug_speed":50.0},
	{"id":"challenge","label":"Desafiar","start":27600.0,"end":40500.0,"slug_speed":55.0},
	{"id":"recover","label":"Chegada","start":40500.0,"end":42000.0,"slug_speed":0.0}
]

static func difficulty_phase(x: float) -> Dictionary:
	for segment: Dictionary in DIFFICULTY_CURVE:
		if x>=float(segment.start) and x<float(segment.end): return segment
	return DIFFICULTY_CURVE[-1]

static func _configure_slug(slug: Node2D) -> void:
	var segment := difficulty_phase(slug.position.x)
	slug.speed = float(segment.slug_speed)
	slug.set_meta("difficulty_phase",segment.id)
	slug.set_meta("difficulty_label",segment.label)

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
	# As duas lesmas da introdução ensinam o contato e o salto com a velocidade
	# base. Os encontros seguintes avançam pela curva formal da E16.
	for actor in level.actors.get_children():
		if actor.get_script()==preload("res://scripts/enemies/slug.gd"):
			_configure_slug(actor)
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
			if step==4 and section%2==0:
				var slug: Node2D = level._slug(Vector2(x+270,y),65)
				_configure_slug(slug)
		# Um arco recompensa o salto sem transformar o caminho em uma linha contínua.
		var arc_y: int = heights[3]
		for reward in [[1265,75],[1400,115],[1535,75]]:
			level._nut(Vector2(origin+reward[0],arc_y-reward[1]))
		# Alimentos variados representam provisões recuperadas para o vilarejo.
		for entry in [[0,315],[4,315],[7,315]]:
			var step: int = entry[0]
			level._food(Vector2(origin+step*400+entry[1],heights[step]-48),(section+step)%3)
		# Todo trecho possui ao menos um bloco de recompensa; alguns formam pares.
		level._block(Vector2(origin+2600,heights[6]-150),2,"SupplyBlock%02dA" % section)
		if section in [2,5,8]:
			level._block(Vector2(origin+540,heights[1]-150),2,"SupplyBlock%02dB" % section)
		if section in [1,4,7,10]:
			level._nut(Vector2(origin+260,715),true)
	# Coletável opcional fora da linha de corrida, sobre uma elevação intermediária.
	level._golden_nut(Vector2(32600,560),"trilha_alta_01")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:trilha_alta_01")
	# Área de chegada mais tranquila depois do último conjunto de subidas.
	for rect in [Rect2(20700,680,140,80),Rect2(20840,610,140,150)]: level._platform(rect)
	for point in [Vector2(20760,636),Vector2(20890,566)]: level._nut(point)
	for rect in [Rect2(40500,690,400,70),Rect2(40900,620,400,140),Rect2(41300,550,650,210)]: level._platform(rect)
	for point in [Vector2(40620,646),Vector2(40780,646),Vector2(41020,576),Vector2(41180,576),Vector2(41420,506),Vector2(41580,506)]: level._nut(point)
	level.exit_marker.position = FINISH
	# Apoios para regressar pelos desníveis antigos e subir à árvore pela direita.
	for rect in [Rect2(1240,690,140,70),Rect2(3730,620,140,140),
		Rect2(5170,640,160,120),Rect2(5330,710,160,50),
		Rect2(20940,680,440,80),
		Rect2(21100,610,140,150)]: level._platform(rect)
	# Ao elevar um apoio, mantém o ID histórico da recompensa e deixa-a acima do chão.
	for actor in level.actors.get_children():
		if not actor.has_method("reset_item"): continue
		if not actor.has_meta("save_id"): actor.set_meta("save_id","%d:%d" % [actor.position.x,actor.position.y])
		for rect in level.terrain:
			if actor.position.x>=rect.position.x and actor.position.x<rect.end.x and actor.position.y>rect.position.y-44:
				actor.position.y = rect.position.y-44
