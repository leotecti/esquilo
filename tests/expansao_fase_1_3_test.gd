extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(2)
	check(level.main_right==38000 and level.exit_marker.position==Vector2(37780,550),"1-3 possui percurso completo e chegada própria")
	check(level.total_nuts>=150 and level.total_foods>=20,"Jornada mantém recompensas e provisões distribuídas: %d nozes e %d alimentos" % [level.total_nuts,level.total_foods])
	check(level.rescued and is_instance_valid(level.optional_area),"Expansão preserva o resgate e libera a área secundária")
	check(level.optional_area.ENTRY==Vector2(19500,520) and level.optional_area.LEFT_EDGE==65000,"Túnel aparece no meio e leva a uma área própria")
	check(level.checkpoint.position.x>level.optional_area.ENTRY.x and level.checkpoint.position.x<level.exit_marker.position.x,"Bandeira única fica depois da saída da caverna")
	var route_enemies := 0
	var bats := 0
	for actor in level.actors.get_children():
		if actor.has_meta("friend_route_enemy"): route_enemies += 1
		if actor.has_meta("friend_cave_bat"): bats += 1
	check(route_enemies>=8,"Rota principal alterna encontros e áreas seguras")
	check(bats==4 and level.optional_area.drips.size()==6,"Caverna possui morcegos e seis goteiras perigosas")
	level.optional_area.travel(true)
	await create_timer(.5,true).timeout
	check(level.optional_area.active and level.camera.limit_left==level.optional_area.LEFT_EDGE,"Entrada atravessa o túnel e limita a câmera à caverna")
	var drip: Node2D = level.optional_area.drips[0]
	level.tico.health = 3
	level.tico.invulnerability_left = 0
	drip.clock = drip.cycle*.55
	drip.current_y = lerpf(12.0,drip.drop_y,(.55-.42)/.26)
	level.tico.position = drip.origin+Vector2(0,drip.current_y)
	drip._physics_process(0)
	check(level.tico.health==2,"Pingo causa dano somente durante a queda anunciada")
	check(level.world_snapshot().optional_area.active and campaign.store.valid(campaign.data),"Estado da caverna produz save válido")
	level.tico.invulnerability_left = 0
	level.tico.reset_at(level.optional_area.EXIT)
	await frames(30)
	Input.action_press("action")
	await frames(2)
	Input.action_release("action")
	await create_timer(.5,true).timeout
	check(not level.optional_area.active and absf(level.tico.position.x-level.optional_area.RETURN.x)<20,"Saída retorna adiante, perto da bandeira")
	var return_x: float = level.tico.position.x
	key(KEY_D,true)
	await frames(30)
	key(KEY_D,false)
	check(level.tico.position.x>return_x+60,"Personagem se move imediatamente depois do retorno")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO 1-3: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
