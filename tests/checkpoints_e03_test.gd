extends "res://tests/expedition_save_test.gd"
const E03_SLOT := "user://e03_test_only.json"
const E03_LEGACY := "user://e03_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = E03_SLOT
	campaign.legacy_path = E03_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func start_phase(index: int) -> void:
	write_raw(E03_SLOT,JSON.stringify(fixture(index)))
	await open_campaign()

func defeat() -> void:
	level.tico.health = 1
	level.tico.invulnerability_left = 0
	level.tico.take_damage(level.tico.position+Vector2(100,0))

func await_return() -> void:
	for i in 90:
		if not level.respawning: break
		await frames(1)

func restart_phase() -> void:
	campaign.restart_stage()
	await frames(12)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E03_LEGACY)
	await start_phase(0)
	Input.action_press("move_right")
	Input.action_press("jump")
	defeat()
	check(not Input.is_action_pressed("move_right") and not Input.is_action_pressed("jump"),"Derrota libera comandos mantidos")
	await await_return()
	check(level.tico.position.distance_to(level.get_node("PlayerSpawn").position)<8,"Sem bandeira retorna ao início")
	check(level.tico.health==3 and level.tico.invulnerability_left>0,"Retorno restaura saúde e proteção")
	await close_world()
	for index in 16:
		await start_phase(index)
		if index>=2 and index%2==0: level._activate(level.pipo,level.tico.position)
		var character: CharacterBody2D = level.tico
		character.health = 2
		character.reset_at(level.checkpoint.position+Vector2(0,-5))
		await frames(5)
		check(level.checkpoint_active and level.checkpoint.activated and character.health==3,"Bandeira ativa por colisão e recupera saúde: %d" % index)
		var state: Dictionary = level.world_snapshot()
		var enemy: Node2D
		for actor in level.actors.get_children():
			if actor.has_method("reset_enemy") and actor.get("defeated")!=null:
				enemy = actor
				enemy.defeated = true
				break
		if is_instance_valid(level.guardian):
			level.guardian.health = 1
			level.guardian.phase = "attack"
		if character==level.pipo: character._set_ability("charge",0.4)
		defeat()
		if index==4:
			level.set_paused(true)
			await frames(12)
			check(level.respawning and character.health==0,"Pausa suspende a transição de derrota")
			level.set_paused(false)
		await await_return()
		check(level.tico==character and character.position.distance_to(level.checkpoint_position)<8 and character.health==3,"Retorna com personagem e saúde corretos: %d" % index)
		check(character.invulnerability_left>0 and character.velocity.length()<50 and character.wind_acceleration==Vector2.ZERO,"Proteção, movimento e vento restaurados: %d" % index)
		check(level.world_snapshot()==state and campaign.data.survival.lives==2,"Derrota mantém o estado da fase e desconta uma vida: %d" % index)
		if is_instance_valid(enemy): check(not enemy.defeated,"Inimigo comum reaparece: %d" % index)
		if is_instance_valid(level.guardian): check(level.guardian.health==3 and level.guardian.phase=="waiting","Chefe ainda não vencido reinicia o encontro: %d" % index)
		if character==level.pipo: check(character.ability=="ready" and not character.pushing,"Pipo volta sem investida nem empurrão residual")
		if index>=4: check(level.safe_spot==level.checkpoint_position,"Margem segura acompanha a bandeira: %d" % index)
		check(campaign.store.read_save().levels[str(index)].checkpoint,"Bandeira persiste no save: %d" % index)
		await close_world()
	# Reinício manual e cancelamento: checkpoint, escolhas e vida extra são preservados conforme a regra.
	await start_phase(4)
	level._activate(level.pipo,level.checkpoint.position+Vector2(0,-5))
	await frames(6)
	campaign.claim_life(4)
	level.set_paused(true)
	level.request_phase_restart()
	check(level.phase_restart_dialog.visible,"Reinício manual pede confirmação")
	level.set_paused(false)
	check(paused,"Escape não retoma a fase atrás da confirmação")
	level.phase_restart_dialog.hide()
	level.phase_restart_dialog.canceled.emit()
	check(paused and level.checkpoint_active and campaign.data.survival.lives==4,"Cancelar mantém pausa, bandeira e vidas")
	level.request_phase_restart()
	level.phase_restart_dialog.confirmed.emit()
	await frames(12)
	level = campaign.level
	check(not paused and not level.checkpoint_active and not level.completed,"Confirmar reinicia somente a tentativa atual")
	check(level.tico==level.pipo and level.tico.health==3 and level.tico.position.x<200,"Reinício mantém Pipo e retorna ao início com saúde")
	check(campaign.data.stage==4 and campaign.data.unlocked==4 and campaign.data.survival.lives==4 and not campaign.claim_life(4),"Reinício não perde fases ou vidas nem duplica medalhão")
	await close_world()
	await open_campaign()
	check(not level.checkpoint_active and level.tico==level.pipo and level.tico.position.x<200,"Reabrir mantém o reinício salvo")
	await close_world()
	# Recompensas e áreas opcionais: segredo da caverna, coração, puzzle e chefes.
	await start_phase(9)
	level.secret.reveal()
	level.tico.reset_at(level.secret.position)
	await frames(6)
	check(level.secret.taken,"Coleta real do segredo da caverna")
	var rewards: Array = level.world_snapshot().items.duplicate()
	await restart_phase()
	check(level.secret.revealed and level.secret.taken and level.world_snapshot().items==rewards and level.mechanisms.Rocha.active,"Reinício preserva área opcional, recompensa e mecanismo")
	await close_world()
	await start_phase(7)
	var heart: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing: heart = actor
	level.tico.health = 2
	level.tico.reset_at(heart.position)
	await frames(6)
	check(heart.taken,"Coração coletado antes do retorno")
	defeat()
	await await_return()
	check(heart.taken,"Coração consumido não reaparece na derrota")
	level.guardian.health = 0
	level.guardian.phase = "calm"
	level._on_exit(level.exit_marker)
	await restart_phase()
	check(not level.completed and campaign.data.levels["7"].completed and campaign.data.unlocked==8,"Rejogar mantém conclusão permanente e próxima fase")
	check(level.guardian.health==0,"Chefe já vencido permanece calmo")
	var restored_heart: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing: restored_heart = actor
	check(restored_heart.taken,"Coração consumido não reaparece no reinício")
	check(campaign.store.valid(campaign.data),"Save de replay válido")
	await close_world()
	await open_campaign()
	check(not level.completed and level.guardian.health==0 and campaign.data.levels["7"].completed,"Reabrir mantém replay e chefe vencido")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	DirAccess.remove_absolute(E03_LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
