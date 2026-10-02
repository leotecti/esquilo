extends "res://tests/checkpoints_e03_test.gd"

func move_to(target: float, limit := 24000) -> bool:
	var right: bool = level.tico.position.x<target
	var held := 0
	key(KEY_D if right else KEY_A,true)
	for i in limit:
		if (right and level.tico.position.x>=target) or (not right and level.tico.position.x<=target): break
		if held>0:
			held -= 1
			if held==0: key(KEY_SPACE,false)
		elif level.tico.is_on_floor():
			key(KEY_SPACE,true)
			held = 27
		await frames(1)
	release()
	print("Percurso até ",target,": ",level.tico.position)
	return level.tico.position.x>=target if right else level.tico.position.x<=target

func run() -> void:
	await start_phase(0)
	# Isola a travessia do terreno das colisões com inimigos, cobertas separadamente.
	for enemy in level.actors.get_children():
		if enemy.has_method("reset_enemy"): enemy.defeated = true
	for character in ["Tico","Pipo"]:
		level.rescued = true
		if character=="Pipo": level._activate(level.pipo,Vector2(41600,545))
		check(level.tico==level.pipo if character=="Pipo" else level.tico==level.squirrel,"Personagem ativo: "+character)
		level.tico.reset_at(Vector2(41600,545))
		await frames(12)
		check(await move_to(200),"%s consegue voltar da chegada ao início" % character)
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
