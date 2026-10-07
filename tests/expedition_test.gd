extends "res://tests/world_test.gd"

func advance() -> void:
	level.next_button.pressed.emit()
	await frames(3)
	if campaign.map_is_open(): campaign.enter_from_map(campaign.world_map.selected)
	await frames(35)
	level = campaign.level

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
	await place(Vector2(2460,720),12)
	check(level.switch_character() and level.tico==level.pipo,"2-1 chama Pipo diante do primeiro besouro blindado")
	await frames(12)
	var armored_enemy: Node2D = level.actors.get_children().filter(func(actor): return actor.get("armor_broken")!=null)[0]
	await place(armored_enemy.position+Vector2(-180,0),12)
	level.tico.facing = 1
	key(KEY_E,true)
	await frames(65)
	key(KEY_E,false)
	check(armored_enemy.armor_broken,"Investida de Pipo quebra a defesa no percurso")
	await frames(24)
	key(KEY_E,true)
	await frames(65)
	key(KEY_E,false)
	await place(Vector2(3040,760),8)
	await walk_to(3310)
	check(level.mechanisms.TroncoRio.active,"2-1: Pipo move o tronco e abre a passagem final")
	await place(level.mechanisms.PesoCorrente.position,35)
	check(level.mechanisms.PesoCorrente.active,"Pipo aciona a plataforma de peso antes da chegada")
	var cargo: Node2D = level.mechanisms.CargaRio
	await place(cargo.position,4)
	level.try_pipo_carry(level.pipo)
	await place(cargo.destination,4)
	level.try_pipo_carry(level.pipo)
	check(cargo.active,"Pipo entrega as provisões antes da chegada")
	await place(Vector2(3450,760),12)
	await walk_to(3590)
	await frames(60)
	check(level.completed,"2-1 concluída por comandos antes de produzir 2-2 e 2-3")
	await close_level()
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
