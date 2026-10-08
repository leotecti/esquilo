extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	check(level.main_right==38000 and level.exit_marker.position.x>37000,"Fase 2-1 possui percurso completo de aproximadamente 38.000 unidades")
	check(level.headwind_zones.size()==1 and level.headwind_zones[0].end.x>=38000,"Vento contrário acompanha toda a trilha principal")
	check(level.checkpoint.position.x>level.optional_area.RETURN.x and level.checkpoint.position.x<level.exit_marker.position.x,"Bandeira única fica depois do retorno da área secundária")
	check(level.optional_area.entry_point()==Vector2(18418,720) and level.optional_area.RETURN==Vector2(24600,760),"Caverna aparece em T06 e devolve o jogador adiante")
	var route_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("river_expansion_enemy"))
	var optional_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("waterfall_grotto_enemy"))
	check(route_enemies.size()>=13 and optional_enemies.size()>=6,"Trilha e refúgio possuem encontros variados")
	check(route_enemies.all(func(enemy): return enemy.get_meta("pipo_one_hit",false)),"Inimigos da expansão seguem a regra de um golpe de Pipo")
	check(optional_enemies.all(func(enemy): return enemy.get_meta("pipo_one_hit",false)),"Inimigos da cachoeira seguem a regra de um golpe de Pipo")
	check(level.total_nuts>=110 and level.total_foods>=30,"Nozes e alimentos preenchem o percurso alcançável")
	var healing_items: Array = level.actors.get_children().filter(func(actor): return actor.has_method("reset_item") and actor.get("collectible_kind")=="heart")
	check(healing_items.size()>=3,"Trilha oferece corações e a campanha acrescenta o bloco de vida da fase")
	var unreachable := 0
	for actor in level.actors.get_children():
		if not actor.has_method("reset_item") or actor.position.x<3800 or actor.position.x>38000: continue
		var supported: bool = level.terrain.any(func(rect: Rect2):
			return actor.position.x>=rect.position.x-20 and actor.position.x<=rect.end.x+20 and actor.position.y<=rect.position.y and actor.position.y>=rect.position.y-190)
		if not supported: unreachable += 1
	check(unreachable==0,"Todas as recompensas da trilha principal ficam em superfícies alcançáveis")
	level.tico.reset_at(level.optional_area.entry_point())
	level.optional_area.travel(true)
	await frames(30)
	check(level.optional_area.active and level.camera.limit_left==level.optional_area.LEFT_EDGE,"Entrada da caverna leva à área secundária")
	check(level.optional_area.RIVER_CAVE_STYLE_VERSION==2 and level.optional_area.RIVER_CAVE_PLATFORMS.size()==9,"Caverna usa arco rochoso, solo mineral e rota vertical própria")
	check(not level.optional_area.RIVER_CAVE_PLATFORMS.has(level.optional_area.GROTTO_PLATFORMS[0]),"Caverna do rio não reutiliza o percurso baixo da cachoeira")
	check(level.optional_area.exit_point()==Vector2(77930,525),"Portal de saída acompanha a plataforma elevada final")
	level.tico.reset_at(level.optional_area.EXIT)
	level.optional_area.travel(false)
	await frames(30)
	check(not level.optional_area.active and level.tico.position.distance_to(level.optional_area.RETURN)<12,"Saída secundária preserva o progresso da fase")
	await close_level()
	print("RESULTADO EXPANSÃO 2-1: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
