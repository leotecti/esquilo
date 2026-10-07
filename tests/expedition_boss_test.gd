extends "res://tests/expedition_routes_test.gd"

func opening() -> void:
	for i in 700:
		await frames(1)
		if level.guardian.phase=="tired": return
	check(false,"Chefe abre janela de vulnerabilidade")

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	for world in [2,3,4]:
		await open_stage(world,"guardian")
		level._on_exit(level.exit_marker)
		check(not level.completed,"Saída aguarda chefe do mundo %d" % world)
		if world==2:
			await walk_to(2520)
			await select_pipo()
		elif world==3:
			await walk_to(2410)
			await glide_to(2530)
		else:
			await charge_at(2070)
			check(level.mechanisms.Arena.active and level.movers[0].enabled,"Rei Castor: Pipo liga mecanismo da arena")
			await select_tico()
			await walk_to(2350)
			await glide_to(2650)
		for hit in 3:
			await opening()
			if hit==0:
				var timer: float = level.guardian.remaining
				level.set_paused(true)
				await frames(25)
				check(level.guardian.remaining==timer,"Pausa congela chefe %d" % world)
				level.set_paused(false)
			if world==2:
				var health_before: int = level.guardian.health
				await charge_at(2650)
				check(level.guardian.river_guard_broken and level.guardian.health==health_before,"Guardião do Rio: Pipo rompe a defesa sem causar o acerto final")
				await select_tico()
				level.guardian.invulnerable = 0.0
				check(level.guardian.receive_tico_stomp(level.squirrel),"Guardião do Rio: Tico conclui a abertura com o salto")
				await frames(4)
			else:
				await walk_to(2640 if world==4 else 2690)
				key(KEY_SPACE,true)
				await walk_to(2850)
				key(KEY_SPACE,false)
				await frames(65)
			check(level.guardian.health==2-hit,"Acerto físico %d no chefe do mundo %d" % [hit,world])
			if hit<2:
				if world==2: await place(Vector2(2200,760),20)
				else: await left_to(2520 if world<4 else 2640)
		if world==2: await place(Vector2(3500,760),12)
		await walk_to(3590)
		await frames(60)
		check(level.completed and level.guardian.health==0,"Encontro completo do mundo %d por comandos" % world)
		await close_level()
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
