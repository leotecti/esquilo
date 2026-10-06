extends SceneTree

func _initialize() -> void:
	var image := Image.new()
	var error := image.load("res://web/icons/icon-master.png")
	if error != OK:
		push_error("Falha ao carregar o ícone mestre")
		quit(1)
		return
	for size in [16, 32, 48, 64, 128, 144, 180, 192, 256, 512]:
		var resized := image.duplicate() as Image
		resized.resize(size, size, Image.INTERPOLATE_LANCZOS)
		if resized.save_png("res://web/icons/icon-%s.png" % size) != OK:
			quit(1)
			return
	if not _save_windows_icon([16, 32, 48, 64, 128, 256], "res://web/icons/tico.ico"):
		quit(1)
		return
	quit()

func _save_windows_icon(sizes: Array, ico_path: String) -> bool:
	# ICO moderno aceita imagens PNG; múltiplos tamanhos preservam detalhes no Explorer.
	var images: Array[PackedByteArray] = []
	for size in sizes:
		var png := FileAccess.get_file_as_bytes("res://web/icons/icon-%s.png" % size)
		if png.is_empty():
			return false
		images.append(png)
	var file := FileAccess.open(ico_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_16(0)
	file.store_16(1)
	file.store_16(images.size())
	var offset := 6 + 16 * images.size()
	for index in images.size():
		var size: int = sizes[index]
		file.store_8(0 if size == 256 else size)
		file.store_8(0 if size == 256 else size)
		file.store_8(0)
		file.store_8(0)
		file.store_16(1)
		file.store_16(32)
		file.store_32(images[index].size())
		file.store_32(offset)
		offset += images[index].size()
	for png in images:
		file.store_buffer(png)
	return true
