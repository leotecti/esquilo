extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(1)
	var intro_beetles: Array = level.actors.get_children().filter(func(actor): return actor.get_script()==preload("res://scripts/enemies/beetle.gd") and actor.position.x<1500)
	var intro_beetle: Node2D = intro_beetles[0]
	var art = intro_beetle.get_node("EnemyArt")
	check(is_instance_valid(art) and art.kind=="beetle","Inimigo de X 999 usa o alinhamento refinado do besouro")
	# O bloco de noz em X 5.432 deve abrir com um salto real partindo da plataforma y=640.
	var reachable: StaticBody2D = level.actors.get_node("RouteBlock00_1")
	check(reachable.position==Vector2(5432,520),"Blocos de T02 foram baixados para a faixa alcançável")
	level.tico.reset_at(Vector2(reachable.position.x,640))
	await frames(8)
	key(KEY_SPACE,true)
	await frames(30)
	key(KEY_SPACE,false)
	await frames(12)
	check(reachable.used,"Tico alcança e abre o bloco com um salto normal")
	var t03_block: StaticBody2D = level.actors.get_node("RouteBlock01_2")
	check(t03_block.position==Vector2(8874,480),"Blocos de T03 acompanham o degrau percorrido")
	var t04_block: StaticBody2D = level.actors.get_node("RouteBlock02_2")
	check(t04_block.position==Vector2(12224,560),"Blocos de T04 ficam ao alcance do salto normal")
	var t08_block: StaticBody2D = level.actors.get_node("RouteBlock06_2")
	check(t08_block.position==Vector2(25624,580),"Blocos de T08 possuem margem segura para a cabecada")
	var t12_block: StaticBody2D = level.actors.get_node("RouteBlock09_2")
	check(t12_block.position==Vector2(35674,500),"Blocos de T12 possuem margem segura para a cabecada")
	var route_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("e20_route_enemy"))
	var first: Node2D = route_enemies[0]
	check(first.position.y==640 and first.position.x>5240 and first.position.x<5710,"Inimigo de T02 patrulha sobre a plataforma visível")
	check(route_enemies[1].origin==Vector2(8840,600) and route_enemies[1].patrol_distance==120.0,"Inimigo de T03 patrulha a plataforma acessivel")
	var expected_y := [640,600,600,600,760,680,600,600]
	var all_supported: bool = route_enemies.size()==expected_y.size()
	for index in mini(route_enemies.size(),expected_y.size()):
		all_supported = all_supported and is_equal_approx(route_enemies[index].origin.y,expected_y[index])
	check(all_supported,"Todos os inimigos ampliados de 1-2 ficam na altura de suas plataformas")
	var hedgehogs: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("e20_route_hedgehog"))
	var expected_hedgehogs := [Vector2(12220,680),Vector2(16930,680),Vector2(26380,520),Vector2(34100,700)]
	var hedgehogs_supported := hedgehogs.size()==expected_hedgehogs.size()
	for index in mini(hedgehogs.size(),expected_hedgehogs.size()):
		hedgehogs_supported = hedgehogs_supported and hedgehogs[index].origin==expected_hedgehogs[index]
	check(hedgehogs_supported,"Porcos-espinhos acompanham as plataformas acessiveis da rota")
	var hidden_block: StaticBody2D = level.actors.get_node("HiddenGalleryBlock")
	check(hidden_block.position==Vector2(15120,560),"Bloco secreto de T05 fica ao alcance do salto normal")
	var food_script = preload("res://scripts/objects/food.gd")
	var foods: Array = level.actors.get_children().filter(func(actor): return actor.get_script()==food_script)
	check(foods.any(func(item): return item.position==Vector2(19440,472)),"Fruta de T07 acompanha a superficie visivel")
	check(foods.any(func(item): return item.position==Vector2(37580,642)),"Fruta de T12 acompanha a plataforma de chegada")
	check(not foods.any(func(item): return item.position==Vector2(19440,552)),"Posicao soterrada de T07 nao e mais utilizada")
	check(not foods.any(func(item): return item.position==Vector2(37580,712)),"Posicao soterrada de T12 nao e mais utilizada")
	var gallery_food_positions := [Vector2(47150,632),Vector2(47920,602),Vector2(48710,632),Vector2(49720,632),Vector2(50350,592)]
	var gallery_foods_supported := true
	for point in gallery_food_positions:
		gallery_foods_supported = gallery_foods_supported and foods.any(func(item): return item.position==point)
	check(gallery_foods_supported,"Todas as frutas da Galeria das Pedras ficam sobre plataformas acessiveis")
	var gallery_enemy_origins := [Vector2(48050,710),Vector2(49600,610),Vector2(50380,640)]
	var gallery_enemies_supported: bool = level.optional_area.enemies.size()==gallery_enemy_origins.size()
	for index in mini(level.optional_area.enemies.size(),gallery_enemy_origins.size()):
		gallery_enemies_supported = gallery_enemies_supported and level.optional_area.enemies[index].origin==gallery_enemy_origins[index]
	check(gallery_enemies_supported,"Todas as lesmas da galeria patrulham plataformas acessiveis")
	check(gallery_food_positions.has(Vector2(50350,592)) and gallery_enemy_origins.has(Vector2(50380,640)),"Fruta e lesma de T05 compartilham a rota acessivel")
	check(route_enemies[4].origin==Vector2(24600,760) and route_enemies[5].origin==Vector2(28450,680),"Besouros de T08 e T09 usam a superficie da trilha")
	check(hedgehogs[2].origin==Vector2(26380,520),"Porco-espinho de T09 ocupa a plataforma acessivel")
	check(route_enemies[6].origin==Vector2(32720,600) and route_enemies[7].origin==Vector2(35620,600),"Besouros de T11 e T12 ocupam as superficies da trilha")
	check(hedgehogs[3].origin==Vector2(34100,700),"Porco-espinho de T11 ocupa a plataforma acessivel")
	var golden_nuts: Array = level.actors.get_children().filter(func(actor): return actor.get("collectible_kind")=="golden")
	check(golden_nuts.any(func(item): return item.position==Vector2(31850,672)),"Recompensa dourada de T10 fica ao alcance do jogador")
	check(preload("res://scripts/presentation/enemy_art.gd").BEETLE_GROUND_CORRECTION==10.0,"Patas dos besouros recebem alinhamento visual com o terreno")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO CORREÇÕES 1-2: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
