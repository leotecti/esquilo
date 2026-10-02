extends SceneTree

func _init() -> void:
	for name in ["opening_village.png","opening_owl_trapped.png","opening_owl_rescued.png"]:
		var path: String = "res://assets/narrative/"+name
		var image: Image = Image.load_from_file(path)
		if image.is_empty():
			push_error("Não foi possível carregar "+path)
			quit(1)
			return
		image.resize(1280,720,Image.INTERPOLATE_LANCZOS)
		if image.save_png(path)!=OK:
			push_error("Não foi possível salvar "+path)
			quit(1)
			return
	quit()
