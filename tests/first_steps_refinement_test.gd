extends "res://tests/checkpoints_e03_test.gd"

func jump_to(x: float) -> void:
	key(KEY_SPACE,true)
	await frames(8)
	var right: bool = level.tico.position.x<x
	key(KEY_D if right else KEY_A,true)
	for i in 120:
		if (right and level.tico.position.x>=x) or (not right and level.tico.position.x<=x): break
		await frames(1)
	release()
	for i in 120:
		await frames(1)
		if level.tico.is_on_floor(): break
	print("Salto até ",x,": ",level.tico.position)

func run() -> void:
	await start_phase(0)
	for character in ["Tico","Pipo"]:
		level.rescued = true
		if character=="Pipo": level._activate(level.pipo,Vector2(21420,755))
		level.tico.reset_at(Vector2(21420,755))
		await frames(15)
		for x in [21290,21170,21020,21170,21000]: await jump_to(x)
		check(level.tico.position.distance_to(level.optional_area.ENTRY)<95,"%s sobe à árvore vindo da direita: %s" % [character,level.tico.position])
	# Patrulha estreita: deve sair de ambas as paredes sem alternar a cada quadro.
	level._solid("TestFloor",Rect2(70000,760,400,100),Color.TRANSPARENT)
	level._solid("TestLeft",Rect2(70020,600,20,160),Color.TRANSPARENT)
	level._solid("TestRight",Rect2(70160,600,20,160),Color.TRANSPARENT)
	level._slug(Vector2(70100,760),130)
	var slug = level.actors.get_child(level.actors.get_child_count()-1)
	var last: float = slug.direction
	var flips := 0
	var min_x: float = slug.position.x
	var max_x: float = min_x
	for i in 600:
		await frames(1)
		if slug.direction!=last: flips += 1
		last = slug.direction
		min_x = minf(min_x,slug.position.x)
		max_x = maxf(max_x,slug.position.x)
	check(flips>=2 and flips<15 and max_x-min_x>45,"Lesma entre paredes patrulha sem oscilação: %d viradas" % flips)
	# Compatibilidade com as bandeiras removidas.
	var old: Dictionary = level.world_snapshot()
	old.checkpoint = true
	old.route_checkpoint = 4
	old.optional_area = {"active":false,"checkpoint":true}
	level.restore_world(old)
	check(level.checkpoint_position.x==24100 and not level.optional_area.checkpoint,"Save antigo usa a bandeira única")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
