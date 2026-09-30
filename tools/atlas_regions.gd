extends SceneTree
## Calcula recortes sem modificar as imagens de origem.
func _initialize() -> void:
	var atlas_data := {}
	for spec in [["tico",4,[0,512,1024]], ["pipo",4,[0,373,684,1024]], ["props",4,[0,430,817,1254]], ["push",4,[0,512,1024],[0,398,772,1143,1536]]]:
		var image := Image.load_from_file(ProjectSettings.globalize_path("res://assets/slice/%s.png" % spec[0]))
		if image == null:
			push_error("Atlas ausente: " + spec[0])
			quit(1)
			return
		var width: int = image.get_width() / int(spec[1])
		var columns: Array = spec[3] if spec.size()>3 else [0,width,width*2,width*3,image.get_width()]
		var rects: Array = []
		for row in range(spec[2].size()-1):
			for col in int(spec[1]):
				var min_x := image.get_width()
				var min_y := image.get_height()
				var max_x := -1
				var max_y := -1
				for y in range(spec[2][row],mini(spec[2][row+1],image.get_height())):
					for x in range(columns[col],columns[col+1]):
						var pixel := image.get_pixel(x,y)
						if pixel.a < 0.1 or (pixel.r > 0.65 and pixel.b > 0.65 and pixel.g < 0.4):
							continue
						min_x = mini(min_x,x)
						min_y = mini(min_y,y)
						max_x = maxi(max_x,x)
						max_y = maxi(max_y,y)
				if max_x < min_x:
					push_error("Célula vazia: " + spec[0])
					quit(1)
					return
				rects.append([min_x,min_y,max_x-min_x+1,max_y-min_y+1])
		atlas_data[spec[0]] = rects
	var file := FileAccess.open("res://assets/slice/regions.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(atlas_data,"\t"))
	print("Recortes dos atlas calculados.")
	quit()
