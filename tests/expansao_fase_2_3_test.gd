extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"3")
	check(level.main_right==38000 and level.exit_marker.position.x>37000,"Fase 2-3 possui aproximadamente 38.000 unidades")
	check(level.checkpoint.position.x>level.optional_area.RETURN.x and level.checkpoint.position.x<level.exit_marker.position.x,"Bandeira única fica depois do retorno da área secundária")
	check(level.optional_area.ENTRY==Vector2(18400,720) and level.optional_area.RETURN.x>24000,"Galeria ocupa o trecho central e devolve o jogador adiante")
	var route_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("rainy_bridge_enemy"))
	var optional_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("storm_drain_enemy"))
	check(route_enemies.size()>=20 and optional_enemies.size()>=10,"Trilha e galeria possuem encontros mais frequentes e perigosos")
	check(level.total_nuts>=110 and level.total_foods>=30,"Nozes, alimentos e corações preenchem os percursos")
	var unsupported := 0
	for actor in level.actors.get_children():
		if not actor.has_method("reset_item") or actor.position.x<3800 or actor.position.x>38000: continue
		var supported: bool = level.terrain.any(func(rect: Rect2):
			return actor.position.x>=rect.position.x-20 and actor.position.x<=rect.end.x+20 and actor.position.y<=rect.position.y and actor.position.y>=rect.position.y-190)
		if not supported: unsupported += 1
	check(unsupported==0,"Recompensas da trilha principal ficam em superfícies alcançáveis")
	level.tico.reset_at(level.optional_area.ENTRY)
	level.optional_area.travel(true)
	await frames(30)
	check(level.optional_area.active and level.camera.limit_left==level.optional_area.LEFT_EDGE,"Portal leva à Galeria da Tempestade")
	check(not level.scenery.visible and not level.scenery.is_processing(),"Galeria suspende chuva e cenário principal fora da câmera")
	check(level.optional_area.STYLE_VERSION==1 and level.optional_area.PLATFORMS.size()==9 and level.optional_area.BACKGROUND.resource_path.ends_with("river_cave_background.png"),"Galeria possui paisagem subterrânea e percurso próprios")
	level.tico.reset_at(level.optional_area.EXIT)
	level.optional_area.travel(false)
	await frames(30)
	check(not level.optional_area.active and level.tico.position.distance_to(level.optional_area.RETURN)<12,"Saída da galeria preserva o progresso")
	check(level.scenery.visible and level.scenery.is_processing(),"Retorno reativa o cenário chuvoso")
	await close_level()
	print("RESULTADO EXPANSÃO 2-3: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
