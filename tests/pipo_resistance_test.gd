extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	check(level.current_zones.size()>=3,"Rio possui faixas caminháveis de correnteza")
	check(level.squirrel.environmental_force_multiplier(&"wind")==1.0 and level.pipo.environmental_force_multiplier(&"wind")==0.30,"Pipo recebe apenas 30% da força do vento")
	check(level.squirrel.environmental_force_multiplier(&"current")==1.0 and level.pipo.environmental_force_multiplier(&"current")==0.25,"Pipo recebe apenas 25% da correnteza")
	level.squirrel.controls_enabled = true
	level.squirrel.health = 3
	level.squirrel.invulnerability_left = 0
	level.squirrel.position = Vector2(400,760)
	level.squirrel.take_damage(Vector2(500,760))
	var tico_recoil: float = level.squirrel.velocity.length()
	level.pipo.controls_enabled = true
	level.pipo.health = 3
	level.pipo.invulnerability_left = 0
	level.pipo.position = Vector2(400,760)
	level.pipo.take_damage(Vector2(500,760))
	check(level.pipo.velocity.length()<tico_recoil*.5,"Pipo sofre menos da metade do recuo causado por um golpe")
	check(level.pipo.health==2,"Resistência reduz deslocamento, mas preserva o dano e a leitura de perigo")
	await close_level()
	print("RESULTADO RESISTÊNCIA DO PIPO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
