extends "res://tests/coop_test.gd"


func run() -> void:
	root.size = Vector2i(1280, 720)
	root.content_scale_size = Vector2i(1280, 720)
	var profile: Node = root.get_node_or_null("ControllerProfile")
	if profile == null:
		profile = preload("res://scripts/systems/controller_profile.gd").new()
		profile.name = "ControllerProfile"
		root.add_child(profile)
	var original: Dictionary = profile.bindings.duplicate()
	level = load("res://scenes/levels/world_1_1.tscn").instantiate()
	root.add_child(level)
	await frames(35)
	level.set_paused(true)
	level._open_controller_settings()
	await frames(3)
	var screen: CanvasLayer = level.controller_settings
	check(screen.visible and not level.pause_overlay.visible, "Tela de controle substitui o menu de pausa")
	check(screen.action_buttons.size() == 4, "Tela apresenta as quatro ações configuráveis")
	check(screen.device_label.text.length() > 0, "Tela informa o estado do controle USB")
	screen._begin_capture(&"jump")
	var event := InputEventJoypadButton.new()
	event.button_index = 10
	event.pressed = true
	Input.parse_input_event(event)
	await frames(3)
	check(int(profile.bindings.jump) == 10, "Próximo botão pressionado redefine a ação escolhida")
	check(screen.status.text == "Configuração salva.", "Tela confirma o salvamento do novo vínculo")
	profile.bindings = original
	profile.apply_profile()
	profile.save_profile()
	screen.close()
	await frames(2)
	check(level.pause_overlay.visible and not screen.visible, "Voltar restaura o menu de pausa")
	level.queue_free()
	await frames(3)
	print("RESULTADO CONFIGURAÇÃO DE CONTROLE: %d verificações, %d falhas" % [checks, failures])
	quit(1 if failures else 0)
