extends "res://tests/checkpoints_e03_test.gd"

func capture_at(point: Vector2, file_name: String) -> void:
	level.tico.reset_at(point)
	level.camera.snap_to_target()
	await frames(8)
	var image := root.get_texture().get_image()
	var error := image.save_png("res://builds/"+file_name)
	check(error==OK,"Captura visual gerada: "+file_name)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(0)
	await capture_at(Vector2(7600,700),"primeiros-passos-solo-01.png")
	await capture_at(Vector2(15000,700),"primeiros-passos-solo-02.png")
	await capture_at(Vector2(34200,700),"primeiros-passos-solo-03.png")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
