extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(1)
	check(level.main_right==39000 and level.exit_marker.position==Vector2(38780,550),"1-2 possui percurso completo e chegada própria")
	check(level.total_nuts>=180 and level.total_foods>=30,"Percurso oferece recompensas durante toda a jornada")
	check(InputMap.has_action("move_down") and level.drop_platforms.size()>=8,"Comando Baixo cria rotas inferiores recorrentes sem ampliar a fase")
	var lower_bridge: Rect2 = level.drop_platforms[0]
	level.tico.reset_at(Vector2(lower_bridge.get_center().x,lower_bridge.position.y))
	await frames(8)
	key(KEY_S,true)
	await frames(18)
	key(KEY_S,false)
	await frames(20)
	check(level.tico.position.y>lower_bridge.position.y+45,"Baixo atravessa a ponte e alcança o caminho inferior")
	var blocks := 0
	var route_enemies := 0
	var hearts := 0
	for actor in level.actors.get_children():
		if actor.has_method("reset_block"): blocks += 1
		if actor.has_meta("e20_route_enemy"): route_enemies += 1
		if actor.has_method("reset_item") and actor.healing: hearts += 1
	check(blocks>=45,"Blocos são a mecânica central da fase")
	check(route_enemies>=8 and level.actors.has_node("HedgehogE20_12220"),"Rota alterna inimigos e áreas seguras")
	check(hearts>=7,"Rota e galeria oferecem recuperação")
	check(level.checkpoint.position.x>level.optional_area.ENTRY.x and level.checkpoint.position.x<level.exit_marker.position.x,"Bandeira única fica depois da área secundária")
	check(level.optional_area.ENTRY==Vector2(19400,475) and level.optional_area.LEFT_EDGE==46000,"Galeria fica no meio e usa espaço próprio")
	var gallery_floor_visual := level.get_node_or_null("ForestOptionalGallery")
	check(is_instance_valid(gallery_floor_visual) and gallery_floor_visual.platforms.any(func(rect): return rect==Rect2(46000,760,5200,220)),"Galeria possui piso visual em toda a área caminhável")
	check(level.optional_area.enemies.size()==3 and is_instance_valid(level.optional_area.bonus_life),"Galeria contém inimigos, vida e recompensa especial")
	level.optional_area.travel(true)
	await create_timer(.45,true).timeout
	check(level.optional_area.active and level.tico.position.x>=level.optional_area.LEFT_EDGE and level.tico.position.x<level.optional_area.LEFT_EDGE+1400,"Ruína de pedra leva à Galeria das Pedras")
	check(level.camera.limit_left==level.optional_area.LEFT_EDGE,"Câmera permanece dentro da galeria")
	var lives_before: int = campaign.data.survival.lives
	level.tico.reset_at(Vector2(50060,635))
	await frames(8)
	key(KEY_SPACE,true)
	await frames(35)
	key(KEY_SPACE,false)
	await frames(35)
	check(level.optional_area.bonus_life.used and campaign.data.survival.lives==lives_before+1,"Cabeçada real abre o bloco e concede a vida da galeria")
	var saved: Dictionary = level.world_snapshot()
	check(saved.optional_area.active and campaign.store.valid(campaign.data),"Área secundária ativa produz save válido")
	level.tico.reset_at(level.optional_area.EXIT)
	await frames(8)
	Input.action_press("action")
	await frames(2)
	Input.action_release("action")
	await create_timer(.45,true).timeout
	check(not level.optional_area.active and absf(level.tico.position.x-level.optional_area.RETURN.x)<15,"Portal final visível e acionável avança até perto da bandeira")
	check(level.optional_area.RETURN.x<level.checkpoint.position.x,"Retorno preserva a sensação de progresso")
	var return_x: float = level.tico.position.x
	key(KEY_D,true)
	await frames(30)
	key(KEY_D,false)
	check(level.tico.position.x>return_x+60,"Personagem consegue caminhar imediatamente depois do retorno")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
