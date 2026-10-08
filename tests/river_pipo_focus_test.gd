extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	check(is_equal_approx(level.squirrel.move_speed,30.0),"Tico usa 10% da velocidade normal na fase 2-1")
	await frames(3)
	check(is_equal_approx(level.pipo.move_speed,209.0),"Pipo usa 95% da velocidade normal na fase 2-1")
	var wind: Rect2 = level.headwind_zones[0]
	check(wind.position.x<=0 and wind.end.x>=3800 and wind.position.y<0 and wind.end.y>=900,"Vento cobre todo o percurso jogável da fase 2-1")
	await place(Vector2(350,715),3)
	check(level.squirrel.wind_acceleration.x<0,"Tico sente o vento desde o começo da fase")
	var enemy: Node2D = level.actors.get_children().filter(func(actor): return actor.get("armor_broken")!=null)[0]
	check(enemy.get_meta("pipo_one_hit",false),"Todos os inimigos da fase recebem a regra de combate de Pipo")
	if level.tico!=level.pipo: level.switch_character()
	level.pipo.ability = "charge"
	level.pipo.charge_direction = 1
	check(enemy.receive_charge(level.pipo) and enemy.defeated,"Uma investida de Pipo derrota o inimigo")
	enemy.reset_enemy()
	enemy.set_meta("pipo_one_hit",true)
	level.pipo.ability = "ready"
	check(enemy.receive_pipo_stomp(level.pipo) and enemy.defeated,"Um pulo de Pipo sobre o inimigo também o derrota")
	await close_level()
	print("RESULTADO FOCO PIPO 2-1: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
