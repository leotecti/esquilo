extends "res://tests/expedition_test.gd"
const CAMPAIGN_SLOT := "user://stage9_test_only.json"
const LEGACY := "user://stage9_legacy_test_only.json"
const CAMPAIGN_SAVE = preload("res://scripts/systems/expedition_save.gd")

func state_for(index: int, done := true) -> Dictionary:
	var state := {"character":"Tico","checkpoint":false,"completed":done,"rescued":index>=2,"items":[],"blocks":[],"stone":1110 if index==2 else 850,"gate":index==2,"heavy":index==2,"secret":false,"boss_done":done and index%4==3}
	if index>=4:
		state.mechanisms = {}
		for id in CAMPAIGN_SAVE.DEVICES[index]: state.mechanisms[id] = true
	return state

func fixture(index: int) -> Dictionary:
	var data := {"save_version":1,"stage":index,"unlocked":index,"finished":false,"settings":{"music":false,"effects":true},"levels":{}}
	for i in index+1: data.levels[str(i)] = state_for(i,i<index)
	return data

func write_raw(path: String, raw: String) -> void:
	var file := FileAccess.open(path,FileAccess.WRITE)
	file.store_string(raw)
	file.close()

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = CAMPAIGN_SLOT
	campaign.legacy_path = LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(CAMPAIGN_SLOT)
	var legacy := fixture(3)
	legacy.levels["3"] = state_for(3)
	legacy.finished = true
	var original := JSON.stringify(legacy)
	write_raw(LEGACY,original)
	await open_campaign()
	check(campaign.data.unlocked==4 and not campaign.data.finished and level.completed,"Importa Bosque concluído e libera Rio")
	check(not level.music_enabled and level.effects_enabled,"Migração mantém preferências de áudio")
	check(FileAccess.get_file_as_string(LEGACY)==original,"CAMPAIGN_SAVE antigo permanece intacto")
	await advance()
	check(campaign.data.stage==4 and level.biome==2 and not level.completed,"Resultado do Bosque avança para Rio")
	var river_life: Node2D = level.actors.get_node("LifeCache")
	check(river_life.position.y==625 and 760.0-(river_life.position.y+29.0)>level.pipo.get_node("Collision").shape.size.y,"Bloco de vida deixa Pipo passar por baixo na fase 2-1")
	check(campaign.store.valid(campaign.data),"Campanha migrada atende às regras novas")
	await close_world()
	await open_campaign()
	check(campaign.data.stage==4,"Campanha atual prevalece sobre CAMPAIGN_SAVE antigo")
	await close_world()
	DirAccess.remove_absolute(CAMPAIGN_SLOT)
	write_raw(LEGACY,JSON.stringify(fixture(2)))
	await open_campaign()
	check(campaign.data.stage==2 and campaign.data.unlocked==2,"Migra Bosque em andamento sem desbloquear fases")
	await close_world()
	for index in range(4,16):
		var data := fixture(index)
		data.levels[str(index)].checkpoint = true
		write_raw(CAMPAIGN_SLOT,JSON.stringify(data))
		await open_campaign()
		check(campaign.store.state=="saved" and level.checkpoint_active and level.tico.position.distance_to(level.checkpoint.position)<10,"Checkpoint restaurado na cena %d" % index)
		var all_active := true
		for device in level.mechanisms.values(): all_active = all_active and device.active
		for platform in level.movers: all_active = all_active and platform.enabled
		check(all_active,"Mecanismos e elevadores restaurados na cena %d" % index)
		if index==13: check(level.water.is_empty(),"Reabertura mantém comporta drenada")
		if index==9:
			level.secret.revealed = true
			level.secret.taken = true
			level.secret.hide()
			level.nuts += 1
			var expected_nuts: int = level.nuts
			campaign.save_progress()
			await close_world()
			await open_campaign()
			check(level.secret.revealed and level.secret.taken and level.nuts==expected_nuts,"Segredo da caverna persiste sem duplicar recompensa")
		if is_instance_valid(level.guardian):
			level.guardian.health = 0
			level.guardian.phase = "calm"
		level._on_exit(level.exit_marker)
		check(level.completed and campaign.store.valid(campaign.data),"Conclusão válida na cena %d" % index)
		await close_world()
		await open_campaign()
		check(level.completed and campaign.data.finished==(index==15),"Reabertura preserva resultado e final somente no Rei Castor: %d" % index)
		if index<15:
			await advance()
			check(campaign.data.stage==index+1 and not level.completed,"Transição para cena %d" % (index+1))
		await close_world()
	var manager = CAMPAIGN_SAVE.new()
	var old_river_save := fixture(4)
	old_river_save.save_version = 2
	old_river_save.levels["4"].mechanisms.TroncoRio = true
	old_river_save.survival = {"lives":3,"nut_total":0,"food_total":0,"pending_return":false,"return_stage":0,"replay":false,"pipo_unlocked":true,"claimed":[]}
	old_river_save.tutorials = {}
	old_river_save.context_hints_seen = []
	old_river_save.collectibles = {"golden_nuts":{}}
	old_river_save.story = {"events":[],"village":{}}
	var migrated_river := manager.migrate(old_river_save)
	check(not migrated_river.levels["4"].mechanisms.has("RochaAlavanca") and not migrated_river.levels["4"].mechanisms.has("TroncoRio"),"Save anterior remove mecanismos descontinuados da fase 2-1")
	var invalid := fixture(14)
	invalid.levels["14"].checkpoint = true
	invalid.levels["14"].mechanisms.Roda = false
	check(not manager.valid(invalid),"Rejeita checkpoint além de mecanismo fechado")
	invalid = fixture(15)
	invalid.finished = true
	check(not manager.valid(invalid),"Rejeita campanha finalizada sem vitória")
	for raw in ["{broken",'{"save_version":999}']:
		write_raw(CAMPAIGN_SLOT,raw)
		await open_campaign()
		check(campaign.store.locked and FileAccess.get_file_as_string(CAMPAIGN_SLOT)==raw,"Save danificado/futuro não é sobrescrito")
		await close_world()
	await open_campaign()
	level.music_enabled = false
	campaign.data.settings.music = false
	level.new_adventure()
	await frames(40)
	level = campaign.level
	check(campaign.data.stage==0 and campaign.data.unlocked==0 and not level.music_enabled and campaign.store.state=="saved","Nova aventura reinicia campanha e preserva áudio")
	await close_world()
	DirAccess.remove_absolute(CAMPAIGN_SLOT)
	DirAccess.remove_absolute(LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
