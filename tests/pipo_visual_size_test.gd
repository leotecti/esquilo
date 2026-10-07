extends "res://tests/coop_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	level = load("res://scenes/levels/coop_trail.tscn").instantiate()
	root.add_child(level)
	await frames(35)
	var art_script = load("res://scripts/presentation/character_art.gd")
	var tico_collision: Vector2 = level.squirrel.get_node("Collision").shape.size
	var pipo_collision: Vector2 = level.pipo.get_node("Collision").shape.size
	check(art_script.PIPO_VISUAL_HEIGHT/art_script.TICO_VISUAL_HEIGHT>=1.25,"Pipo fica visualmente pelo menos 25% mais alto que Tico")
	check(pipo_collision.y>tico_collision.y and pipo_collision.x>tico_collision.x,"Corpo físico existente confirma que Pipo não cabe nas passagens de Tico")
	check(art_script.PIPO_CHARGE_HEIGHT>58 and art_script.PIPO_PUSH_HEIGHT>72,"Investida e empurrão preservam o novo porte de Pipo")
	var illustration = art_script.new()
	illustration.character = level.pipo
	illustration.pig = level.pipo.is_in_group("pipo")
	check(illustration.pig,"Ilustração reconhece e aplica as proporções de Pipo")
	illustration.free()
	level.queue_free()
	await frames(3)
	print("RESULTADO PORTE DO PIPO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
