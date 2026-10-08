extends RefCounted
## Expansão da fase 2-1. Preserva o tutorial inicial e transforma a travessia
## em uma jornada completa, com a cachoeira opcional no centro do percurso.

const WIDTH := 38000
const CHECKPOINT := Vector2(25800,760)
const FINISH := Vector2(37740,760)
const SECTION_LENGTH := 3200
const SECTION_START := 3800

static func build(level: Node2D) -> void:
	level.main_right = WIDTH
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level.checkpoint.position = CHECKPOINT
	level.exit_marker.position = FINISH
	level.headwind_zones.clear()
	level.headwind_zones.append(Rect2(-120,-260,WIDTH+240,1220))

	# Dez trechos alternam margens largas, pequenos vãos e correnteza. Os
	# desníveis ficam em passos de até 40 px para Pipo poder ir e voltar.
	for section in 10:
		var origin := float(SECTION_START+section*SECTION_LENGTH)
		var top_a := float([760,720,760,720,760][section%5])
		var top_b := float([720,760,720,760,720][section%5])
		var top_c := float([760,720,760,720,760][section%5])
		var platforms := [
			Rect2(origin,top_a,950,960-top_a),
			Rect2(origin+1250,top_b,800,960-top_b),
			Rect2(origin+2350,top_c,850,960-top_c)
		]
		for rect: Rect2 in platforms:
			level._platform(rect)
		# A entrada da cachoeira (x 18.400) e o retorno (x 24.600) ficam em
		# margens inteiras, legíveis e sem vãos junto ao portal.
		for gap in [Rect2(origin+950,810,300,190),Rect2(origin+2050,810,300,190)]:
			level.water.append(gap)
		level._mover(Vector2(origin+1005,minf(top_a,top_b)-34),Vector2(150,0),150,4.8+section%3*.35)
		level._mover(Vector2(origin+2105,minf(top_b,top_c)-34),Vector2(150,0),150,5.1+section%2*.4)

		# Grupos curtos de nozes guiam os saltos sem formar uma linha contínua.
		for point in [
			Vector2(origin+180,top_a-45),Vector2(origin+360,top_a-45),Vector2(origin+700,top_a-45),
			Vector2(origin+1340,top_b-45),Vector2(origin+1530,top_b-45),Vector2(origin+1870,top_b-45),
			Vector2(origin+2460,top_c-45),Vector2(origin+2670,top_c-45),Vector2(origin+2960,top_c-45)
		]: level._nut(point)
		# Alimentos variados representam as provisões destinadas ao vilarejo.
		level._food(Vector2(origin+560,top_a-48),section%3)
		level._food(Vector2(origin+1710,top_b-48),(section+1)%3)
		level._food(Vector2(origin+2820,top_c-48),(section+2)%3)
		# Blocos sempre ficam a uma altura alcançável pelos dois personagens.
		level._block(Vector2(origin+780,top_a-138),2,"RiverReward%02dA" % section)
		if section in [2,5,8]:
			level._block(Vector2(origin+1770,top_b-138),2,"RiverReward%02dB" % section)
		if section in [1,4,7]: level._nut(Vector2(origin+2740,top_c-45),true)

		# Encontros ficam no piso das margens e deixam espaço antes e depois.
		var enemy: Node2D
		match section%3:
			0: enemy = level._slug(Vector2(origin+610,top_a),72)
			1: enemy = level._beetle(Vector2(origin+1640,top_b),82)
			_: enemy = level._armored_enemy(Vector2(origin+2740,top_c),78)
		enemy.set_meta("river_expansion_enemy",true)
		if section in [3,6,9]:
			var spider: Node2D = level._spider(Vector2(origin+1840,top_b-255),185)
			spider.set_meta("river_expansion_enemy",true)

		# Correntezas rasas reforçam a resistência de Pipo sem criar queda.
		if section in [1,3,6,8]:
			level.current_zones.append(Rect2(origin+1250,top_b-110,800,110))

	# A cachoeira fica no centro da fase. A sinalização prepara a entrada e
	# a trilha retoma depois do retorno, antes da bandeira única.
	level._sign(Vector2(17720,500),"Uma caverna se abre entre as pedras…")
	level._sign(Vector2(23850,520),"As provisões seguem pelo rio")
	level._sign(Vector2(33000,500),"Resista à última correnteza")
	level._golden_nut(Vector2(30950,595),"rio_pedras_21")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:rio_pedras_21")

	# Chegada curta e segura depois dos desafios.
	level._platform(Rect2(35800,760,2200,200))
	for x in range(36000,37401,280): level._nut(Vector2(x,715))
