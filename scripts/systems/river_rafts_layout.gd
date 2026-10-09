extends RefCounted
## Expansão da fase 2-2: margens, correntezas e balsas em uma jornada completa.

const WIDTH := 38000
const CHECKPOINT := Vector2(25800,760)
const FINISH := Vector2(37740,760)
const SECTION_START := 3800
const SECTION_LENGTH := 3200

static func build(level: Node2D) -> void:
	level.main_right = WIDTH
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level.checkpoint.position = CHECKPOINT
	level.exit_marker.position = FINISH
	for section in 10:
		var origin := float(SECTION_START+section*SECTION_LENGTH)
		var a := float([760,720,680,720,760][section%5])
		var b := float([720,680,720,760,720][section%5])
		var c := float([760,720,760,680,720][section%5])
		for rect in [Rect2(origin,a,900,960-a),Rect2(origin+1220,b,920,960-b),Rect2(origin+2440,c,760,960-c)]:
			level._platform(rect)
		for gap in [Rect2(origin+900,810,320,190),Rect2(origin+2140,810,300,190)]:
			level.water.append(gap)
		# Balsas curtas mantêm o ritmo sem substituir os saltos entre margens.
		level._mover(Vector2(origin+970,minf(a,b)-28),Vector2(170,0),190,5.0+(section%3)*.35)
		level._mover(Vector2(origin+2190,minf(b,c)-28),Vector2(145,0),180,4.8+(section%2)*.45)
		for point in [
			Vector2(origin+160,a-44),Vector2(origin+340,a-44),Vector2(origin+650,a-44),
			Vector2(origin+1340,b-44),Vector2(origin+1570,b-44),Vector2(origin+1940,b-44),
			Vector2(origin+2530,c-44),Vector2(origin+2760,c-44),Vector2(origin+3010,c-44)
		]: level._nut(point)
		level._food(Vector2(origin+520,a-48),section%3)
		level._food(Vector2(origin+1770,b-48),(section+1)%3)
		level._food(Vector2(origin+2890,c-48),(section+2)%3)
		level._block(Vector2(origin+735,a-138),2,"RaftReward%02dA" % section)
		if section in [2,5,8]: level._block(Vector2(origin+1810,b-138),2,"RaftReward%02dB" % section)
		if section in [1,4,7]: level._nut(Vector2(origin+2670,c-44),true)
		var enemy: Node2D
		match section%4:
			0: enemy = level._slug(Vector2(origin+610,a),75)
			1: enemy = level._beetle(Vector2(origin+1680,b),88)
			2: enemy = level._armored_enemy(Vector2(origin+2810,c),82)
			_: enemy = level._spider(Vector2(origin+1710,b-245),175)
		enemy.set_meta("river_rafts_enemy",true)
		if section in [2,5,8]:
			level.current_zones.append(Rect2(origin+1220,b-105,920,105))
	level._sign(Vector2(17650,500),"As raízes escondem uma passagem • AÇÃO")
	level._sign(Vector2(24400,520),"A trilha reaparece perto da bandeira")
	level._sign(Vector2(32900,500),"Últimas balsas • observe a correnteza")
	level._golden_nut(Vector2(30920,595),"balsas_22")
	level.actors.get_child(level.actors.get_child_count()-1).set_meta("save_id","golden:balsas_22")
	level._platform(Rect2(35800,760,2200,200))
	for x in range(36000,37401,280): level._nut(Vector2(x,715))
