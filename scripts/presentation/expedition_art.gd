extends Node2D
const GROUND = preload("res://assets/slice/ground.svg")
var level: Node2D
var clock := 0.0
var _redraw_elapsed := 0.0
const RIVER_REDRAW_INTERVAL := 1.0/20.0
const RAIN_REDRAW_INTERVAL := 1.0/18.0
const DEFAULT_REDRAW_INTERVAL := 1.0/30.0
const PERFORMANCE_STYLE_VERSION := 3
const RAINY_BRIDGE_STYLE_VERSION := 1
const RAIN_DROP_COUNT := 30

func _ready() -> void: z_index = -1

func _process(delta: float) -> void:
	clock += delta
	_redraw_elapsed += delta
	var interval := (RAIN_REDRAW_INTERVAL if level.section==2 else RIVER_REDRAW_INTERVAL) if level.biome==2 else DEFAULT_REDRAW_INTERVAL
	if _redraw_elapsed<interval: return
	_redraw_elapsed = fmod(_redraw_elapsed,interval)
	queue_redraw()

func _draw() -> void:
	var rainy_bridge: bool = level.biome==2 and level.section==2
	var tint: Color = Color("8caab4") if rainy_bridge else [Color.WHITE,Color("c0c7d0"),Color("e7c087")][level.biome-2]
	var focus_x: float = level.tico.position.x if is_instance_valid(level.tico) else 640.0
	var visible_band := Rect2(focus_x-900,-400,1800,1500)
	if rainy_bridge:
		# Névoa fria em uma única faixa, barata para Web/mobile.
		draw_rect(visible_band,Color(0.18,0.29,0.36,.18))
	for rect in level.terrain:
		if not rect.intersects(visible_band): continue
		draw_rect(rect,Color("4c5964") if level.biome==3 else Color("6b5138"))
		var x: float = rect.position.x
		while x<rect.end.x:
			var width: float = minf(256,rect.end.x-x)
			draw_texture_rect_region(GROUND,Rect2(x,rect.position.y,width,minf(rect.size.y,160)),Rect2(0,0,width,minf(rect.size.y,160)),tint)
			x += width
		if rainy_bridge:
			# Brilho descontínuo comunica piso molhado sem outra textura ou nós.
			draw_rect(Rect2(rect.position+Vector2(0,1),Vector2(rect.size.x,7)),Color(0.61,0.82,0.88,.38))
			for puddle_x in range(int(rect.position.x)+55,int(rect.end.x)-25,150):
				draw_line(Vector2(puddle_x,rect.position.y+5),Vector2(puddle_x+52,rect.position.y+5),Color(0.78,0.94,0.96,.48),2,true)
	for rect in level.water:
		if not rect.intersects(visible_band): continue
		# A pintura do Rio das Pedras já contém água. A camada leve mantém as
		# ondas animadas sem formar um retângulo opaco nos vãos entre margens.
		draw_rect(rect,Color(0.25,0.56,0.68,.16) if level.biome==2 else Color("408eaeaf"))
		for x in range(int(rect.position.x),int(rect.end.x),45):
			var y: float = rect.position.y+sin(clock*2+x)*4
			draw_line(Vector2(x,y),Vector2(x+30,y),Color("bcf0e5"),3)
	# Faixas rasas indicam correnteza caminhável. As setas deixam clara a direção
	# sem adicionar partículas ou nós extras ao percurso.
	for zone in level.current_zones:
		if not zone.intersects(visible_band): continue
		draw_rect(zone,Color(0.20,0.55,0.65,.12))
		for x in range(int(zone.position.x)+45,int(zone.end.x),120):
			var y: float = zone.end.y-22.0
			draw_line(Vector2(x,y),Vector2(x+34,y),Color("bceee0a0"),3,true)
			draw_colored_polygon(PackedVector2Array([Vector2(x+34,y),Vector2(x+24,y-7),Vector2(x+24,y+7)]),Color("bceee0a0"))
	for zone in level.wind_zones:
		var rect: Rect2 = zone
		if not rect.intersects(visible_band): continue
		for i in 8:
			var y: float = rect.end.y-fmod(clock*55+i*57,rect.size.y)
			var x: float = rect.position.x+25+(i%4)*rect.size.x/4
			draw_line(Vector2(x,y),Vector2(x+35,y-12),Color("e9e9d685"),3)
	# Rajadas horizontais deixam visível a barreira que Tico não vence pelo peso baixo.
	for zone in level.headwind_zones:
		if not zone.intersects(visible_band): continue
		var local_start := maxf(zone.position.x,visible_band.position.x)
		var local_end := minf(zone.end.x,visible_band.end.x)
		var local_width := maxf(1.0,local_end-local_start)
		draw_rect(Rect2(local_start,zone.position.y,local_width,zone.size.y),Color(0.65,0.86,0.89,.025))
		var gust_count := 12
		for i in gust_count:
			var y: float = zone.position.y+105+(i%7)*88+sin(clock*2.2+i)*9
			var speed: float = 125.0+(i%4)*22.0
			var x: float = local_end-fmod(clock*speed+i*193.0,local_width+180.0)
			var length: float = 68.0+(i%3)*24.0
			var points := PackedVector2Array([Vector2(x,y),Vector2(x-length*.52,y-5+sin(clock*3+i)*5),Vector2(x-length,y+2)])
			draw_polyline(points,Color(0.91,0.98,0.91,.42),2.5+(i%2),true)
			draw_line(Vector2(x-length,y+2),Vector2(x-length+15,y-5),Color(0.91,0.98,0.91,.28),2,true)
		# Folhas grandes e reconhecíveis tornam a direção da rajada explícita.
		for i in 10:
			var leaf_x: float = local_end-fmod(clock*(92.0+i*7.0)+i*367.0,local_width+120.0)
			var leaf_y: float = zone.position.y+120+(i%7)*82+sin(clock*4+i)*18
			var leaf_color := Color("e0c75dcc") if i%3==0 else (Color("a9c65dcc") if i%2==0 else Color("799f4dcc"))
			var turn := clock*(3.0+i%4*.45)+i
			var leaf_transform := Transform2D(turn,Vector2(leaf_x,leaf_y))
			var leaf := PackedVector2Array([leaf_transform*Vector2(-13,0),leaf_transform*Vector2(-2,-7),leaf_transform*Vector2(13,0),leaf_transform*Vector2(-2,7)])
			draw_colored_polygon(leaf,leaf_color)
			draw_line(leaf_transform*Vector2(-16,0),leaf_transform*Vector2(13,0),Color("5f713fbb"),2,true)
	for rect in level.cave_roofs:
		if not rect.intersects(visible_band): continue
		draw_rect(rect,Color("4b5368"))
		for x in range(int(rect.position.x)+15,int(rect.end.x),65):
			draw_colored_polygon(PackedVector2Array([Vector2(x,rect.end.y-20),Vector2(x+22,rect.end.y),Vector2(x+40,rect.end.y-20)]),Color("6a6f85"))
	if rainy_bridge:
		_draw_cold_rain(visible_band)

func _draw_cold_rain(visible_band: Rect2) -> void:
	# A chuva acompanha apenas a faixa da câmera: 44 traços reutilizados a 30 FPS,
	# sem partículas processadas fora da tela.
	for i in RAIN_DROP_COUNT:
		var lane := float((i*97)%1780)
		var x := visible_band.position.x+lane
		var y := visible_band.position.y+fmod(clock*(430.0+(i%4)*34.0)+i*83.0,visible_band.size.y+120.0)-60.0
		var length := 24.0+(i%3)*7.0
		draw_line(Vector2(x,y),Vector2(x-8,y+length),Color(0.72,0.89,0.96,.52),2.0,true)
	# Duas faixas de bruma dão profundidade sem imagens adicionais.
	for i in 2:
		var fog_x := visible_band.position.x+fmod(clock*(18.0+i*6.0)+i*710.0,visible_band.size.x+620.0)-310.0
		draw_circle(Vector2(fog_x,420+i*155),260.0,Color(0.72,0.82,0.84,.045))
