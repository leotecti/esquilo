extends "res://tests/expedition_save_test.gd"
const MINI_SLOT := "user://mini_adventure_validation.json"
const MINI_LEGACY := "user://mini_adventure_legacy.json"

func open_miniature() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = true
	campaign.store.path = MINI_SLOT
	campaign.legacy_path = MINI_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func enter_stage(index: int) -> void:
	check(campaign.map_is_open(),"Mapa disponível antes de entrar na fase %d" % index)
	campaign.world_map.focus_stage(index)
	campaign.enter_from_map(index)
	await frames(35)
	level = campaign.level
	check(int(campaign.data.stage)==index and not campaign.map_is_open(),"Mapa inicia a fase %d selecionada" % index)

func finish_stage() -> void:
	level._on_exit(level.exit_marker)
	await frames(4)
	check(level.completed and campaign.store.state=="saved","Conclusão da fase é salva antes do retorno ao mapa")
	campaign.advance()
	await frames(8)

func first_collectible(kind: String) -> Node2D:
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.collectible_kind==kind and not actor.taken:
			return actor
	return null

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(MINI_SLOT)
	DirAccess.remove_absolute(MINI_LEGACY)
	await open_miniature()

	check(campaign.narrative.active and campaign.narrative.sequence_id=="opening_complete","Aventura começa com a narrativa de Tico e Valda")
	check(campaign.narrative.scene_image.texture!=null,"Abertura mantém cenário e personagens visíveis")
	campaign.narrative.skip_button.pressed.emit()
	await frames(30)
	check("opening_complete" in campaign.data.story.events and campaign.map_is_open(),"Abertura conduz ao mapa e fica registrada")

	await enter_stage(0)
	var nut := first_collectible("nut")
	var food := first_collectible("food")
	check(is_instance_valid(nut) and is_instance_valid(food),"Primeira fase oferece nozes e alimentos")
	level.tico.reset_at(nut.position+Vector2(0,20))
	await frames(5)
	level.tico.reset_at(food.position+Vector2(0,20))
	await frames(5)
	check(nut.taken and food.taken,"Coletáveis comuns entram no progresso da aventura")
	check(is_instance_valid(level.optional_area),"Primeira fase possui a Copa dos Segredos")
	level.optional_area.travel(true)
	await frames(45)
	check(level.optional_area.active,"Portal leva à área opcional")
	var golden: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.collectible_kind=="golden" and actor.reward_id=="copa_01": golden = actor
	level.tico.reset_at(golden.position)
	await frames(5)
	check(golden.taken and "copa_01" in campaign.data.collectibles.golden_nuts.get("0",[]),"Área opcional entrega uma conquista permanente")
	level.optional_area.travel(false)
	await frames(45)
	check(not level.optional_area.active,"Portal devolve Tico ao caminho principal")
	await finish_stage()
	check(campaign.map_is_open() and int(campaign.data.unlocked)>=1,"Primeira conclusão desbloqueia a fase seguinte no mapa")

	await enter_stage(1)
	level._on_block(level.secret_block,false)
	await frames(3)
	check(level.secret.revealed,"Segunda fase combina blocos e segredo")
	await finish_stage()
	check(campaign.map_is_open() and int(campaign.data.unlocked)>=2,"Progressão libera o encontro com Pipo")

	await enter_stage(2)
	check(campaign.narrative.active and campaign.narrative.sequence_id=="pipo_first_meeting","Terceira fase apresenta Pipo dentro da história")
	campaign.narrative.skip_button.pressed.emit()
	await frames(3)
	level._on_block(level.rescue_lock,false)
	await frames(3)
	check(level.rescued and campaign.data.survival.pipo_unlocked,"Resgate libera Pipo globalmente")
	if campaign.narrative.active: campaign.narrative.skip_button.pressed.emit()
	await frames(4)
	level.tico.reset_at(Vector2(level.tico.position.x,760))
	await frames(6)
	check(level.switch_character() and level.tico==level.pipo,"Fase demonstra a cooperação jogável da dupla")
	await finish_stage()
	check(campaign.map_is_open() and int(campaign.data.unlocked)>=3,"Resgate libera o encontro decisivo do mundo")

	await enter_stage(3)
	level._on_exit(level.exit_marker)
	check(not level.completed,"Saída do encontro aguarda a resolução do chefe")
	level.guardian.health = 0
	level.guardian.phase = "calm"
	await finish_stage()
	check(campaign.narrative.active and campaign.narrative.sequence_id=="valda_after_3","Valda encerra o mundo e apresenta a próxima pista")
	campaign.narrative.skip_button.pressed.emit()
	await frames(30)
	check(campaign.map_is_open() and int(campaign.data.unlocked)>=4,"Chefe e narrativa liberam o próximo mundo no mapa")
	check(campaign.store.valid(campaign.data),"A aventura completa mantém um Save V2 válido")
	await close_world()

	await open_miniature()
	check(campaign.map_is_open() and not campaign.narrative.active,"Reabertura retorna ao mapa sem repetir cenas concluídas")
	check(campaign.data.survival.pipo_unlocked and campaign.data.levels["3"].completed,"Reabertura preserva Pipo e o Mundo 1 concluído")
	check("copa_01" in campaign.data.collectibles.golden_nuts.get("0",[]),"Reabertura preserva a conquista da área opcional")
	await close_world()

	DirAccess.remove_absolute(MINI_SLOT)
	DirAccess.remove_absolute(MINI_LEGACY)
	print("RESULTADO VALIDAÇÃO 2: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
