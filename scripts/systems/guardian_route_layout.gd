extends RefCounted
## Jornada 1-4: travessia da cachoeira e aproximação gradual ao Periquito.
const WIDTH := 38000
const FINISH := Vector2(37780,760)
const WATERFALL_X := 18150
const RETURN_X := 24600
const SECTION_WIDTH := 3000
const PROFILES := [
	[760,680,600,680,760,680], [760,680,680,600,680,760],
	[760,680,600,600,680,760], [760,680,760,680,600,680]
]

static func build(level) -> void:
	level.main_right = WIDTH
	level.get_node("Geometry/RightWall").position.x += WIDTH-3800
	level._platform(Rect2(3730,760,WIDTH-3730,220))
	for section in 11:
		var origin := 4050+section*SECTION_WIDTH
		var heights: Array = PROFILES[section%PROFILES.size()]
		for step in heights.size():
			var x: float = origin+step*500
			var y: float = heights[step]
			if y<760:
				if y==680 and step in [1,4] and section%2==1: level._drop_platform(Rect2(x,y,500,80))
				else: level._platform(Rect2(x,y,500,760-y))
			for offset in [135,285]: level._nut(Vector2(x+offset,y-44))
			if step in [0,3] and not (section==4 and step==3): level._food(Vector2(x+390,y-48),(section+step)%3)
		var block_y: float = heights[2]-116
		for column in 3:
			var kind := 2 if column==1 else (section+column)%2
			level._block(Vector2(origin+1060+column*94,block_y),kind,"GuardianRouteBlock%02d_%d" % [section,column])
		if section in [1,4,7,9]: level._nut(Vector2(origin+2350,heights[4]-44),true)
	_add_slug(level,Vector2(5350,600),90)
	_add_beetle(level,Vector2(7800,680),115)
	_add_spider(level,Vector2(10100,370),230)
	_add_hedgehog(level,Vector2(13250,760))
	_add_crow(level,Vector2(15350,505))
	_add_slug(level,Vector2(17150,600),105)
	_add_beetle(level,Vector2(21150,600),120)
	_add_crow(level,Vector2(25050,470))
	_add_hedgehog(level,Vector2(27650,680))
	_add_spider(level,Vector2(29600,390),220)
	_add_beetle(level,Vector2(31450,760),110)
	for rect in [Rect2(17650,680,250,80),Rect2(17900,600,250,160),Rect2(18150,520,500,240),Rect2(18650,600,250,160),Rect2(18900,680,250,80)]: level._platform(rect)
	for point in [Vector2(17720,636),Vector2(17970,556),Vector2(18270,476),Vector2(18430,476),Vector2(18720,556),Vector2(18970,636)]: level._nut(point)
	level.checkpoint.position = Vector2(25100,760)
	level._sign(Vector2(17620,390),"A água esconde uma passagem • AÇÃO")
	level._sign(Vector2(24900,525),"Bandeira única • caminho protegido")
	level._platform(Rect2(34600,700,3400,280))
	for point in [Vector2(34680,656),Vector2(34900,656),Vector2(35120,656)]: level._nut(point)
	level.guardian = preload("res://scripts/enemies/forest_guardian.gd").new()
	level.guardian.name = "Guardian"
	level.guardian.level = level
	level.guardian.position = Vector2(36200,700)
	level.actors.add_child(level.guardian)
	level.guardian.calmed.connect(level._on_guardian_calmed)
	level.exit_marker.position = FINISH
	level._sign(Vector2(34650,510),"Asas abertas: prepare o salto\nCansado e de cabeça baixa: pule sobre ele")

static func _tag(enemy: Node2D) -> void: enemy.set_meta("guardian_route_enemy",true)
static func _add_slug(level, point: Vector2, distance: float) -> void: _tag(level._slug(point,distance))
static func _add_beetle(level, point: Vector2, distance: float) -> void: _tag(level._beetle(point,distance))
static func _add_spider(level, point: Vector2, travel: float) -> void: _tag(level._spider(point,travel))
static func _add_hedgehog(level, point: Vector2) -> void:
	var enemy = preload("res://scripts/enemies/hedgehog.gd").new()
	enemy.level = level
	enemy.position = point
	_tag(enemy)
	level.actors.add_child(enemy)
static func _add_crow(level, point: Vector2) -> void:
	var enemy = preload("res://scripts/enemies/crow.gd").new()
	enemy.level = level
	enemy.position = point
	_tag(enemy)
	level.actors.add_child(enemy)
	enemy.stomped.connect(level._on_stomp)
