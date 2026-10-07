extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	check(level.mechanisms.has("PesoCorrente") and level.launch_stations.size()==1,"2-1 combina plataforma de peso e ponto de impulso")
	if level.tico!=level.pipo: level.switch_character()
	await frames(12)
	var weight: Node2D = level.mechanisms.PesoCorrente
	await place(weight.position,35)
	check(weight.active,"Pipo mantém a plataforma pressionada até travar o mecanismo")
	var station: Node2D = level.launch_stations[0]
	await place(station.position,4)
	key(KEY_E,true)
	await frames(2)
	key(KEY_E,false)
	check(level.launching_tico,"AÇÃO de Pipo prepara o impulso em dupla em vez da investida")
	await frames(18)
	check(level.tico==level.squirrel and level.launching_tico==false,"Impulso entrega o controle automaticamente a Tico")
	check(level.squirrel.velocity.y<0 and level.squirrel.position.y<station.position.y,"Tico parte para cima e alcança a rota elevada")
	await close_level()
	await open_stage(2,"2")
	check(level.mechanisms.has("PesoMargem"),"2-2 possui plataforma de peso própria")
	await close_level()
	await open_stage(2,"3")
	check(level.mechanisms.has("PesoPonte"),"2-3 possui plataforma de peso própria")
	await close_level()
	var store = preload("res://scripts/systems/expedition_save.gd").new()
	var old: Dictionary = {"save_version":2,"tutorials":{},"levels":{"4":{"completed":true,"checkpoint":true,"mechanisms":{}}}}
	var migrated: Dictionary = store.migrate(old)
	check(migrated.levels["4"].mechanisms.get("PesoCorrente",false),"Save anterior concluído recebe o novo mecanismo sem perder progresso")
	print("RESULTADO PESO E IMPULSO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
