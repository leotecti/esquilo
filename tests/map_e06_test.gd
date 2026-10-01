extends "res://tests/expedition_save_test.gd"
const MAP_SLOT := "user://e06_test_only.json"
const MAP_LEGACY := "user://e06_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.store.path = MAP_SLOT
	campaign.legacy_path = MAP_LEGACY
	root.add_child(campaign)
	await frames(8)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(MAP_LEGACY)
	DirAccess.remove_absolute(MAP_SLOT)
	await open_campaign()
	check(campaign.map_is_open() and paused,"Nova campanha começa no mapa")
	check(campaign.world_map.world==0 and campaign.world_map.stage_state(0)=="CURRENT","Mapa começa no Bosque com primeira fase atual")
	for i in range(1,16): check(campaign.world_map.stage_state(i)=="LOCKED","Fase %d começa bloqueada" % i)
	var original: Vector2 = level.tico.position
	Input.action_press("move_right")
	await frames(15)
	Input.action_release("move_right")
	level.set_paused(false)
	check(paused and level.tico.position==original,"Mapa bloqueia movimento e tentativa de despausar")
	campaign.enter_from_map(5)
	check(campaign.data.stage==0 and campaign.map_is_open(),"Entrada direta em fase bloqueada é rejeitada")
	campaign.enter_from_map(0)
	await frames(5)
	check(not campaign.map_is_open() and not paused,"Primeira fase abre pelo mapa")
	check(not level.switch_character(),"Mapa não libera Pipo antes do resgate")
	level._on_exit(level.exit_marker)
	await frames(2)
	campaign.show_map()
	check(campaign.world_map.stage_state(1)=="AVAILABLE" and campaign.world_map.summary.levels["0"].completed,"Conclusão libera próximo nó e mantém conquista")
	campaign.enter_from_map(1)
	await frames(10)
	level = campaign.level
	check(campaign.data.stage==1 and not campaign.map_is_open(),"Nó disponível abre a fase correta")
	await close_world()
	await open_campaign()
	check(campaign.map_is_open() and campaign.world_map.selected==1,"Reabertura recupera fase atual no mapa")
	await close_world()
	var source := fixture(9)
	source.levels["9"].checkpoint = true
	source.levels["9"].character = "Pipo"
	write_raw(MAP_SLOT,JSON.stringify(source))
	await open_campaign()
	check(campaign.world_map.world==2 and campaign.data.save_version==2,"Campanha V1 migra e abre no mundo atual")
	campaign.close_map()
	await frames(3)
	check(level.tico==level.pipo and level.checkpoint_active,"Continuar preserva personagem e checkpoint")
	level.tico.health = 2
	var position_before: Vector2 = level.tico.position
	level.set_paused(true)
	campaign.show_map()
	campaign.world_map.select_world(0)
	campaign.close_map()
	check(level.tico.health==2 and level.tico.position==position_before,"Consultar mapa não cura nem reposiciona")
	campaign.show_map()
	campaign.world_map.select_world(0)
	campaign.world_map.select_stage(0)
	check(campaign.world_map.stage_state(0)=="COMPLETED","Mundo anterior mostra fase concluída")
	campaign.enter_from_map(0)
	await frames(10)
	level = campaign.level
	check(campaign.data.stage==0 and not level.completed and campaign.data.levels["0"].completed,"Replay mantém conclusão permanente e abre fase jogável")
	check(campaign.data.unlocked==9 and level.rescued,"Replay mantém fases liberadas e Pipo")
	check(campaign.store.valid(campaign.data),"Save de replay pelo mapa é válido")
	await close_world()
	for index in [0,4,8,12]:
		write_raw(MAP_SLOT,JSON.stringify(fixture(index)))
		await open_campaign()
		campaign.close_map()
		campaign.data.survival.lives = 1
		campaign.lose_life()
		campaign.show_return()
		var target := maxi(0,(index/4-1)*4)
		check(campaign.world_map.world==target/4 and campaign.world_map.selected==target,"Game Over abre mapa do mundo anterior %d" % index)
		campaign.close_map()
		check(campaign.map_is_open() and paused,"Game Over não retorna à fase derrotada pelo botão voltar")
		await close_world()
		await open_campaign()
		check(campaign.map_is_open() and campaign.world_map.selected==target,"Retorno pendente persiste na reabertura %d" % index)
		campaign.enter_from_map(target)
		await frames(10)
		level = campaign.level
		check(campaign.data.stage==target and campaign.data.unlocked==index and not campaign.awaiting_return(),"Entrada pelo mapa mantém desbloqueios %d" % index)
		await close_world()
	write_raw(MAP_SLOT,JSON.stringify(fixture(4)))
	await open_campaign()
	campaign.close_map()
	campaign.new_adventure()
	await frames(10)
	level = campaign.level
	check(campaign.map_is_open() and campaign.world_map.selected==0 and campaign.data.unlocked==0,"Nova aventura volta ao mapa inicial")
	await close_world()
	DirAccess.remove_absolute(MAP_SLOT)
	DirAccess.remove_absolute(MAP_LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
