extends RefCounted
## Expansão de 2-3: pontes encharcadas, margens frias e travessias sob tempestade.

const WIDTH := 38000
const START := 3800
const LENGTH := 3200
const CHECKPOINT := Vector2(26000,760)
const FINISH := Vector2(37740,760)

static func build(level: Node2D) -> void:
	level.main_right = WIDTH
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level.checkpoint.position = CHECKPOINT
	level.exit_marker.position = FINISH
	for section in 10:
		var origin := float(START+section*LENGTH)
		var heights := [760.0,720.0,680.0,720.0,760.0]
		var a: float = heights[section%5]
		var b: float = heights[(section+2)%5]
		var c: float = heights[(section+4)%5]
		# Plataformas largas deixam espaço para perceber a inércia do piso molhado.
		for rect in [Rect2(origin,a,980,960-a),Rect2(origin+1260,b,880,960-b),Rect2(origin+2440,c,760,960-c)]:
			level._platform(rect)
		level.water.append(Rect2(origin+980,810,280,190))
		level.water.append(Rect2(origin+2140,810,300,190))
		level._mover(Vector2(origin+1015,minf(a,b)-30),Vector2(170,0),190,5.2+(section%3)*.25)
		level._mover(Vector2(origin+2200,minf(b,c)-30),Vector2(145,0),180,4.9+(section%2)*.35)
		for point in [
			Vector2(origin+150,a-44),Vector2(origin+360,a-44),Vector2(origin+650,a-44),Vector2(origin+875,a-44),
			Vector2(origin+1370,b-44),Vector2(origin+1620,b-44),Vector2(origin+1970,b-44),
			Vector2(origin+2520,c-44),Vector2(origin+2780,c-44),Vector2(origin+3030,c-44)
		]: level._nut(point)
		level._food(Vector2(origin+520,a-48),section%3)
		level._food(Vector2(origin+1810,b-48),(section+1)%3)
		level._food(Vector2(origin+2880,c-48),(section+2)%3)
		level._block(Vector2(origin+760,a-138),2,"RainReward%02dA" % section)
		if section in [2,5,8]: level._block(Vector2(origin+1730,b-138),2,"RainReward%02dB" % section)
		if section in [1,4,7]: level._nut(Vector2(origin+2700,c-44),true)
		var enemy: Node2D
		match section%4:
			0: enemy = level._armored_enemy(Vector2(origin+690,a),80)
			1: enemy = level._beetle(Vector2(origin+1740,b),85)
			2: enemy = level._slug(Vector2(origin+2830,c),78)
			_: enemy = level._spider(Vector2(origin+1720,b-245),175)
		enemy.set_meta("rainy_bridge_enemy",true)
		# Um segundo encontro por setor impede longos trechos vazios. Alternar
		# patrulhas terrestres cria pressão para saltar e controlar o deslizamento.
		var second_enemy: Node2D
		if section%2==0:
			second_enemy = level._beetle(Vector2(origin+1840,b),105)
		else:
			second_enemy = level._armored_enemy(Vector2(origin+720,a),92)
		second_enemy.set_meta("rainy_bridge_enemy",true)
		if section in [3,6,9]:
			level._sky_enemy(Vector2(origin+2650,c-250))
			var flyer: Node2D = level.actors.get_child(level.actors.get_child_count()-1)
			flyer.set_meta("rainy_bridge_enemy",true)
		if section in [1,4,7]:
			level._sky_enemy(Vector2(origin+2820,c-230))
			var ambusher: Node2D = level.actors.get_child(level.actors.get_child_count()-1)
			ambusher.set_meta("rainy_bridge_enemy",true)
	level._sign(Vector2(17680,500),"A galeria de drenagem está aberta • AÇÃO")
	level._sign(Vector2(24700,500),"A galeria retorna perto da bandeira")
	level._sign(Vector2(32900,500),"Última ponte • controle o impulso no piso molhado")
	level._golden_nut(Vector2(30900,595),"ponte_chuvosa_23")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:ponte_chuvosa_23")
	level._platform(Rect2(35800,760,2200,200))
	for x in range(36000,37401,260): level._nut(Vector2(x,715))
