extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"3")
	check(level.background.modulate==Color("a5bdc8"),"Fundo da fase 2-3 recebe tonalidade fria e chuvosa")
	check(level.scenery.RAINY_BRIDGE_STYLE_VERSION==1 and level.scenery.RAIN_DROP_COUNT==44,"Chuva usa camada visual limitada para celulares")
	check(is_equal_approx(level.squirrel.surface_grip,0.52),"Tico desliza no piso molhado")
	check(is_equal_approx(level.pipo.surface_grip,0.72),"Peso de Pipo oferece mais aderência no piso molhado")
	var rain_hint: Array = level.actors.get_children().filter(func(actor): return actor is Label and "escorregadio" in actor.text.to_lower())
	check(rain_hint.size()==1,"Sinal inicial explica o piso escorregadio")
	check(level.mechanisms.has("Ponte") and level.mechanisms.has("PesoPonte") and level.mechanisms.has("CargaPonte"),"Clima preserva os mecanismos da Grande Ponte")
	await close_level()
	print("RESULTADO FASE 2-3 CHUVOSA: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
