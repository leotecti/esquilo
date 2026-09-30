extends "res://tests/coop_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	level = load("res://scenes/levels/world_2_guardian.tscn").instantiate()
	level.save_enabled = false
	root.add_child(level)
	await frames(30)
	for pig in [false,true]:
		await place(Vector2(300,760))
		if pig: level.switch_character()
		var art: Node2D = level.tico.get_node("Illustration")
		for code in [KEY_D,KEY_A]:
			await place(Vector2(400,760))
			key(code,true)
			var phases := {}
			for i in 45:
				await frames(1)
				if art.pose=="run": phases[art.run_frame] = true
			check(phases.size()==4,"Quatro passadas na corrida: %s / %s" % [pig,code])
			level.set_paused(true)
			var current: int = art.run_frame
			await frames(15)
			check(art.run_frame==current,"Pausa congela corrida")
			level.set_paused(false)
			key(code,false)
			await frames(30)
			check(art.pose=="idle" and art.run_frame==0,"Soltar direção encerra passadas")
		key(KEY_SPACE,true)
		await frames(12)
		check(art.pose=="jump" and art.run_frame==0,"Salto preserva sua própria pose")
		key(KEY_SPACE,false)
		await frames(60)
	release()
	level.queue_free()
	await frames(3)
	OS.delay_msec(100)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
