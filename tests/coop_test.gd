extends SceneTree
var level: Node2D
var failures: int = 0
var checks: int = 0

func _initialize() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	checks += 1
	if value:
		print("PASS: ",message)
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

func release() -> void:
	for code in [KEY_D,KEY_A,KEY_SPACE,KEY_E,KEY_Q]:
		key(code,false)

func place(point: Vector2, wait_frames: int = 20) -> void:
	release()
	level.tico.reset_at(point)
	await frames(wait_frames)

func jump_height() -> float:
	var floor_y: float = level.tico.position.y
	var top: float = floor_y
	key(KEY_SPACE,true)
	for i in 60:
		await frames(1)
		top = minf(top,level.tico.position.y)
	key(KEY_SPACE,false)
	return floor_y - top

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	level = load("res://scenes/levels/coop_trail.tscn").instantiate()
	root.add_child(level)
	await frames(35)
	check(level.tico == level.squirrel and not level.pipo.visible,"Tico inicia ativo e Pipo fica inativo")
	check(level.total_nuts == 9,"Contagem inclui oito nozes e um segredo")
	var tico_jump := await jump_height()
	await frames(50)
	key(KEY_Q,true)
	await frames(3)
	key(KEY_Q,false)
	check(level.tico == level.pipo,"Q troca para Pipo")
	check(level.camera.target == level.pipo,"Câmera acompanha personagem ativo")
	check(level.get_node("Interface/HUD/TopBar/Title").text.contains("Pipo"),"HUD identifica Pipo")
	check(level.squirrel.collision_layer == 0 and not level.squirrel.is_physics_processing(),"Inativo não colide nem processa física")
	check(level.pipo.move_speed < level.squirrel.move_speed,"Pipo corre mais devagar que Tico")
	var pipo_jump := await jump_height()
	check(pipo_jump < tico_jump and pipo_jump > 80,"Pipo tem salto menor, suficiente para superar a pedra")
	await place(Vector2(160,550),0)
	key(KEY_SPACE,true)
	await frames(20)
	check(level.pipo.state != &"glide" and level.pipo.velocity.y > 100,"Pipo não plana ao segurar pulo")
	check(not level.switch_character(),"Troca bloqueada durante salto/queda")
	await place(Vector2(160,760))
	level.tico.take_damage(Vector2(190,760))
	await frames(25)
	check(level.switch_character(),"Troca aceita após pousar")
	check(level.tico.health == 2 and level.tico.invulnerability_left > 0,"Troca preserva corações e proteção, sem cura gratuita")
	level.set_paused(true)
	check(not level.switch_character(),"Troca bloqueada na pausa")
	level.set_paused(false)
	level.restart()
	await frames(20)
	await place(Vector2(780,760))
	key(KEY_D,true)
	await frames(60)
	key(KEY_D,false)
	check(absf(level.stone.position.x-850) < 1,"Tico não empurra pedra")
	check(level.switch_character(),"Troca junto à pedra ajusta a largura de Pipo com segurança")
	await frames(20)
	level.switch_character()
	await frames(20)
	await place(Vector2(760,760))
	check(level.switch_character(),"Troca para Pipo antes da pedra")
	key(KEY_D,true)
	await frames(235)
	key(KEY_D,false)
	check(level.stone.position.x > 1110,"Pipo empurra pedra até a marca")
	check(level.gate_open and level.gate.get_node("Collision").disabled,"Pedra abre o caminho da passagem baixa")
	check(level.stone.position.x <= 1190.1,"Pedra respeita o limite do encaixe")
	await place(Vector2(1300,760))
	key(KEY_D,true)
	await frames(40)
	key(KEY_D,false)
	check(level.pipo.position.x < 1328,"Corpo maior de Pipo não cabe na passagem")
	check(level.switch_character(),"Troca para Tico diante da passagem")
	key(KEY_D,true)
	await frames(45)
	key(KEY_D,false)
	await frames(20)
	check(level.tico.position.x > 1450 and level.tico.position.x < 1750,"Tico atravessa passagem estreita")
	check(not level.switch_character() and level.tico == level.squirrel,"Troca recusa Pipo sem espaço no túnel")
	key(KEY_D,true)
	await frames(80)
	key(KEY_D,false)
	check(level.checkpoint_active,"Saída da passagem alcança checkpoint")
	await place(Vector2(2160,760))
	key(KEY_D,true)
	await frames(25)
	key(KEY_D,false)
	check(not level.heavy.destroyed and level.tico.position.x < 2182,"Tico não quebra nem atravessa bloco pesado")
	check(not level.heavy.receive_charge(level.squirrel),"Bloco pesado rejeita Tico")
	await place(Vector2(2090,760))
	check(level.switch_character(),"Pipo pode ser chamado depois do túnel")
	check(not level.heavy.receive_charge(level.pipo),"Pipo parado não quebra bloco pesado")
	level.pipo.facing = 1
	key(KEY_E,true)
	await frames(2)
	key(KEY_E,false)
	check(level.pipo.ability == "prepare","AÇÃO inicia preparação visível")
	check(not level.switch_character(),"Troca bloqueada durante investida")
	var remaining: float = level.pipo.ability_left
	level.set_paused(true)
	await frames(30)
	check(level.pipo.ability_left == remaining,"Pausa congela preparação da investida")
	level.set_paused(false)
	await frames(15)
	check(level.pipo.ability == "charge","Preparação avança para investida")
	await frames(15)
	check(level.heavy.destroyed and level.pipo.ability == "recover","Impacto quebra bloco pesado e inicia recuperação")
	await frames(25)
	check(level.pipo.ability == "ready","Recuperação libera movimento")
	# Faro exige Pipo; Tico não revela o segredo por proximidade.
	await place(Vector2(2660,760))
	check(level.switch_character(),"Troca para Tico antes do segredo")
	await place(Vector2(2850,760))
	check(not level.secret.revealed,"Tico não revela segredo oculto")
	await place(Vector2(2660,760))
	check(level.switch_character(),"Troca para Pipo perto do segredo")
	await frames(3)
	check(level.pipo.sniffing and level.secret.scent_visible,"Faro produz pista de direção a distância")
	await place(Vector2(2820,760))
	check(level.secret.revealed,"Aproximar Pipo revela noz escondida")
	var nuts_before: int = level.nuts
	await place(Vector2(2880,760))
	check(level.secret.taken and level.nuts == nuts_before+1,"Segredo revelado pode ser coletado")
	await frames(20)
	check(level.nuts == nuts_before+1,"Segredo não duplica recompensa")
	for i in 3:
		level.tico.invulnerability_left = 0
		level.tico.take_damage(level.tico.position + Vector2(20,0))
	check(level.respawning and not level.switch_character(),"Derrota bloqueia troca")
	await frames(80)
	check(level.tico == level.pipo and absf(level.tico.position.x-1850)<2 and level.tico.health==3,"Pipo retorna ao checkpoint com vida restaurada")
	check(level.gate_open and level.heavy.destroyed and level.secret.taken,"Retorno preserva progresso do puzzle e segredo")
	await place(Vector2(3550,760))
	check(level.completed and not level.switch_character(),"Chegada com Pipo conclui e bloqueia troca")
	await frames(55)
	check(level.result_text.text.contains("Tico e Pipo"),"Resultado comemora a dupla")
	level.restart()
	await frames(20)
	check(level.tico==level.squirrel and not level.pipo.visible,"Recomeçar seleciona Tico")
	check(not level.gate_open and not level.heavy.destroyed and not level.secret.revealed,"Recomeçar restaura puzzle e segredo")
	check(level.nuts==0 and absf(level.stone.position.x-850)<1,"Recomeçar limpa contador e posição da pedra")
	check(not level.completed and not level.respawning,"Recomeçar limpa estado de conclusão e derrota")
	# Travessia sem teletransporte a partir daqui.
	key(KEY_D,true)
	await frames(35)
	key(KEY_SPACE,true)
	await frames(80)
	key(KEY_SPACE,false)
	await frames(10)
	key(KEY_D,false)
	await frames(20)
	level.switch_character()
	key(KEY_D,true)
	await frames(290)
	key(KEY_D,false)
	await frames(20)
	check(level.gate_open,"Percurso: Pipo abre a passagem empurrando")
	level.switch_character()
	key(KEY_D,true)
	key(KEY_SPACE,true)
	await frames(95)
	key(KEY_SPACE,false)
	await frames(160)
	key(KEY_D,false)
	await frames(20)
	check(level.checkpoint_active,"Percurso: Tico supera pedra e túnel até bandeira")
	level.switch_character()
	key(KEY_D,true)
	await frames(15)
	key(KEY_D,false)
	await frames(15)
	key(KEY_E,true)
	await frames(60)
	key(KEY_E,false)
	check(level.heavy.destroyed,"Percurso: investida de Pipo abre parede")
	key(KEY_D,true)
	for i in 500:
		if i % 90 == 0:
			key(KEY_SPACE,true)
		if i % 90 == 45:
			key(KEY_SPACE,false)
		await frames(1)
		if level.completed:
			break
	release()
	check(level.completed,"Percurso completo com os dois personagens apenas por comandos")
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	level.queue_free()
	await frames(2)
	OS.delay_msec(100)
	quit(1 if failures else 0)
