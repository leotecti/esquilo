extends "res://tests/checkpoints_e03_test.gd"
const E12_SLOT := "user://e12_test_only.json"
const E12_LEGACY := "user://e12_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = E12_SLOT
	campaign.legacy_path = E12_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func finish_encounter() -> Dictionary:
	var seen := {"tico":false,"valda":false,"guidance":false}
	for _frame in 900:
		if campaign.map_is_open(): break
		if campaign.narrative.active:
			var step: Dictionary = campaign.narrative.steps[campaign.narrative.step_index]
			if step.get("speaker")=="Tico": seen.tico = true
			if step.get("speaker")=="Valda": seen.valda = true
			if str(step.get("text","")).length()>45: seen.guidance = true
			if step.get("type")=="dialogue": campaign.narrative._advance()
		await frames(1)
	return seen

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E12_SLOT)
	DirAccess.remove_absolute(E12_LEGACY)
	for stage in [3,7,11,15]:
		var saved := fixture(stage)
		saved.levels[str(stage)] = state_for(stage,true)
		saved.unlocked = mini(stage+1,15)
		saved.finished = stage==15
		write_raw(E12_SLOT,JSON.stringify(saved))
		await open_campaign()
		campaign.start_on_map = true
		campaign.advance()
		await frames(2)
		check(campaign.narrative.active,"Valda encontra os amigos após a etapa decisiva %d" % stage)
		check(campaign.narrative.scene_image.texture!=null,"Encontro %d mantém Valda e a paisagem visíveis" % stage)
		var seen := await finish_encounter()
		var event_id := "valda_after_%d" % stage
		check(seen.tico and seen.valda and seen.guidance,"Encontro %d alterna relato, orientação e próxima pista" % stage)
		check(campaign.map_is_open() and event_id in campaign.data.story.events,"Encontro %d termina no mapa e persiste" % stage)
		check(campaign.store.valid(campaign.data),"Save permanece válido após encontro %d" % stage)
		await close_world()
		await open_campaign()
		campaign.start_on_map = true
		campaign.advance()
		await frames(3)
		check(campaign.map_is_open() and not campaign.narrative.active,"Encontro %d não se repete ao reabrir" % stage)
		await close_world()
	DirAccess.remove_absolute(E12_SLOT)
	DirAccess.remove_absolute(E12_LEGACY)
	print("RESULTADO E12: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
