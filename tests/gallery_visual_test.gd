extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(1)
	level.optional_area.travel(true)
	await create_timer(.45,true).timeout
	level.tico.reset_at(Vector2(46800,650))
	level.camera.snap_to_target()
	await frames(12)
	var texture := root.get_texture()
	var image := texture.get_image() if texture else null
	var error := image.save_png("res://builds/galeria-piso-diagnostico.png") if image else ERR_UNAVAILABLE
	check(error==OK,"Captura visual da Galeria gerada")
	var visual := level.get_node_or_null("ForestOptionalGallery")
	check(is_instance_valid(visual) and visual.is_visible_in_tree(),"Trecho visual da Galeria está visível na árvore")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
