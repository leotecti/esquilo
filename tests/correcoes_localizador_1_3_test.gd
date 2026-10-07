extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(2)
	var ground_block: StaticBody2D = level.actors.get_node("FriendSupply02")
	check(ground_block.position==Vector2(12020,572) and ground_block.kind==1,"Bloco fora do padrao fica apoiado no solo e e quebravel")
	check(ground_block.is_in_group("tail_targets"),"Bloco quebravel participa da deteccao da caudada")
	check(ground_block.receive_tail(level.tico) and ground_block.used and not ground_block.visible,"Caudada quebra o bloco apoiado no solo")
	var route_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("friend_route_enemy"))
	var expected := [Vector2(5900,520),Vector2(8900,540),Vector2(12600,600),Vector2(16400,620),Vector2(24900,680),Vector2(28200,620),Vector2(31900,600),Vector2(34900,540)]
	var aligned := route_enemies.size()==expected.size()
	for index in mini(route_enemies.size(),expected.size()):
		aligned = aligned and route_enemies[index].origin==expected[index]
	check(aligned,"Todos os inimigos de 1-3 acompanham as plataformas da rota")
	var foods: Array = level.actors.get_children().filter(func(actor): return actor.get("collectible_kind")=="food")
	check(foods.any(func(item): return item.position==Vector2(19320,472)) and foods.any(func(item): return item.position==Vector2(19680,472)),"Alimentos do tunel ficam sobre a plataforma visivel")
	check(not foods.any(func(item): return item.position==Vector2(19725,632)),"Alimento soterrado do perfil-base nao e criado")
	var nuts: Array = level.actors.get_children().filter(func(actor): return actor.get("collectible_kind")=="nut")
	check(not nuts.any(func(item): return item.position in [Vector2(19045,556),Vector2(19175,556),Vector2(19500,636),Vector2(19630,636)]),"Tunel nao conserva nozes duplicadas sob a plataforma")
	check(preload("res://scripts/systems/friend_cave_area.gd").PORTAL_STYLE_VERSION==2,"Portal usa arco mineral, luz, particulas e nevoa refinados")
	var cave_script = preload("res://scripts/systems/friend_cave_area.gd")
	check(cave_script.BACKGROUND_STYLE_VERSION==2 and cave_script.CAVE_BACKGROUND!=null,"Gruta Fria usa pintura de fundo propria")
	check(preload("res://scripts/hazards/cave_drip.gd").VISUAL_STYLE_VERSION==2,"Pingo possui formacao, rastro, queda alongada e respingo")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO CORRECOES 1-3: %d verificacoes, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
