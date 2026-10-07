extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(3)
	check(level.main_right==38000,"Fase 1-4 possui extensão equivalente às fases completas")
	check(level.checkpoint.position.x>level.optional_area.RETURN.x,"Bandeira única fica depois da saída da área secundária")
	check(level.guardian.position.x>34000 and level.exit_marker.position.x>level.guardian.position.x,"Periquito e portal encerram a jornada")
	var route_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("guardian_route_enemy"))
	var grotto_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_meta("waterfall_grotto_enemy"))
	check(route_enemies.size()>=11,"Trilha principal combina diferentes encontros")
	check(grotto_enemies.size()>=6,"Refúgio da cachoeira possui fauna própria")
	check(level.total_nuts>130 and level.total_foods>=25,"Alimentos e nozes preenchem os trechos exploráveis")
	check(level.optional_area.GROTTO_BACKGROUND!=null,"Refúgio possui paisagem exclusiva")
	check(level.optional_area.TERRAIN_STYLE_VERSION>=2,"Terreno da gruta usa rocha úmida, musgo e acabamento mineral")
	# Todo coletável está sobre alguma superfície navegável e perto o bastante para coleta ou salto.
	var unreachable := 0
	for actor in level.actors.get_children():
		if not actor.has_method("reset_item") or actor.position.x<3730: continue
		var supported := false
		for rect in level.terrain:
			if actor.position.x>=rect.position.x-20 and actor.position.x<=rect.end.x+20 and actor.position.y<=rect.position.y and actor.position.y>=rect.position.y-190:
				supported = true
				break
		if not supported:
			unreachable += 1
	check(unreachable==0,"Todos os coletáveis ficam em superfícies alcançáveis")
	level.tico.reset_at(level.optional_area.ENTRY)
	await frames(4)
	level.optional_area.travel(true)
	await frames(30)
	check(level.optional_area.active and level.camera.limit_left==level.optional_area.LEFT_EDGE,"Cachoeira leva ao refúgio e limita a câmera")
	level.tico.reset_at(level.optional_area.EXIT)
	level.optional_area.travel(false)
	await frames(30)
	check(not level.optional_area.active and absf(level.tico.position.x-level.optional_area.RETURN.x)<8 and level.tico.position.y<810,"Saída retorna à frente da cachoeira")
	check(campaign.store.valid(campaign.data),"Expansão preserva um save válido")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	DirAccess.remove_absolute(E03_LEGACY)
	print("RESULTADO FASE 1-4: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
