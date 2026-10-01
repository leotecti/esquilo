extends "res://tests/expedition_save_test.gd"
const TUTORIAL_SLOT := "user://e04_test_only.json"
const TUTORIAL_LEGACY := "user://e04_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.store.path = TUTORIAL_SLOT
	campaign.legacy_path = TUTORIAL_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func start(index: int) -> void:
	write_raw(TUTORIAL_SLOT,JSON.stringify(fixture(index)))
	await open_campaign()

func scan_at(point: Vector2) -> void:
	level.contextual_help.clear()
	level.contextual_help.cooldown = 0
	level.contextual_help.scan_left = 0
	level.tico.reset_at(point)
	await frames(2)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(TUTORIAL_LEGACY)
	await start(0)
	check(campaign.data.tutorials.size()==5 and campaign.store.valid(campaign.data),"Save anterior recebe cinco registros válidos de tutorial")
	check(not level.status.visible and not level.get_node("Interface/HUD/TopBar/Title").visible,"HUD remove texto de estado e título permanente")
	check(level.contextual_help.details().hud_controls_clear,"Controles não sobrepõem corações e contadores")
	var hidden := true
	for sign in level.contextual_help.signs: hidden = hidden and not sign.visible
	check(hidden and level.contextual_help.signs.size()>0,"Placas existentes viram contextos sem texto permanente")
	check(level.contextual_help.active_id=="walk" and not paused,"Primeira dica ensina controles sem pausar")
	await scan_at(Vector2(300,760))
	check(level.contextual_help.active_id=="tutorial_life_seen","Medalhão próximo mostra dica de vida")
	check(campaign.store.read_save().tutorials.tutorial_life_seen,"Visualização salva imediatamente")
	level.set_paused(true)
	var time_left: float = level.contextual_help.remaining
	await frames(12)
	check(not level.contextual_help.panel.visible and level.contextual_help.remaining==time_left,"Pausa esconde dica e suspende seu tempo")
	level.set_paused(false)
	level.tico.reset_at(Vector2(450,675))
	await frames(6)
	check(level.contextual_help.active_id!="tutorial_life_seen","Coleta encerra dica de vida")
	await close_world()
	await open_campaign()
	check(campaign.data.tutorials.tutorial_life_seen,"Reabertura preserva tutorial visualizado")
	await scan_at(Vector2(300,760))
	check(level.contextual_help.active_id!="tutorial_life_seen","Dica vista não se repete ao reabrir")
	await scan_at(Vector2(1700,755))
	check(level.contextual_help.active_id=="tutorial_enemy_seen","Primeiro inimigo mostra dica de salto")
	var enemy: Node2D = level.contextual_help.active_target
	enemy.defeated = true
	await frames(2)
	check(level.contextual_help.active_id.is_empty(),"Derrotar inimigo encerra dica")
	await scan_at(Vector2(1320,400))
	await frames(24)
	check(campaign.data.tutorials.tutorial_glide_seen,"Queda com espaço para planar mostra dica de habilidade")
	key(KEY_SPACE,true)
	await frames(3)
	check(level.contextual_help.active_id!="tutorial_glide_seen","Planar encerra dica de habilidade")
	key(KEY_SPACE,false)
	await close_world()
	await start(7)
	var heart: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing: heart = actor
	await scan_at(heart.position+Vector2(-90,45))
	check(not campaign.data.tutorials.tutorial_heart_seen,"Saúde cheia não exige tutorial de recuperação")
	level.tico.health = 2
	await scan_at(heart.position+Vector2(-90,45))
	check(level.contextual_help.active_id=="tutorial_heart_seen","Coração próximo ensina recuperação quando necessária")
	level.tico.reset_at(heart.position)
	await frames(5)
	check(heart.taken and level.contextual_help.active_id!="tutorial_heart_seen","Curar encerra dica de coração")
	await close_world()
	await start(9)
	await scan_at(level.secret.position+Vector2(-200,0))
	check(level.contextual_help.active_id=="tutorial_secret_seen","Segredo próximo convida a chamar Pipo desbloqueado")
	level.secret.reveal()
	await frames(2)
	check(level.contextual_help.active_id.is_empty(),"Revelar segredo encerra dica")
	campaign.restart_stage()
	await frames(35)
	level = campaign.level
	check(campaign.data.tutorials.tutorial_secret_seen,"Reiniciar fase preserva dicas vistas")
	level.contextual_help.notify("Teste de mensagem temporária")
	await frames(225)
	check(level.contextual_help.active_kind!="notice","Mensagens temporárias expiram")
	campaign.data.survival.lives = 1
	level.tico.health = 1
	level.tico.invulnerability_left = 0
	level.tico.take_damage(level.tico.position)
	await frames(70)
	check(campaign.awaiting_return() and campaign.store.read_save().tutorials.tutorial_secret_seen,"Game Over preserva dicas vistas no save")
	campaign.new_adventure()
	await frames(35)
	level = campaign.level
	check(not true in campaign.data.tutorials.values(),"Nova aventura reinicia os cinco tutoriais")
	await close_world()
	var invalid := fixture(0)
	invalid.tutorials = {"tutorial_enemy_seen":"sim"}
	check(not CAMPAIGN_SAVE.new().valid(invalid),"Save rejeita flag de tutorial inválida")
	invalid.tutorials = {}
	invalid.context_hints_seen = ["walk","walk"]
	check(not CAMPAIGN_SAVE.new().valid(invalid),"Save rejeita contextos duplicados")
	DirAccess.remove_absolute(TUTORIAL_SLOT)
	DirAccess.remove_absolute(TUTORIAL_LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
