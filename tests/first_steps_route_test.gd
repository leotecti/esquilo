extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	await start_phase(0)
	var start_frame := Engine.get_physics_frames()
	var held := 0
	var furthest: float = level.tico.position.x
	key(KEY_D,true)
	for i in 24000:
		if level.completed or campaign.awaiting_return(): break
		furthest = maxf(furthest,level.tico.position.x)
		if held>0:
			held -= 1
			if held==0: key(KEY_SPACE,false)
		elif level.tico.is_on_floor():
			key(KEY_SPACE,true)
			held = 27
		await frames(1)
	release()
	check(level.completed,"Percurso completo pode ser concluído por movimento e salto")
	print("TEMPO DE SIMULAÇÃO, rota direta sem copa: %.1f segundos" % ((Engine.get_physics_frames()-start_frame)/60.0))
	print("POSIÇÃO FINAL: ",level.tico.position)
	print("POSIÇÃO MAIS DISTANTE: ",furthest)
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
