extends SceneTree
var failures: int = 0
var checks: int = 0
var level: Node2D
var tico: CharacterBody2D

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	checks += 1
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		push_error(message)

func frames(count: int) -> void:
	for i in count:
		await physics_frame
		await process_frame

func key(code: Key, down: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.pressed = down
	Input.parse_input_event(event)

func place(point: Vector2, settle: int = 3) -> void:
	key(KEY_SPACE,false)
	key(KEY_D,false)
	tico.reset_at(point)
	await frames(settle)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	level = load("res://scenes/levels/tico_minigame.tscn").instantiate()
	root.add_child(level)
	tico = level.get_node("Tico")
	await frames(40)
	check(tico.health == 3 and level.nuts == 0,"Início com três corações e zero nozes")
	var items = get_nodes_in_group("collectables")
	var nut = items[0]
	await place(nut.position + Vector2(0,28),5)
	check(nut.taken and not nut.visible and level.nuts == 1,"Noz desaparece e incrementa contador ao tocar")
	nut._collect(tico)
	check(level.nuts == 1,"Coleta não duplica no mesmo item")
	check(level.sounds.get_child_count() == 4 and level.sounds.get_child(0).stream is AudioStreamWAV,"Coleta produz áudio PCM")
	var heal = level.actors.get_node("Recovery")
	await place(heal.position + Vector2(0,28),5)
	check(not heal.taken,"Recuperação permanece disponível com vida cheia")
	await place(Vector2(160,760),5)
	check(tico.take_damage(Vector2(180,760)),"Dano retira um coração")
	check(tico.health == 2 and tico.velocity.x < 0,"Dano aplica reação ao impacto")
	check(not tico.take_damage(Vector2(180,760)) and tico.health == 2,"Invulnerabilidade impede dano consecutivo")
	await place(heal.position + Vector2(0,28),5)
	check(heal.taken and tico.health == 3,"Item recupera coração e desaparece")
	check(not tico.recover() and tico.health == 3,"Recuperação respeita limite de corações")
	await frames(100)
	check(tico.invulnerability_left == 0,"Proteção temporária termina")
	level.restart()
	await frames(5)
	var slug = get_nodes_in_group("enemies")[0]
	var first_x: float = slug.position.x
	await frames(40)
	check(slug.position.x < first_x,"Lesma patrulha")
	slug.position.x = slug.origin.x - slug.patrol_distance - 1
	slug.direction = -1
	await frames(2)
	check(slug.direction == 1,"Lesma vira no limite da patrulha")
	await place(slug.position + Vector2(5,0),4)
	check(tico.health == 2 and not slug.defeated,"Contato lateral causa dano sem derrotar lesma")
	await frames(10)
	check(tico.health == 2,"Contato não consome vários corações de uma vez")
	await place(slug.position + Vector2(0,-80),0)
	tico.velocity.y = 140
	for i in 30:
		await frames(1)
		if slug.defeated:
			break
	check(slug.defeated,"Queda sobre lesma causa pisão")
	check(tico.velocity.y < 0,"Pisão dá pequeno impulso para cima")
	await frames(75)
	check(slug.modulate.a == 0,"Lesma derrotada desaparece com transição amigável")
	level.restart()
	await frames(5)
	for block_name in ["CommonBlock","BreakableBlock","NutBlock"]:
		var block = level.actors.get_node(block_name)
		await place(Vector2(block.position.x,760),5)
		key(KEY_SPACE,true)
		await frames(25)
		key(KEY_SPACE,false)
		if block.kind == 0:
			check(not block.used and block.visible,"Bloco comum permanece sólido após cabeçada")
		elif block.kind == 1:
			check(block.used and not block.visible and block.get_node("Collision").disabled,"Cabeçada quebra bloco e remove colisão")
		else:
			check(block.used and block.visible and level.nuts == 1,"Bloco de noz concede uma noz e permanece sólido")
			block.hit_from_below()
			check(level.nuts == 1,"Bloco de noz não fornece recompensa repetida")
	await place(level.checkpoint.position,5)
	check(level.checkpoint_active and level.checkpoint.activated,"Contato ativa checkpoint")
	check(level.checkpoint_position.distance_to(level.checkpoint.position) < 10,"Checkpoint define retorno seguro")
	await place(Vector2(2250,760),4)
	for i in 3:
		tico.invulnerability_left = 0
		tico.take_damage(Vector2(2280,760))
	check(level.respawning and not tico.controls_enabled,"Zero corações inicia derrota e bloqueia controles")
	level.set_paused(true)
	await frames(90)
	check(level.respawning,"Pausa suspende transição de derrota")
	level.set_paused(false)
	await frames(80)
	check(not level.respawning and tico.health == 3,"Retorno restaura três corações")
	check(absf(tico.position.x - level.checkpoint.position.x) < 5,"Retorno ocorre no checkpoint")
	check(level.nuts == 1 and level.actors.get_node("NutBlock").used,"Derrota preserva nozes e blocos utilizados")
	check(not slug.defeated and tico.invulnerability_left > 0,"Retorno restaura inimigos e concede proteção")
	await place(level.exit_marker.position,4)
	check(level.completed and not tico.controls_enabled,"Chegada conclui fase e bloqueia movimento")
	var finish_x: float = tico.position.x
	key(KEY_D,true)
	await frames(65)
	check(tico.position.x == finish_x and level.result_panel.visible,"Comemoração mostra resultado sem movimento")
	check(level.result_text.text.contains("1 de 14"),"Resultado mostra contagem correta de nozes")
	level.restart()
	await frames(5)
	check(not level.completed and not level.checkpoint_active and level.nuts == 0,"Recomeçar limpa resultado, checkpoint e contador")
	check(not nut.taken and not heal.taken and not level.actors.get_node("NutBlock").used,"Recomeçar restaura itens e blocos")
	check(tico.controls_enabled and not level.result_panel.visible,"Recomeçar habilita controles e fecha resultado")
	# Percurso real usando apenas comandos, sem reposicionar o personagem.
	key(KEY_D,true)
	for i in 1800:
		if i % 90 == 0:
			key(KEY_SPACE,true)
		if i % 90 == 45:
			key(KEY_SPACE,false)
		await frames(1)
		if level.completed:
			break
	key(KEY_D,false)
	key(KEY_SPACE,false)
	check(level.completed,"Fase percorrida do início à chegada usando movimento e salto")
	check(level.nuts > 0,"Percurso real coleta nozes")
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	level.queue_free()
	await frames(2)
	# A thread de áudio usa tempo real mesmo quando a física é acelerada.
	OS.delay_msec(100)
	quit(1 if failures else 0)
