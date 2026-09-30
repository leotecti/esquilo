extends "res://tests/prototype_test.gd"
const WORLD_SLOT := "user://stage8_test_only.json"
var campaign: Node

func open_world() -> void:
	campaign = load("res://scenes/world_1_campaign.tscn").instantiate()
	campaign.store.path = WORLD_SLOT
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func close_world() -> void:
	release()
	campaign.queue_free()
	await frames(4)
	OS.delay_msec(100)

func traverse() -> void:
	key(KEY_D,true)
	var held := 0
	for i in 2200:
		if level.completed: break
		if held>0:
			held -= 1
			if held==0: key(KEY_SPACE,false)
		elif level.tico.is_on_floor():
			key(KEY_SPACE,true)
			held = 27
		await frames(1)
	release()
	await frames(60)

func advance() -> void:
	level.next_button.pressed.emit()
	await frames(35)
	level = campaign.level

func left_to(x: float) -> void:
	key(KEY_A,true)
	for i in 500:
		await frames(1)
		if level.tico.position.x<=x: break
	key(KEY_A,false)
	await frames(20)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(WORLD_SLOT)
	await open_world()
	check(level.world_stage==0 and not level.rescued,"Mundo começa em 1-1 com Tico sozinho")
	check(not level.switch_character() and not level.switch_button.visible,"Troca bloqueada antes do resgate")
	check(campaign.store.valid(campaign.data) and campaign.store.state=="saved","Save próprio válido criado")
	campaign.advance()
	await frames(2)
	check(level==campaign.level and level.world_stage==0,"Não avança uma fase incompleta")
	await traverse()
	check(level.completed and level.checkpoint_active,"1-1 completa por comandos: plataformas, lesmas, bandeira e chegada")
	check(campaign.data.unlocked==1,"Conclusão desbloqueia a fase 1-2")
	var count: int = level.nuts
	await close_world()
	await open_world()
	check(level.completed and level.nuts==count,"Reabrir mantém conclusão e nozes da fase 1-1")
	await advance()
	check(level.world_stage==1 and not level.completed and level.nuts==0,"Próxima fase abre 1-2 com contador próprio")
	check(level.actors.has_node("Hedgehog") and is_instance_valid(level.secret_block),"1-2 apresenta ouriço e caminho secreto")
	await place(Vector2(1770,760))
	key(KEY_SPACE,true)
	await frames(55)
	key(KEY_SPACE,false)
	await frames(60)
	check(level.secret_block.used and level.secret.revealed and level.secret.taken,"Cabeçada real revela e coleta segredo da fase 1-2")
	count = level.nuts
	await close_world()
	await open_world()
	check(level.world_stage==1 and level.secret.taken and level.nuts==count,"Segredo e recompensa persistem sem duplicação")
	# Retomada no início: travessia de 1-2 por comandos, sem reposicionar.
	await traverse()
	check(level.completed and level.checkpoint_active,"1-2 completa por comandos: blocos, espinhos e plataformas")
	await advance()
	check(level.world_stage==2 and not level.rescued,"1-3 começa com Pipo ainda preso")
	await walk_to(490)
	key(KEY_SPACE,true)
	await frames(35)
	key(KEY_SPACE,false)
	await frames(55)
	check(level.rescued and level.rescue_lock.used,"Salto sob bloco liberta Pipo")
	check(level.switch_button.visible and not level.captive.visible,"Resgate libera troca e remove Pipo da armadilha")
	await close_world()
	await open_world()
	check(level.rescued and level.rescue_gate.get_node("Collision").disabled,"Resgate persiste após reabrir")
	await walk_to(770)
	await frames(30)
	check(level.switch_character(),"Pipo assume o primeiro desafio de força")
	await walk_to(1120)
	await frames(20)
	check(level.gate_open,"1-3: Pipo empurra pedra e abre passagem")
	level.switch_character()
	key(KEY_SPACE,true)
	await walk_to(1280)
	key(KEY_SPACE,false)
	await walk_to(2020)
	await frames(25)
	level.switch_character()
	await walk_to(2110)
	await frames(15)
	key(KEY_E,true)
	await frames(65)
	key(KEY_E,false)
	check(level.heavy.destroyed,"1-3: investida rompe obstáculo pesado")
	# A nova lesma fica depois da parede; saltar mantém o trajeto seguro.
	key(KEY_SPACE,true)
	await walk_to(2730)
	key(KEY_SPACE,false)
	await walk_to(3070)
	await frames(40)
	check(level.checkpoint_active,"1-3: checkpoint posterior à cooperação")
	level.switch_character()
	await walk_to(3200)
	for target in [3370,3510,3650]:
		key(KEY_SPACE,true)
		await walk_to(target,240)
		key(KEY_SPACE,false)
		await frames(65)
	check(level.completed,"1-3 completa por comandos após resgate e cooperação")
	await advance()
	check(level.world_stage==3 and level.rescued,"Final da fase 1-3 abre encontro com Guardião")
	level._on_exit(level.exit_marker)
	check(not level.completed,"Chegada bloqueada antes de ajudar o Guardião")
	await walk_to(2520)
	await frames(30)
	level.switch_character()
	var boss: Node2D = level.guardian
	check(not boss.receive_hit(),"Guardião protegido fora da janela de abertura")
	for hit in 3:
		for i in 600:
			await frames(1)
			if boss.phase=="tired": break
		check(boss.phase=="tired","Ataque lento abre janela de vulnerabilidade %d" % hit)
		if hit==0:
			var timer: float = boss.remaining
			level.set_paused(true)
			await frames(30)
			check(boss.remaining==timer,"Pausa congela padrão do Guardião")
			level.set_paused(false)
		await walk_to(2650)
		await frames(10)
		key(KEY_E,true)
		await frames(55)
		key(KEY_E,false)
		check(boss.health==2-hit,"Investida real acerta Guardião %d" % hit)
		if hit<2:
			await left_to(2520)
			check(level.tico.health==3,"Acerto permite recuar sem dano de contato %d" % hit)
	check(boss.health==0 and boss.phase=="calm","Três acertos acalmam Guardião")
	await walk_to(3520)
	await frames(65)
	check(level.completed and campaign.data.finished,"Mundo 1 concluído e salvo")
	await close_world()
	await open_world()
	check(level.completed and campaign.data.finished and level.guardian.health==0,"Reabrir preserva conclusão do Mundo 1")
	var manager = preload("res://scripts/systems/world_save.gd").new()
	var invalid: Dictionary = campaign.data.duplicate(true)
	invalid.stage = 1.5
	check(not manager.valid(invalid),"Save rejeita índice fracionário")
	invalid = campaign.data.duplicate(true)
	invalid.levels["3"].boss_done = false
	check(not manager.valid(invalid),"Save rejeita final sem Guardião")
	level.restart()
	check(paused and level.restart_dialog.visible,"Recomeçar exige confirmação")
	level.restart_dialog.hide()
	level.restart_dialog.canceled.emit()
	check(not paused and campaign.data.finished,"Cancelar preserva progresso")
	level.new_adventure()
	await frames(40)
	level = campaign.level
	check(level.world_stage==0 and campaign.data.unlocked==0 and not campaign.data.finished,"Nova aventura confirmada reinicia o mundo")
	await close_world()
	DirAccess.remove_absolute(WORLD_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
