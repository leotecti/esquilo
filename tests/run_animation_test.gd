extends "res://tests/coop_test.gd"

func pipo_run_faces_forward() -> bool:
	var image: Image = load("res://assets/characters/pipo/run_sheet_v2.png").get_image()
	var frame_width := image.get_width()/4
	for frame in 4:
		var pink_x := 0.0
		var pink_count := 0
		for y in range(0,image.get_height(),2):
			for x in range(0,frame_width,2):
				var color := image.get_pixel(frame*frame_width+x,y)
				if color.a>0.5 and color.r>0.68 and color.r>color.g*1.18 and color.g>0.25 and color.b>0.18:
					pink_x += x
					pink_count += 1
		if pink_count==0 or pink_x/pink_count<=frame_width*0.5:
			return false
	return true

func run() -> void:
	root.size = Vector2i(1280,720)
	check(pipo_run_faces_forward(),"Pipo mantém focinho e corpo voltados para a corrida nos quatro quadros")
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
