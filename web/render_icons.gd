extends SceneTree

func _initialize() -> void:
	var image := Image.new()
	var error := image.load_svg_from_string(FileAccess.get_file_as_string("res://web/icons/icon.svg"))
	if error != OK:
		push_error("Falha ao rasterizar ícone vetorial")
		quit(1)
		return
	for size in [144, 180, 192, 512]:
		var resized := image.duplicate() as Image
		resized.resize(size, size, Image.INTERPOLATE_LANCZOS)
		if resized.save_png("res://web/icons/icon-%s.png" % size) != OK:
			quit(1)
			return
	quit()
