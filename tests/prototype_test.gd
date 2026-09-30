extends "res://tests/coop_test.gd"
const SAVE = preload("res://scripts/systems/save_manager.gd")
const SLOT := "user://stage6_test_only.json"

func walk_to(x: float, limit: int = 900) -> void:
	key(KEY_D,true)
	for i in limit:
		await frames(1)
		if level.tico.position.x >= x or level.completed:
			break
	key(KEY_D,false)

func open_level() -> void:
	level = load("res://scenes/levels/prototype_trail.tscn").instantiate()
	level.save_store.path = SLOT
	root.add_child(level)
	await frames(35)

func close_level() -> void:
	release()
	level.queue_free()
	await frames(3)
	OS.delay_msec(100)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(SLOT)
	await open_level()
	check(level.total_nuts == 13,"Fase reúne 13 nozes, incluindo bloco e segredo")
	check(not level.resumed and level.save_store.state == "saved","Primeira partida cria save local")
	check(level.actors.has_node("FinalStep2"),"Desafio final tem três plataformas")
	# Travessia integral por comandos, sem teletransporte.
	await walk_to(320)
	key(KEY_SPACE,true)
	await walk_to(770)
	key(KEY_SPACE,false)
	await frames(90)
	check(level.switch_character(),"Percurso: chama Pipo após introdução")
	await walk_to(1120)
	await frames(20)
	check(level.gate_open,"Percurso: pedra abre passagem")
	check(level.switch_character(),"Percurso: chama Tico diante do túnel")
	key(KEY_SPACE,true)
	await walk_to(1280)
	key(KEY_SPACE,false)
	await walk_to(2020)
	await frames(20)
	check(not level.checkpoint_active,"Bandeira está depois da cooperação")
	check(level.switch_character(),"Percurso: chama Pipo para bloco pesado")
	await walk_to(2110)
	await frames(15)
	key(KEY_E,true)
	await frames(65)
	key(KEY_E,false)
	check(level.heavy.destroyed,"Percurso: investida abre bloco pesado")
	await walk_to(2900)
	await frames(20)
	check(level.secret.revealed and level.secret.taken,"Percurso: faro revela e coleta segredo")
	await walk_to(3070)
	await frames(40)
	check(level.checkpoint_active,"Percurso: ativa ponto de retorno antes do desafio final")
	var collected: int = level.nuts
	await close_level()
	await open_level()
	check(level.resumed and level.tico == level.pipo,"Reabrir recupera personagem ativo")
	check(absf(level.tico.position.x-3020)<1 and level.tico.health==3,"Reabrir retorna à bandeira com três corações")
	check(level.nuts == collected and level.secret.taken,"Reabrir preserva nozes e segredo sem duplicação")
	check(level.gate_open and level.heavy.destroyed,"Reabrir preserva puzzle e parede aberta")
	level.restart()
	check(paused and level.restart_dialog.visible,"Recomeçar pede confirmação e pausa")
	level.restart_dialog.hide()
	level.restart_dialog.canceled.emit()
	check(not paused and level.nuts==collected,"Cancelar mantém a aventura")
	check(level.switch_character(),"Percurso: Tico assume o desafio final")
	await walk_to(3200)
	for target in [3370,3510,3650]:
		key(KEY_SPACE,true)
		await walk_to(target,240)
		key(KEY_SPACE,false)
		await frames(65)
	check(level.completed and level.result_panel.visible,"Percurso: três saltos levam à chegada elevada")
	var final_nuts: int = level.nuts
	await close_level()
	await open_level()
	await frames(60)
	check(level.completed and level.result_panel.visible and level.nuts==final_nuts,"Conclusão persiste ao reabrir")
	level.new_adventure()
	await frames(30)
	check(level.nuts==0 and not level.completed and not level.gate_open,"Nova aventura limpa objetos, contador e conclusão")
	# Estados dos blocos são persistentes e a recompensa não se repete.
	for actor in level.actors.get_children():
		if actor.has_method("hit_from_below"):
			actor.hit_from_below()
	await frames(3)
	check(level.nuts==1,"Bloco de noz recompensa uma vez")
	await close_level()
	await open_level()
	for actor in level.actors.get_children():
		if actor.has_method("hit_from_below"):
			actor.hit_from_below()
	check(level.nuts==1,"Blocos usados não repetem prêmio após reabrir")
	await close_level()
	var manager = SAVE.new()
	manager.path = SLOT
	var data: Dictionary = manager.read_save()
	check(manager.valid(data),"Formato atual passa validação")
	for invalid in [null,[],{}, {"save_version":"x"}]:
		check(not manager.valid(invalid),"Formato inválido é rejeitado")
	data.save_version = 99
	var file := FileAccess.open(SLOT,FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	check(manager.read_save().is_empty() and manager.locked,"Versão futura bloqueia sobrescrita")
	check(not manager.write_save(data),"Save incompatível permanece intacto")
	file = FileAccess.open(SLOT,FileAccess.WRITE)
	file.store_string("{interrompido")
	file.close()
	manager = SAVE.new()
	manager.path = SLOT
	check(manager.read_save().is_empty() and manager.state=="damaged","Arquivo danificado não derruba o jogo")
	manager = SAVE.new()
	manager.path = "user://missing-stage6-directory/progress.json"
	data.save_version = 1
	check(not manager.write_save(data) and manager.state=="unavailable","Falha de gravação é informada")
	DirAccess.remove_absolute(SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
