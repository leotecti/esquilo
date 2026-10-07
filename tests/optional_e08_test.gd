extends "res://tests/checkpoints_e03_test.gd"

func travel(entering: bool) -> void:
	level.optional_area.travel(entering)
	await create_timer(.45,true).timeout

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(0)
	campaign.data.survival.lives = 5
	check(is_instance_valid(level.optional_area),"Primeiros Passos possui área opcional")
	var canopy_floor_visual := level.get_node_or_null("ForestOptionalCanopy")
	check(is_instance_valid(canopy_floor_visual) and canopy_floor_visual.platforms.any(func(rect): return rect==Rect2(60000,760,4000,200)),"Copa possui piso visual em toda a área caminhável")
	check(not level.optional_area.active and level.total_nuts==271,"Trilha E09 tem 245 nozes principais e 26 opcionais")
	check(level.main_right==42000 and level.exit_marker.position.x==41780,"Trilha principal ganha trecho final")
	check(level.optional_area.RIGHT_EDGE==64000 and level.optional_area.slugs.size()==3,"Copa ampliada tem três lesmas")
	level._on_checkpoint(level.checkpoint)
	await travel(true)
	check(level.optional_area.active and level.tico.position.x>5900,"Transição entra na copa")
	check(level.camera.limit_left==60000,"Câmera acompanha área secundária")
	check(level.checkpoint_active,"Entrada preserva bandeira principal")
	check(campaign.store.valid(campaign.data),"Save com área secundária é válido")
	defeat()
	await await_return()
	check(level.tico.position.distance_to(level.optional_area.START)<15,"Sem bandeira local retorna à entrada da copa")
	level.tico.reset_at(level.optional_area.FLAG)
	await frames(12)
	check(not level.optional_area.checkpoint,"Copa n?o cria uma segunda bandeira")
	var item: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.get_meta("save_id","")=="6500:615": item = actor
	level.tico.reset_at(level.optional_area.location(Vector2(6500,650)))
	await frames(12)
	check(item.taken,"Noz opcional coleta por contato")
	var count: int = level.nuts
	defeat()
	await await_return()
	check(level.tico.position.distance_to(level.optional_area.START)<15,"Derrota na copa retorna ? entrada")
	check(item.taken and level.nuts==count,"Derrota não duplica recompensa")
	await close_world()
	await open_campaign()
	check(level.optional_area.active and not level.optional_area.checkpoint,"Reabertura recupera área e bandeira")
	check(level.tico.position.distance_to(level.optional_area.START)<15,"Reabertura usa posição segura")
	check(level.nuts==count,"Reabertura preserva itens coletados")
	var lives_before: int = campaign.data.survival.lives
	check(level.optional_area.bonus_life.has_meta("life_cache"),"Vida da copa está dentro de um bloco raro")
	level.optional_area.bonus_life.hit_from_below()
	await frames(2)
	check(campaign.data.survival.lives==lives_before+1,"Bloco raro da copa acrescenta uma vida")
	check("copa_life" in campaign.store.read_save().story.events,"Vida da copa fica registrada no save")
	check(not campaign.claim_life(0,"copa_life"),"Vida da copa não pode ser recebida duas vezes")
	check(not campaign.claim_life(0,"unknown_reward"),"Recompensa desconhecida é rejeitada")
	await close_world()
	await open_campaign()
	check(not is_instance_valid(level.optional_area.bonus_life),"Vida coletada não reaparece ao reabrir")
	await travel(false)
	check(not level.optional_area.active and level.tico.position.distance_to(level.optional_area.RETURN)<15,"Portal avança até perto da bandeira: %s" % level.tico.position)
	check(level.camera.limit_left==0 and level.checkpoint_active,"Retorno restaura câmera sem perder bandeira principal")
	defeat()
	await await_return()
	check(level.tico.position.distance_to(level.checkpoint_position)<15,"Após sair da copa, morte usa bandeira principal")
	await travel(true)
	campaign.data.survival.lives = 1
	defeat()
	await await_return()
	check(campaign.awaiting_return() and campaign.map_is_open(),"Game Over da copa abre o mapa")
	if campaign.awaiting_return():
		campaign.resume_at(0)
		await frames(10)
		level = campaign.level
	check(not level.optional_area.active,"Game Over/reinício não prende jogador na copa")
	await close_world()
	await start_phase(0)
	await travel(true)
	await restart_phase()
	check(not level.optional_area.active and not level.optional_area.checkpoint,"Reiniciar fase retorna ao caminho principal")
	var invalid: Dictionary = campaign.data.duplicate(true)
	invalid.levels["0"].optional_area.active = "yes"
	check(not campaign.store.valid(invalid),"Validação rejeita estado inválido")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
