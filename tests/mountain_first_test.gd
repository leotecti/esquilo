extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(3,"1")
	await glide_to(1030)
	check(level.tico.position.y<650,"3-1 começa com subida gradual")
	key(KEY_SPACE,true)
	key(KEY_D,true)
	var wind_seen := false
	for i in 240:
		await frames(1)
		if level.tico.wind_acceleration.y<0: wind_seen = true
		if level.tico.position.x>1740: break
	release()
	await frames(80)
	check(wind_seen and level.tico.position.x>1640,"Tico usa vento para planar até a plataforma alta")
	await walk_to(1920)
	await glide_to(2530)
	await walk_to(2730)
	await glide_to(3310)
	await walk_to(3590)
	await frames(60)
	check(level.completed,"3-1 concluída por comandos antes de produzir 3-2 e 3-3")
	await close_level()
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
