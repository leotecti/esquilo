extends RefCounted
## Jornada 1-2: blocos, ruínas e segredos. Mantém o trecho histórico como introdução.
const WIDTH := 39000
const FINISH := Vector2(38780,550)
const PASSAGE_X := 19400
const PROFILES := [[760,720,640,600,520,610,700],[760,680,600,520,610,680,760],[760,680,680,600,520,600,680],[760,680,600,680,600,680,760]]
const ROUTE_ENEMIES := [[5480,640,120],[8840,600,120],[12620,600,130],[16450,600,120],
	[24600,760,85],[28450,680,120],[32720,600,120],[35620,600,120]]
const HEDGEHOG_ENCOUNTERS := [[12220,680],[16930,680],[26380,520],[34100,700]]

static func build(level) -> void:
	level.main_right = WIDTH
	# A faixa entre x=23.870 e x=24.870 é plana. A bandeira fica nela para não
	# nascer dentro do pilar anterior (que termina em x=22.930).
	level.checkpoint.position = Vector2(24200,760)
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level._platform(Rect2(3730,760,WIDTH-3730,200))
	# Salas largas, pilares e tetos de blocos dão identidade própria à fase.
	# Nenhuma subida direta supera 80 px. O perfil anterior continha paredes de
	# 110, 120 e 160 px; as maiores podiam bloquear Tico e todas eram arriscadas
	# para Pipo durante uma revisita.
	var profiles := PROFILES
	for section in 10:
		var origin := 4300+section*3350
		var heights: Array = profiles[section%profiles.size()]
		for step in heights.size():
			var x := origin+step*470
			var y: int = heights[step]
			if y<760:
				# Superfícies a 80 px do chão formam caminhos de dois níveis. Baixo/S
				# atravessa a ponte; um salto curto permite retornar à rota superior.
				if y==680 and step in [1,2,4,5]:
					level._drop_platform(Rect2(x,y,470,760-y))
					if step in [2,4]:
						level._food(Vector2(x+235,710),(section+step+1)%3)
						for lower_x in [x+115,x+355]: level._nut(Vector2(lower_x,715))
				else: level._platform(Rect2(x,y,470,760-y))
			# As passagens dos portais possuem plataformas especiais e recompensas
			# próprias. Não cria duplicatas do perfil-base dentro do terreno.
			var covered_by_portal := (section==4 and step in [3,4]) or (section==9 and step==6)
			if (step not in [1,5] or section%2==0) and not covered_by_portal:
				for offset in [135,245]: level._nut(Vector2(x+offset,y-44))
		# Cada conjunto acompanha o terceiro degrau, onde os blocos aparecem.
		# Assim, a face inferior continua ao alcance mesmo quando o próximo sobe.
		var ceiling_y: int = heights[2]-120
		# Em T08 a aproximação ocorre pelo degrau de y=680; uma margem adicional
		# evita que a borda da colisão impeça a cabeçada no bloco.
		if section in [6,9]: ceiling_y += 20
		for column in 4:
			var kind := 2 if column==1 or (column==3 and section%3==0) else (column+section)%2
			level._block(Vector2(origin+1040+column*92,ceiling_y),kind,"RouteBlock%02d_%d" % [section,column])
		for entry in [[0,330],[3,330],[6,310]]:
			var step: int = entry[0]
			var food_y: int = heights[step]-48
			# A escadaria da passagem cobre o piso original no centro de T07.
			# A fruta acompanha sua superfície visível em vez de ficar soterrada.
			if section==4 and step==3: food_y=472
			# A plataforma de chegada começa em y=690 e cobre o piso-base de T12.
			if section==9 and step==6: food_y=642
			level._food(Vector2(origin+step*470+entry[1],food_y),(section+step)%3)
		for reward in [[1660,80],[1790,125],[1920,80]]: level._nut(Vector2(origin+reward[0],mini(heights[3],heights[4])-reward[1]))
	# Encontros espaçados deixam uma área segura antes e depois de cada inimigo.
	for entry in ROUTE_ENEMIES:
		var enemy = level._beetle(Vector2(entry[0],entry[1]),entry[2])
		enemy.set_meta("e20_route_enemy",true)
	for encounter in HEDGEHOG_ENCOUNTERS:
		var hedgehog = preload("res://scripts/enemies/hedgehog.gd").new()
		hedgehog.name = "HedgehogE20_%d" % encounter[0]
		hedgehog.level = level
		hedgehog.position = Vector2(encounter[0],encounter[1])
		hedgehog.set_meta("e20_route_hedgehog",true)
		level.actors.add_child(hedgehog)
	# Segredos fora da linha direta recompensam observação e exploração vertical.
	level._block(Vector2(15120,560),1,"HiddenGalleryBlock")
	level._golden_nut(Vector2(15305,515),"galeria_oculta_12")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:galeria_oculta_12")
	level._golden_nut(Vector2(31850,672),"torre_blocos_12")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:torre_blocos_12")
	for point in [Vector2(7400,600),Vector2(17400,600),Vector2(27600,600),Vector2(35100,600)]: level._nut(point,true)
	# A galeria fica no meio. A única bandeira aparece depois de sua saída.
	for rect in [Rect2(18820,680,180,80),Rect2(19000,600,180,160),Rect2(19180,520,440,240),Rect2(19620,600,180,160),Rect2(19800,680,180,80)]: level._platform(rect)
	for point in [Vector2(18880,636),Vector2(19060,556),Vector2(19270,476),Vector2(19420,476),Vector2(19670,556),Vector2(19850,636)]: level._nut(point)
	level._sign(Vector2(18880,390),"A névoa entre as pedras esconde uma passagem")
	level._sign(Vector2(5000,515),"↓ ou S • desça pela ponte\nExplore a trilha inferior")
	level._sign(Vector2(23100,535),"Bandeira única • caminho protegido")
	# Chegada tranquila depois do último desafio.
	for rect in [Rect2(37400,690,380,70),Rect2(37780,620,420,140),Rect2(38200,550,780,210)]: level._platform(rect)
	for point in [Vector2(37520,646),Vector2(37680,646),Vector2(37900,576),Vector2(38060,576),Vector2(38360,506),Vector2(38520,506)]: level._nut(point)
	level.exit_marker.position = FINISH
	level._sign(Vector2(38220,380),"As provisões seguem para o vilarejo")
