extends "res://tests/blocks_secrets_route_test.gd"

func run() -> void:
	await start_phase(1)
	level.optional_area.travel(true)
	await create_timer(.45,true).timeout
	level.tico.invulnerability_left = 10000
	check(await navigate_route(1,50680,6000),"Tico atravessa a Galeria das Pedras sem bloqueio")
	check(await navigate_route(-1,46280,6000),"Tico retorna pela galeria sem encontrar parede alta")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
