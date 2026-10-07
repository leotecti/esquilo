extends "res://tests/coop_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	level = load("res://scenes/levels/world_1_guardian.tscn").instantiate()
	root.add_child(level)
	await frames(35)
	check(level._test_details().stage==8,"Diagnóstico do navegador identifica etapa 8")
	await place(level.checkpoint.position)
	check(level.checkpoint_active,"Bandeira antes do chefe ativa ponto seguro")
	var boss: Node2D = level.guardian
	boss.phase = "attack"
	boss.remaining = 2
	await place(boss.position+Vector2(-210,0),15)
	check(level.tico.health==2,"Raízes causam dano no chão")
	level.tico.restore_health()
	level.tico.invulnerability_left = 0
	await place(boss.position+Vector2(-210,-120),3)
	check(level.tico.health==3,"Salto acima das raízes evita dano")
	boss.phase = "tired"
	boss.remaining = 5
	# O chefe permanece onde o mergulho terminou; o salto acompanha sua posição real.
	await place(boss.position+Vector2(72,-155),25)
	check(boss.health==2 and boss.phase=="waiting","Tico acerta a cabeça abaixada durante a abertura")
	check(not boss.receive_hit(),"Um acerto não conta duas vezes")
	await place(level.checkpoint.position)
	for i in 3:
		level.tico.invulnerability_left = 0
		level.tico.take_damage(level.tico.position+Vector2(20,0))
	await frames(80)
	check(level.tico.health==3 and level.tico.position.distance_to(level.checkpoint.position)<8,"Derrota retorna à bandeira com vida completa")
	check(boss.health==3 and boss.phase=="waiting","Derrota reinicia encontro do Periquito")
	level.queue_free()
	await frames(3)
	level = load("res://scenes/levels/world_1_2.tscn").instantiate()
	root.add_child(level)
	await frames(35)
	var hedgehog: Node2D = level.actors.get_node("Hedgehog")
	await place(hedgehog.position,15)
	check(level.tico.health==2,"Ouriço causa dano ao contato com espinhos")
	level.tico.restore_health()
	level.tico.invulnerability_left = 0
	await place(hedgehog.position+Vector2(0,-140),3)
	check(level.tico.health==3,"Passagem acima do ouriço é segura")
	level.queue_free()
	await frames(3)
	OS.delay_msec(100)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
