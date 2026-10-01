extends "res://tests/expedition_save_test.gd"
const E05_SLOT := "user://e05_test_only.json"
const E05_LEGACY := "user://e05_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = E05_SLOT
	campaign.legacy_path = E05_LEGACY
	root.add_child(campaign)
	await frames(10)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E05_LEGACY)
	var manager = CAMPAIGN_SAVE.new()
	for index in 16:
		var old := fixture(index)
		var original := JSON.stringify(old)
		var migrated: Dictionary = manager.migrate(old)
		check(manager.valid(migrated) and migrated.save_version==2,"Migração válida da fase %d" % index)
		check(JSON.stringify(old)==original and migrated.levels==old.levels,"Migração preserva dados e não altera origem %d" % index)
		check(manager.migrate(migrated)==migrated,"Migração idempotente %d" % index)
	var old := fixture(9)
	old.levels["9"].secret = true
	old.levels["9"].items = ["1580:718"]
	old.levels["9"].checkpoint = true
	old.levels["9"].character = "Pipo"
	old.tutorials = {"tutorial_glide_seen":true}
	old.context_hints_seen = ["walk"]
	old.survival = {"lives":7,"pending_return":false,"return_stage":4,"replay":false,"pipo_unlocked":true,"claimed":[0,4]}
	write_raw(E05_SLOT,JSON.stringify(old))
	await open_campaign()
	check(campaign.data.save_version==2 and campaign.store.state=="saved","V1 é gravado como V2 no mesmo slot")
	check(level.tico==level.pipo and level.checkpoint_active and level.secret.taken,"Migração restaura Pipo, checkpoint e noz secreta")
	check(campaign.data.survival.lives==7 and campaign.data.survival.claimed==[0,4] and campaign.data.survival.return_stage==4 and campaign.data.tutorials.tutorial_glide_seen,"Vidas, recompensas e tutoriais preservados")
	var summary: Dictionary = campaign.progress_summary()
	check(summary.current==9 and summary.unlocked.size()==10 and summary.completed.size()==9,"Consulta de progresso deriva fases sem divergências")
	check(summary.characters==["Tico","Pipo"] and summary.levels["9"].secret,"Consulta inclui personagens e segredo")
	check("pipo_rescued" in summary.story.events and "guardian_7_calmed" in summary.story.events,"Eventos existentes são inferidos na migração")
	summary.story.events.clear()
	summary.levels["9"].items.clear()
	check(not campaign.data.story.events.is_empty() and not campaign.data.levels["9"].items.is_empty(),"Consulta não permite alterar o save por referência")
	check(campaign.record_golden_nut("caverna_01"),"Registra Noz Dourada com ID estável")
	check(not campaign.record_golden_nut("caverna_01") and not campaign.record_golden_nut(""),"Rejeita recompensa duplicada e ID vazio")
	check(campaign.record_story_event("mentor_clue_01") and campaign.set_village_flag("bridge_repaired",true),"Registra narrativa e estado do vilarejo")
	check(not campaign.record_story_event("mentor_clue_01"),"Evento narrativo não se duplica")
	await close_world()
	await open_campaign()
	check(campaign.data.collectibles.golden_nuts["9"]==["caverna_01"],"Noz Dourada persiste ao fechar e reabrir")
	check("mentor_clue_01" in campaign.data.story.events and campaign.data.story.village.bridge_repaired,"Narrativa e vilarejo persistem")
	campaign.restart_stage()
	await frames(15)
	level = campaign.level
	check(campaign.data.collectibles.golden_nuts["9"].size()==1 and campaign.progress_summary().completed.size()==9,"Reiniciar mantém recompensas e conclusões")
	var valid: Dictionary = campaign.data.duplicate(true)
	await close_world()
	for field in ["story","collectibles","survival","tutorials","context_hints_seen"]:
		var damaged := valid.duplicate(true)
		damaged.erase(field)
		check(not manager.valid(damaged),"V2 exige campo %s" % field)
	for ids in [["a","a"],[""],[4],["bad id"]]:
		var damaged := valid.duplicate(true)
		damaged.collectibles.golden_nuts["9"] = ids
		check(not manager.valid(damaged),"Rejeita lista inválida de Nozes Douradas")
	var damaged := valid.duplicate(true)
	damaged.collectibles.golden_nuts["15"] = ["future_reward"]
	check(not manager.valid(damaged),"Não aceita recompensa em fase bloqueada")
	var full := valid.duplicate(true)
	full.story.events.clear()
	for i in 256: full.story.events.append("event_%d" % i)
	manager.sync_story(full)
	check(manager.valid(full) and full.story.events.size()==256,"Limite de narrativa não invalida save ao sincronizar")
	for raw in ["{broken",'{"save_version":3}',JSON.stringify(damaged)]:
		write_raw(E05_SLOT,raw)
		await open_campaign()
		check(campaign.store.locked and FileAccess.get_file_as_string(E05_SLOT)==raw,"Save inválido/futuro permanece intacto")
		await close_world()
	write_raw(E05_SLOT,JSON.stringify(valid))
	await open_campaign()
	campaign.new_adventure()
	await frames(15)
	level = campaign.level
	check(campaign.data.save_version==2 and campaign.data.collectibles.golden_nuts.is_empty() and campaign.data.story.events.is_empty(),"Nova aventura limpa conquistas e cria V2")
	check(not level.music_enabled and level.effects_enabled and campaign.progress_summary().characters==["Tico"],"Nova aventura preserva áudio e bloqueia Pipo")
	await close_world()
	manager.path = "user://e05_missing_directory/progress.json"
	check(not manager.write_save(valid) and manager.state=="unavailable","Falha de escrita é informada")
	DirAccess.remove_absolute(E05_SLOT)
	DirAccess.remove_absolute(E05_LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
