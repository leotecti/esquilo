extends "res://tests/checkpoints_e03_test.gd"
const E11_SLOT := "user://e11_test_only.json"
const E11_LEGACY := "user://e11_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.store.path = E11_SLOT
	campaign.legacy_path = E11_LEGACY
	root.add_child(campaign)
	await frames(12)
	level = campaign.level

func finish_opening() -> Dictionary:
	var seen := {"village":false,"trapped":false,"rescued":false,"title":false}
	for _frame in 1200:
		if campaign.map_is_open(): break
		if campaign.narrative.active:
			var index: int = campaign.narrative.step_index
			if index>=0 and index<campaign.narrative.steps.size():
				var step: Dictionary = campaign.narrative.steps[index]
				var title: String = campaign.narrative.scene_title.text
				if title=="O vilarejo na floresta": seen.village = true
				elif title=="Além das trilhas conhecidas": seen.trapped = true
				elif title=="Uma nova amiga": seen.rescued = true
				elif title=="Tico e a Floresta das Nozes": seen.title = true
				if str(step.get("type",""))=="dialogue": campaign.narrative._advance()
		await frames(1)
	return seen

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E11_SLOT)
	DirAccess.remove_absolute(E11_LEGACY)
	await open_campaign()
	check(campaign.narrative.active and paused,"Nova campanha inicia pela abertura antes do mapa")
	check(campaign.narrative.scene_image.texture!=null,"Abertura apresenta ilustração em tela")
	check(campaign.narrative.dialogue.text.contains("inverno"),"Primeira fala estabelece a preparação para o inverno")
	var seen := await finish_opening()
	check(seen.village and seen.trapped and seen.rescued and seen.title,"Sequência percorre vilarejo, encontro, resgate e título")
	check(campaign.map_is_open() and paused,"Conclusão leva ao mapa da jornada")
	for id in ["owl_rescued","first_clue_received","opening_complete"]:
		check(id in campaign.data.story.events,"Abertura registra evento %s" % id)
	check(campaign.store.valid(campaign.data),"Save da abertura permanece válido")
	await close_world()
	await open_campaign()
	check(campaign.map_is_open() and not campaign.narrative.active,"Abertura concluída não se repete ao reabrir")
	await close_world()
	DirAccess.remove_absolute(E11_SLOT)
	await open_campaign()
	check(campaign.narrative.active,"Nova campanha volta a apresentar a abertura")
	campaign.narrative.skip_button.pressed.emit()
	await frames(3)
	check(campaign.map_is_open() and "opening_complete" in campaign.data.story.events,"Pular abertura também segue para o mapa e persiste")
	check("owl_rescued" not in campaign.data.story.events,"Pular não registra eventos narrativos ainda não vistos")
	await close_world()
	DirAccess.remove_absolute(E11_SLOT)
	write_raw(E11_SLOT,JSON.stringify(fixture(0)))
	await open_campaign()
	check(campaign.map_is_open() and not campaign.narrative.active,"Campanha anterior migra sem abertura inesperada")
	check("opening_complete" in campaign.data.story.events,"Migração registra compatibilidade da abertura")
	await close_world()
	DirAccess.remove_absolute(E11_SLOT)
	DirAccess.remove_absolute(E11_LEGACY)
	print("RESULTADO E11: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
