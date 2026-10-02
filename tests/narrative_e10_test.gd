extends "res://tests/checkpoints_e03_test.gd"
const E10_SLOT := "user://e10_test_only.json"
const E10_LEGACY := "user://e10_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = E10_SLOT
	campaign.legacy_path = E10_LEGACY
	root.add_child(campaign)
	await frames(12)
	level = campaign.level

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E10_SLOT)
	DirAccess.remove_absolute(E10_LEGACY)
	await open_campaign()
	var animation_calls: Array = []
	campaign.narrative.animation_requested.connect(func(actor: String, animation: String): animation_calls.append([actor,animation]))
	var sequence := [
		{"type":"scene","title":"Uma pista no bosque","color":"173d2fee"},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Há marcas no caminho!"},
		{"type":"animation","actor":"tico","animation":"look_up","duration":0.01},
		{"type":"event","id":"test_clue_found"},
		{"type":"transition","duration":0.02},
		{"type":"dialogue","speaker":"Narrador","text":"A aventura continua."}
	]
	check(campaign.play_narrative("test_sequence",sequence),"Campanha inicia sequência descrita por dados")
	check(campaign.narrative.active and paused,"Narrativa bloqueia gameplay e mantém interface ativa")
	check(campaign.narrative.speaker.text=="Tico" and campaign.narrative.dialogue.text=="Há marcas no caminho!","Cena apresenta personagem e diálogo")
	check(not level.get_node("Interface").visible,"HUD fica suspenso durante a cena")
	campaign.narrative._advance()
	await frames(8)
	check(animation_calls==[["tico","look_up"]],"Passo de animação emite sinal reutilizável")
	check("test_clue_found" in campaign.data.story.events,"Evento narrativo atualiza progresso")
	check(campaign.narrative.speaker.text=="Narrador","Transição avança para a próxima fala")
	campaign.narrative._advance()
	await frames(3)
	check(not campaign.narrative.active and not paused,"Fim devolve controle ao gameplay")
	check("test_sequence" in campaign.data.story.events and level.get_node("Interface").visible,"Conclusão fica registrada e restaura o HUD")
	check(not campaign.play_narrative("test_sequence",sequence),"Sequência concluída não repete por padrão")
	check(campaign.play_narrative("test_sequence",sequence,true),"Reprodução explícita continua disponível")
	campaign.narrative.skip_button.pressed.emit()
	check(not campaign.narrative.active and not paused,"Pular cena encerra com segurança")
	campaign.save_progress()
	await close_world()
	await open_campaign()
	check("test_sequence" in campaign.data.story.events and "test_clue_found" in campaign.data.story.events,"Eventos narrativos persistem ao reabrir")
	check(campaign.store.valid(campaign.data),"Save com eventos da E10 permanece válido")
	await close_world()
	DirAccess.remove_absolute(E10_SLOT)
	DirAccess.remove_absolute(E10_LEGACY)
	print("RESULTADO E10: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
