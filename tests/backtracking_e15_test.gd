extends "res://tests/expedition_save_test.gd"
const E15_SLOT := "user://e15_test_only.json"
const E15_LEGACY := "user://e15_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = E15_SLOT
	campaign.legacy_path = E15_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E15_SLOT)
	DirAccess.remove_absolute(E15_LEGACY)

	write_raw(E15_SLOT,JSON.stringify(fixture(0)))
	await open_campaign()
	check(not campaign.data.survival.pipo_unlocked and not is_instance_valid(level.backtrack_stone),"Primeira passagem não antecipa Pipo nem o segredo de retorno")
	await close_world()

	var rescued := fixture(3)
	rescued.stage = 0
	write_raw(E15_SLOT,JSON.stringify(rescued))
	await open_campaign()
	campaign.data.survival.replay = true
	campaign._load_stage(0)
	await frames(35)
	level = campaign.level
	check(level.rescued and is_instance_valid(level.backtrack_stone),"Revisita à 1-1 libera o trecho cooperativo após o resgate")
	check(not level.backtrack_open and level.backtrack_gate.visible,"Passagem começa fechada e não altera o caminho principal")
	check(level.terrain.any(func(rect): return rect.position==Vector2(14350,660) and rect.size==Vector2(900,24)),"Segredo da fase modelo fica em plataforma opcional sobre a rota")

	level._activate(level.pipo,Vector2(14390,660))
	await frames(5)
	for i in 430: level.backtrack_stone.push_by(level.pipo,1.0,1.0/60.0)
	await frames(3)
	check(level.backtrack_open and not level.backtrack_gate.visible,"Pipo empurra a pedra até a marca e abre a passagem")
	check("backtrack_cache_0_open" in campaign.data.story.events,"Mecanismo aberto é salvo como progresso permanente")
	var tico_height: float = level.squirrel.get_node("Collision").shape.size.y
	var pipo_height: float = level.pipo.get_node("Collision").shape.size.y
	check(tico_height<=64 and pipo_height>64,"Passagem estreita reserva a recompensa para a agilidade de Tico")
	level._activate(level.squirrel,level.backtrack_reward.position)
	await frames(4)
	check(level.backtrack_reward.taken and "retorno_01" in campaign.data.collectibles.golden_nuts.get("0",[]),"Tico coleta a Noz Dourada exclusiva da revisita")
	check(campaign.store.valid(campaign.data),"Save da E15 permanece válido após mecanismo e recompensa")
	await close_world()

	await open_campaign()
	check(level.backtrack_open and level.backtrack_reward.taken,"Reabertura preserva passagem aberta e tesouro coletado")
	campaign.data.stage = 1
	campaign.data.survival.replay = true
	campaign._load_stage(1)
	await frames(35)
	level = campaign.level
	check(is_instance_valid(level.backtrack_stone) and not level.backtrack_open,"Fase 1-2 também recebe um segredo curto na revisita")
	check(not level.get_node("Geometry").has_node("BacktrackRoof"),"Fase 1-2 não cria apoio invisível sobre a rota")
	check(level.terrain.any(func(rect): return rect.position==Vector2(2130,660) and rect.size==Vector2(300,24)),"Laje esquerda sustenta a pedra em uma superfície visível")
	check(level.terrain.any(func(rect): return rect.position==Vector2(2510,660) and rect.size==Vector2(160,24)),"Abertura entre as lajes permite visitar a rota inferior")
	level._on_exit(level.exit_marker)
	await frames(3)
	check(level.completed and "retorno_02" not in campaign.data.collectibles.golden_nuts.get("1",[]),"Exploração continua opcional e não impede concluir a fase")
	check(campaign.data.survival.pipo_unlocked,"Troca de fase preserva o desbloqueio global de Pipo")
	await close_world()

	DirAccess.remove_absolute(E15_SLOT)
	DirAccess.remove_absolute(E15_LEGACY)
	print("RESULTADO E15: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
