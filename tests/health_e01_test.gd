extends "res://tests/expedition_test.gd"
var deaths := 0
var health_events := 0

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"guardian")
	await place(level.checkpoint.position)
	await place(Vector2(1990,760))
	var heart: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing: heart = actor
	check(is_instance_valid(heart) and not heart.taken,"Coração aguarda quando a saúde está cheia")
	var player: CharacterBody2D = level.tico
	player.health_changed.connect(func(_value): health_events += 1)
	player.defeated.connect(func(): deaths += 1)
	player.take_damage(player.position)
	player.velocity = Vector2.ZERO
	await frames(4)
	check(heart.taken and player.health==3,"Dano dentro do coração permite recuperação sem sair da área")
	check(level.hearts.health==3,"HUD acompanha a recuperação")
	var count := health_events
	await frames(10)
	check(health_events==count,"Coração coletado não recupera nem emite evento novamente")
	player.invulnerability_left = 0
	player.take_damage(player.position)
	count = health_events
	check(not player.recover(0) and not player.recover(-2) and player.health==2,"Recuperação nula ou negativa não altera saúde")
	check(health_events==count,"Recuperação rejeitada não emite mudança de saúde")
	check(not player.take_damage(player.position) and player.health==2,"Invulnerabilidade bloqueia dano repetido")
	player.controls_enabled = false
	check(not player.recover() and player.health==2,"Personagem inativo não recebe recuperação")
	player.controls_enabled = true
	check(player.recover(20) and player.health==3,"Recuperação positiva respeita saúde máxima")
	for i in 3:
		player.invulnerability_left = 0
		player.take_damage(player.position)
	check(player.health==0 and deaths==1 and level.respawning,"Zero corações dispara uma única derrota")
	check(not player.take_damage(player.position) and not player.recover() and deaths==1,"Derrota rejeita dano e cura adicionais")
	check(not level.switch_character(),"Troca bloqueada durante derrota")
	level.set_paused(true)
	await frames(80)
	check(level.respawning and player.health==0,"Pausa preserva a transição de derrota")
	level.set_paused(false)
	await frames(80)
	check(not level.respawning and player.health==3 and player.controls_enabled,"Retorno restaura saúde e controle")
	check(player.position.distance_to(level.checkpoint.position)<10 and player.invulnerability_left>0,"Retorno mantém checkpoint e proteção")
	check(heart.taken,"Retorno não duplica coração consumido")
	check(level.switch_character(),"Pipo disponível após retorno")
	await frames(20)
	player = level.tico
	player.invulnerability_left = 0
	key(KEY_E,true)
	await frames(16)
	key(KEY_E,false)
	check(player.ability=="charge","Pipo iniciou investida")
	player.take_damage(player.position)
	check(player.health==2 and player.ability=="ready","Dano cancela investida de Pipo e retira um coração")
	await frames(30)
	check(level.switch_character() and level.tico.health==2,"Troca preserva saúde compartilhada")
	await close_level()
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
