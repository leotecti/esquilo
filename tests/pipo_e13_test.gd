extends "res://tests/checkpoints_e03_test.gd"
const E13_SLOT := "user://e13_test_only.json"
const E13_LEGACY := "user://e13_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = E13_SLOT
	campaign.legacy_path = E13_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E13_SLOT)
	DirAccess.remove_absolute(E13_LEGACY)
	var fresh := fixture(2)
	fresh.levels["2"].rescued = false
	write_raw(E13_SLOT,JSON.stringify(fresh))
	await open_campaign()
	check(level.world_stage==2 and not level.rescued and level.tico==level.squirrel,"1-3 mantém somente Tico antes do resgate")
	check(campaign.narrative.active and campaign.narrative.sequence_id=="pipo_first_meeting","Encontro apresenta Pipo antes do desafio jogável")
	check(campaign.narrative.scene_image.texture!=null and campaign.narrative.story_companion.visible,"Cena mostra floresta e Pipo junto de Tico")
	var meeting_text := JSON.stringify(campaign.narrative.steps)
	check(meeting_text.contains("família") and meeting_text.contains("comida") and meeting_text.contains("bloco rachado"),"Primeiro diálogo explica Pipo, a escassez e como resgatá-lo")
	check(not level.switch_character(),"Narrativa não libera Pipo antes do resgate")
	campaign.narrative.skip_button.pressed.emit()
	await frames(2)
	check("pipo_first_meeting" in campaign.data.story.events and not campaign.narrative.active,"Encontro pode ser pulado e fica registrado")
	level._on_block(level.rescue_lock,false)
	await frames(3)
	check(level.rescued and campaign.data.survival.pipo_unlocked,"Resgate jogável libera Pipo globalmente")
	check(campaign.narrative.active and campaign.narrative.sequence_id=="pipo_joins_team","Resgate inicia a conversa de entrada na equipe")
	var joining_text := JSON.stringify(campaign.narrative.steps)
	check(joining_text.contains("Valda") and joining_text.contains("mover pedras") and joining_text.contains("saltar mais alto"),"Conversa conecta a missão e as habilidades complementares")
	var actors: Array = campaign.narrative.steps.filter(func(step): return step.get("type")=="animation").map(func(step): return step.get("actor"))
	check("tico" in actors and "pipo" in actors,"Demonstração anima a força de Pipo e a agilidade de Tico")
	campaign.narrative.skip_button.pressed.emit()
	level.tico.reset_at(Vector2(level.tico.position.x,760))
	await frames(8)
	check("pipo_joins_team" in campaign.data.story.events and level.switch_character(),"Pipo entra na equipe e pode ser controlado")
	check(campaign.store.valid(campaign.data),"Save V2 permanece válido após a apresentação")
	# Pipo deve continuar disponível quando o jogador retorna a uma fase inicial.
	campaign.data.stage = 0
	campaign.data.survival.replay = true
	campaign._load_stage(0)
	await frames(35)
	level = campaign.level
	level.tico.reset_at(Vector2(level.tico.position.x,760))
	await frames(8)
	check(level.rescued and level.switch_character() and level.tico==level.pipo,"Pipo fica disponível nas fases iniciais revisitadas")
	await close_world()
	await open_campaign()
	check(not campaign.narrative.active and "pipo_joins_team" in campaign.data.story.events,"Cenas concluídas não se repetem ao reabrir")
	await close_world()
	# Migração antiga com Pipo já resgatado preserva o progresso sem cena retroativa.
	DirAccess.remove_absolute(E13_SLOT)
	var legacy := fixture(3)
	write_raw(E13_SLOT,JSON.stringify(legacy))
	await open_campaign()
	check(campaign.data.survival.pipo_unlocked and not campaign.narrative.active,"Save antigo preserva Pipo sem interromper a partida")
	await close_world()
	DirAccess.remove_absolute(E13_SLOT)
	DirAccess.remove_absolute(E13_LEGACY)
	print("RESULTADO E13: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
