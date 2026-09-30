extends "res://tests/world_test.gd"

func open_stage(world: int, section_id: String) -> void:
	level = load("res://scenes/levels/world_%d_%s.tscn" % [world,section_id]).instantiate()
	root.add_child(level)
	await frames(35)

func glide_to(x: float) -> void:
	key(KEY_D,true)
	var held := 0
	for i in 1000:
		if level.tico.position.x>=x or level.completed: break
		if held>0:
			held += 1
			if (held>12 and level.tico.is_on_floor()) or held>150:
				key(KEY_SPACE,false)
				held = 0
		elif level.tico.is_on_floor():
			key(KEY_SPACE,true)
			held = 1
		await frames(1)
	key(KEY_D,false)
	key(KEY_SPACE,false)
	await frames(65)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	check(level.rescued and level.switch_character(),"Rio começa com a dupla disponível")
	await frames(20)
	var platform: Node2D = level.movers[0]
	await place(platform.position-Vector2(0,3),4)
	var offset: float = level.tico.position.x-platform.position.x
	await frames(50)
	check(absf(level.tico.position.x-platform.position.x-offset)<8,"Plataforma móvel transporta Pipo parado")
	var clock: float = platform.clock
	level.set_paused(true)
	await frames(30)
	check(platform.clock==clock,"Pausa congela plataformas móveis")
	level.set_paused(false)
	await place(Vector2(850,835),2)
	check(level.tico.health==2 and level.tico.position.y<800,"Água tira um coração e retorna à margem")
	await close_level()
	await open_stage(2,"1")
	await walk_to(565)
	await glide_to(1230)
	check(level.tico.position.x>1140,"2-1: primeira travessia por comandos")
	await walk_to(1510)
	await glide_to(2180)
	check(level.tico.position.x>2080 and level.checkpoint_active,"2-1: plataformas duplas e checkpoint")
	await walk_to(2460)
	await glide_to(2940)
	await walk_to(2990)
	await glide_to(3350)
	await walk_to(3590)
	await frames(60)
	check(level.completed,"2-1 concluída por comandos antes de produzir 2-2 e 2-3")
	await close_level()
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
