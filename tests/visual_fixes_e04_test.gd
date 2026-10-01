extends "res://tests/tutorial_e04_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(TUTORIAL_LEGACY)
	await start(10)
	var help: Node = level.contextual_help
	for message in ["Suba até o ninho • Siga as penas", "Segure PULO para planar. ".repeat(30), "Uma vida extra!", "Pipo liga o elevador • Tico sobe e salta"]:
		help.notify(message)
		await frames(3)
		check(help.panel.size.y<=92 and help.caption.size.y<=72,"Dica mantém altura limitada: %d caracteres" % message.length())
		check(help.panel.size.x<=720 and help.caption.position.y==10,"Texto permanece dentro da faixa da dica")
	help.notify("Uma linha")
	await frames(3)
	check(help.panel.size.y<70,"Texto curto volta à altura de uma linha após texto longo")
	# Reproduz uma corrente ascendente: a velocidade vertical cruza zero.
	level.set_physics_process(false)
	level.tico.reset_at(Vector2(1450,-150))
	level.tico.velocity.y = 4
	level.tico.wind_acceleration = Vector2(0,-500)
	Input.action_press("jump")
	await frames(2)
	var steady := true
	for i in 40:
		await frames(1)
		steady = steady and level.tico.state==&"glide" and level.tico.get_node("Illustration").pose=="glide"
	check(steady and level.tico.velocity.y<0,"Vento ascendente não alterna salto e planagem a cada quadro")
	check(level.tico.glide_remaining<level.tico.glide_duration,"Planagem com vento continua consumindo o tempo disponível")
	Input.action_release("jump")
	await frames(2)
	check(not level.tico._gliding,"Soltar PULO encerra planagem")
	level.tico._gliding = true
	level.tico.bounce()
	check(not level.tico._gliding,"Impulso sobre inimigo encerra planagem anterior")
	level.tico._gliding = true
	level.tico.invulnerability_left = 0
	level.tico.take_damage(level.tico.position)
	check(not level.tico._gliding,"Dano encerra planagem anterior")
	await close_world()
	await start(0)
	var medal: Area2D
	for actor in level.actors.get_children():
		if actor.has_meta("extra_life"): medal = actor
	check(is_instance_valid(medal),"Medalhão permanece na fase")
	var portraits := 0
	var labels := 0
	for child in medal.get_children():
		if child is Sprite2D: portraits += 1
		if child is Label: labels += 1
	check(portraits==1 and labels==0,"Medalhão usa retrato e selo desenhado sem texto recortado")
	var before: int = campaign.data.survival.lives
	level.tico.reset_at(medal.position)
	await frames(5)
	check(medal.taken and campaign.data.survival.lives==before+1,"Ícone novo preserva coleta e recompensa")
	await close_world()
	DirAccess.remove_absolute(TUTORIAL_SLOT)
	DirAccess.remove_absolute(TUTORIAL_LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
