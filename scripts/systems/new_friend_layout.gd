extends RefCounted
## Jornada 1-3: o resgate existente abre uma fase longa de cooperação.
const WIDTH := 38000
const FINISH := Vector2(37780,550)
const CAVE_X := 19500

static func build(level) -> void:
	level.main_right = WIDTH
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level._platform(Rect2(3730,760,WIDTH-3730,200))
	# Degraus de até 80 px preservam o retorno e o salto menor de Pipo.
	var profiles := [[760,680,600,520,600,680,760], [760,700,620,540,620,700,760],
		[760,680,600,680,600,680,760], [760,700,620,620,540,620,700]]
	for section in 10:
		var origin := 4300+section*3200
		var heights: Array = profiles[section%profiles.size()]
		for step in heights.size():
			var x := origin+step*455
			var y: int = heights[step]
			if y<760: level._platform(Rect2(x,y,455,760-y))
			for offset in [125,255]: level._nut(Vector2(x+offset,y-44))
			if step in [1,5]:
				level._food(Vector2(x+350,y-48),(section+step)%3)
		# Blocos e arcos alternam observação, salto e recompensas.
		level._block(Vector2(origin+1320,heights[3]-155),2,"FriendSupply%02d" % section)
		for reward in [[1760,80],[1890,120],[2020,80]]:
			level._nut(Vector2(origin+reward[0],mini(heights[3],heights[4])-reward[1]))
	# Encontros deixam áreas seguras antes e depois; a dupla pode derrotá-los.
	for entry in [[5900,70],[8900,85],[12600,75],[16400,90],[24900,80],[28200,90],[31900,80],[34900,85]]:
		var enemy = level._slug(Vector2(entry[0],760),entry[1]) if int(entry[0])%3 else level._beetle(Vector2(entry[0],760),entry[1])
		enemy.set_meta("friend_route_enemy",true)
	# Pontos de cooperação: pedras móveis e blocos resistentes reutilizam habilidades.
	for x in [10400,27400]:
		var rock = preload("res://scenes/objects/pushable.tscn").instantiate()
		rock.name = "FriendStone%d" % x
		rock.position = Vector2(x,760)
		rock.max_travel = 260
		level.actors.add_child(rock)
	for x in [14600,30400]:
		var heavy = preload("res://scenes/objects/heavy_block.tscn").instantiate()
		heavy.name = "FriendHeavy%d" % x
		heavy.position = Vector2(x,680)
		level.actors.add_child(heavy)
	# Túnel principal: entrada visível no meio e uma faixa plana para interação.
	for rect in [Rect2(18820,680,180,80),Rect2(19000,600,180,160),Rect2(19180,520,640,240),Rect2(19820,600,180,160),Rect2(20000,680,180,80)]:
		level._platform(rect)
	for point in [Vector2(18880,636),Vector2(19060,556),Vector2(19220,476),Vector2(19400,476),Vector2(19600,476),Vector2(19870,556),Vector2(20050,636)]: level._nut(point)
	level._sign(Vector2(18850,360),"Um vento frio sopra do túnel…")
	# A única bandeira fica depois da saída secundária, confirmando progresso.
	level.checkpoint.position = Vector2(24300,680)
	level._sign(Vector2(23350,535),"A caverna termina perto da bandeira")
	for point in [Vector2(7600,600),Vector2(17400,600),Vector2(26700,600),Vector2(34500,600)]: level._nut(point,true)
	level._golden_nut(Vector2(33300,510),"amizade_trilha_alta_13")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:amizade_trilha_alta_13")
	# Chegada curta e tranquila depois do último desafio.
	for rect in [Rect2(36500,690,380,70),Rect2(36880,620,400,140),Rect2(37280,550,700,210)]: level._platform(rect)
	for point in [Vector2(36620,646),Vector2(36780,646),Vector2(37000,576),Vector2(37160,576),Vector2(37420,506),Vector2(37580,506)]: level._nut(point)
	level.exit_marker.position = FINISH
	level._sign(Vector2(37000,380),"Juntos, o caminho ficou mais fácil")
