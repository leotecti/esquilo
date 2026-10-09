extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(2)
	var manager = level.activity_manager
	check(is_instance_valid(manager),"Fases usam gerenciador de atividade mobile")
	var initial: Dictionary = manager.details()
	print("ATIVIDADE E25: ",JSON.stringify(initial))
	check(initial.tracked_visuals>150 and initial.active_visuals<initial.tracked_visuals/3,"Animações distantes ficam suspensas na fase longa")
	check(initial.tracked_enemies>=10 and initial.active_enemies<initial.tracked_enemies,"Inimigos distantes não executam física")
	var distant_enemy: Node = level.actors.get_children().filter(func(actor): return actor.has_meta("friend_route_enemy") and actor.position.x>24000)[0]
	check(not distant_enemy.is_physics_processing(),"Inimigo fora da margem de câmera permanece em espera")
	level.tico.reset_at(distant_enemy.position+Vector2(-180,0))
	level.camera.snap_to_target()
	await frames(15)
	check(distant_enemy.is_physics_processing(),"Inimigo é reativado antes de entrar na tela")
	var item: Node = level.actors.get_children().filter(func(actor): return actor.has_method("reset_item"))[0]
	check(not item.is_processing(),"Desenho-base invisível dos coletáveis não consome callbacks")
	var drip: Node = level.optional_area.drips[0]
	var frozen_clock: float = drip.clock
	level.tico.reset_at(Vector2(1000,760))
	drip._physics_process(1.0)
	check(is_equal_approx(drip.clock,frozen_clock),"Goteiras distantes ficam suspensas fora da caverna")
	check(level.optional_area.PERFORMANCE_STYLE_VERSION==2 and level.optional_area.has_method("_draw_active_cave"),"1-3 separa portal e cenário secundário e mantém a pintura da gruta estática")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO E25: %d verificacoes, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
