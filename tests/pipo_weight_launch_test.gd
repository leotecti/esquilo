extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	check(level.mechanisms.has("PesoCorrente") and level.weighted_springs.size()==1,"2-1 combina plataforma de peso e mola exclusiva de Pipo")
	check(level.mechanisms.has("RochaAlavanca") and level.mechanisms.CargaRio.position.x>level.mechanisms.RochaAlavanca.lever_position.x,"Rocha e alavanca bloqueiam a cesta posicionada depois da passagem")
	var rock: Node2D = level.mechanisms.RochaAlavanca
	if level.tico!=level.pipo: level._activate(level.pipo,Vector2(3060,760))
	await place(Vector2(3060,760),4)
	for i in 140: rock.push_by(level.pipo,-1.0,1.0/60.0)
	check(rock.falling and level.mechanisms.CargaRio._passage_is_open(),"Queda da rocha aciona a corda e abre a passagem sem depender do último quadro")
	await frames(50)
	check(rock.active and level.mechanisms.CargaRio._passage_is_open(),"Corda tensionada baixa a alavanca e libera a cesta")
	check(level.headwind_zones.size()==1 and level.headwind_zones[0].position.x<=0 and level.headwind_zones[0].end.x>=3800,"Toda a fase 2-1 possui vento contrário visível")
	var tutorial_movers: Array = level.movers.filter(func(mover): return mover.position.x<2300)
	check(tutorial_movers.size()==3,"Travessia da mola não possui plataforma móvel alternativa sobre o rio")
	var spring: Node2D = level.weighted_springs[0]
	check(spring.position==Vector2(2440,720),"Mola está na margem indicada em T01")
	await place(Vector2(2250,720),12)
	var tico_start: float = level.squirrel.position.x
	key(KEY_D,true)
	await frames(45)
	key(KEY_D,false)
	check(level.squirrel.position.x<=tico_start+20,"Vento impede Tico de avançar até a mola")
	if level.tico!=level.pipo: level.switch_character()
	await place(Vector2(2250,720),12)
	var pipo_start: float = level.pipo.position.x
	key(KEY_D,true)
	await frames(45)
	key(KEY_D,false)
	check(level.pipo.position.x>pipo_start+45,"Peso de Pipo permite atravessar o corredor de vento")

	level.squirrel.velocity = Vector2.ZERO
	spring.launch(level.squirrel)
	check(spring.last_strength==330.0 and level.squirrel.velocity.y==-330.0,"Peso baixo de Tico produz somente um salto curto")
	check((330.0*330.0)/(2.0*980.0)<250.0,"Impulso de Tico não alcança a plataforma alta")
	await frames(35)

	if level.tico!=level.pipo: level.switch_character()
	await frames(8)
	spring.cooldown = 0.0
	level.pipo.velocity = Vector2.ZERO
	spring.launch(level.pipo)
	check(level.tico==level.pipo and spring.last_strength==1020.0,"Mola lança Pipo sem trocar o personagem ativo")
	check(level.pipo.velocity.x>0 and level.pipo.velocity.y<=-1020,"Pipo segue em arco para a plataforma sobre o rio")
	check(level.squirrel.environmental_force_multiplier(&"wind")==1.0,"Tico recebe toda a força do vento")
	check(level.pipo.environmental_force_multiplier(&"wind")<0.5,"Peso de Pipo oferece resistência suficiente ao vento")
	var high_route: Array = level.terrain.filter(func(rect: Rect2): return rect.position.y==405 and rect.position.x==2580)
	check(high_route.size()==1 and level.water.any(func(rect: Rect2): return rect.position.x==2540),"Plataforma alta é a única rota sobre o rio fatal")

	# Exercita o arco real, incluindo gravidade, controle no ar e colisão da plataforma.
	await place(spring.position+Vector2(0,-65),2)
	spring.cooldown = 0.0
	level.pipo.velocity = Vector2(0,90)
	key(KEY_D,true)
	await frames(105)
	key(KEY_D,false)
	check(level.pipo.position.x>=2580 and level.pipo.position.x<=2910 and level.pipo.position.y<430,"Pipo pousa com margem segura na plataforma alta durante a travessia jogável")

	await place(level.mechanisms.PesoCorrente.position,35)
	check(level.mechanisms.PesoCorrente.active,"Pipo mantém a plataforma de peso do restante da fase")
	await close_level()
	print("RESULTADO MOLA E PESO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
