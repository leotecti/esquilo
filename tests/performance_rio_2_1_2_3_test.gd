extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	for section_id in ["1","2","3"]:
		await open_stage(2,section_id)
		var activity: Dictionary = level.activity_manager.details()
		check(activity.profile_version==2 and is_equal_approx(activity.update_interval,0.24),"2-%s usa perfil móvel otimizado" % section_id)
		check(activity.tracked_enemies>activity.active_enemies,"2-%s suspende inimigos distantes" % section_id)
		check(activity.tracked_moving_objects>activity.active_moving_objects,"2-%s suspende plataformas distantes" % section_id)
		check(activity.tracked_collectibles>activity.active_collectibles*3,"2-%s suspende a maioria das recompensas distantes" % section_id)
		check(level.scenery.PERFORMANCE_STYLE_VERSION==3,"2-%s limita a atualização dos efeitos do rio" % section_id)
		await close_level()
	print("RESULTADO PERFORMANCE RIO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
