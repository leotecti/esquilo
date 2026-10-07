extends "res://tests/map_e06_test.gd"
const TEST_MODE_SLOT := "user://test_mode_map_only.json"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(TEST_MODE_SLOT)
	var original := fixture(0)
	write_raw(TEST_MODE_SLOT,JSON.stringify(original))
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.store.path = TEST_MODE_SLOT
	campaign.legacy_path = "user://test_mode_legacy_unused.json"
	root.add_child(campaign)
	await frames(12)
	level = campaign.level
	check(campaign.map_is_open() and not campaign.test_mode,"Mapa inicia com progressão normal")
	check(campaign.world_map.test_button.text.contains("Liberar"),"Mapa apresenta botão temporário de teste")
	var saved_before: Dictionary = campaign.store.read_save().duplicate(true)

	campaign.world_map.test_button.pressed.emit()
	check(campaign.test_mode and campaign.data.unlocked==15,"Botão disponibiliza as dezesseis fases apenas na sessão")
	check(campaign.data.survival.pipo_unlocked and campaign.world_map.notice.visible,"Modo libera Pipo e exibe aviso permanente")
	for index in 16:
		check(campaign.world_map.summary.levels[str(index)].available,"Modo de teste libera a fase %d" % index)
	campaign.world_map.focus_stage(13)
	campaign.enter_from_map(13)
	await frames(18)
	level = campaign.level
	check(campaign.data.stage==13 and level.biome==4 and level.section==1,"Seleção abre diretamente a fase 4-2")
	campaign.data.survival.lives = 9
	campaign.data.levels["13"] = level.world_snapshot()
	campaign.save_progress()
	check(campaign.store.read_save()==saved_before,"Alterações do teste não alcançam o arquivo de save")

	campaign.show_map()
	check(campaign.map_is_open() and campaign.world_map.test_button.text.contains("Encerrar"),"Mapa permite encerrar o modo de teste")
	campaign.world_map.test_button.pressed.emit()
	await frames(18)
	level = campaign.level
	check(not campaign.test_mode and campaign.map_is_open(),"Encerramento retorna ao mapa normal")
	check(campaign.data.stage==saved_before.stage and campaign.data.unlocked==saved_before.unlocked,"Fase e desbloqueios reais são restaurados")
	check(campaign.data.survival.lives==saved_before.survival.lives and not campaign.data.levels.has("13"),"Vidas e resultados de teste são descartados")
	check(campaign.store.read_save()==saved_before,"Save permanece idêntico após encerrar o modo")
	var shortcut := InputEventKey.new()
	shortcut.keycode = KEY_F10
	shortcut.ctrl_pressed = true
	shortcut.pressed = true
	root.push_input(shortcut)
	await frames(2)
	check(campaign.test_mode,"Ctrl + F10 ativa o modo pelo teclado")
	root.push_input(shortcut)
	await frames(18)
	check(not campaign.test_mode and campaign.map_is_open(),"Ctrl + F10 também restaura a campanha real")

	await close_world()
	DirAccess.remove_absolute(TEST_MODE_SLOT)
	print("RESULTADO MODO DE TESTE: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
