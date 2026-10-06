extends "res://tests/checkpoints_e03_test.gd"

func navigate_route(direction: int, target: float, limit := 24000) -> bool:
	var held := 0
	key(KEY_D if direction>0 else KEY_A,true)
	for i in limit:
		if (direction>0 and (level.completed or level.tico.position.x>=target)) or (direction<0 and level.tico.position.x<=target): break
		if held>0:
			held -= 1
			if held==0: key(KEY_SPACE,false)
		elif level.tico.is_on_floor():
			key(KEY_SPACE,true)
			held = 27
		await frames(1)
	release()
	return level.completed or (level.tico.position.x>=target if direction>0 else level.tico.position.x<=target)

func run() -> void:
	await start_phase(1)
	level.tico.invulnerability_left = 10000
	check(await navigate_route(1,38500),"Tico atravessa toda a rota principal sem ficar preso")
	var layout = preload("res://scripts/systems/blocks_secrets_layout.gd")
	var greatest_rise := 0
	for profile in layout.PROFILES:
		for i in range(1,profile.size()): greatest_rise = maxi(greatest_rise,int(profile[i-1])-int(profile[i]))
	check(greatest_rise<=80,"Todos os degraus repetidos respeitam a margem segura de Tico e Pipo: %d px" % greatest_rise)
	level.optional_area.travel(true)
	await create_timer(.45,true).timeout
	level.tico.invulnerability_left = 10000
	check(await navigate_route(1,50680,6000),"Tico atravessa a Galeria das Pedras sem bloqueio")
	check(await navigate_route(-1,47120,6000),"Galeria permite retornar até a entrada")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
