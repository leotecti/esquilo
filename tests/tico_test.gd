extends SceneTree
## Testes de comportamento com a cena real e eventos de teclado.

var failures: int = 0
var checks: int = 0
var tico: CharacterBody2D
var level: Node2D
var camera: Camera2D


func _initialize() -> void:
	call_deferred("run")


func check(condition: bool, message: String) -> void:
	checks += 1
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		push_error(message)


func frames(count: int) -> void:
	for i in range(count):
		await physics_frame
		await process_frame


func key(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)


func release_keys() -> void:
	for code in [KEY_A, KEY_D, KEY_LEFT, KEY_RIGHT, KEY_SPACE, KEY_ESCAPE]:
		key(code, false)


func place(point: Vector2, settle: int = 3) -> void:
	release_keys()
	tico.reset_at(point)
	await frames(settle)


func jump_height(hold_frames: int) -> float:
	await place(Vector2(160, 700), 30)
	var floor_y := tico.position.y
	var minimum := floor_y
	key(KEY_SPACE, true)
	for i in range(75):
		if i == hold_frames:
			key(KEY_SPACE, false)
		await frames(1)
		minimum = minf(minimum, tico.position.y)
	release_keys()
	return floor_y - minimum


func walk_off_edge(wait_after: int) -> void:
	await place(Vector2(1390, 340), 4)
	key(KEY_D, true)
	for i in range(30):
		await frames(1)
		if not tico.is_on_floor():
			break
	key(KEY_D, false)
	await frames(wait_after)


func run() -> void:
	# SceneTree com --script/headless não herda necessariamente a janela do jogo.
	root.size = Vector2i(1280, 720)
	root.content_scale_size = Vector2i(1280, 720)
	var main := load("res://scenes/main.tscn").instantiate() as Node2D
	root.add_child(main)
	current_scene = main
	level = main.get_node("TicoPlayground")
	tico = level.get_node("Tico")
	camera = level.get_node("FollowCamera")
	await frames(35)
	check(tico.is_on_floor() and absf(tico.position.y - 760.0) < 1.0, "Spawn e chão seguro")
	check(tico.state == &"idle", "Animação idle ao parar")
	var origin := tico.position.x
	key(KEY_D, true)
	await frames(2)
	check(tico.velocity.x > 0.0 and tico.velocity.x < tico.move_speed, "Aceleração progressiva")
	await frames(12)
	check(is_equal_approx(tico.velocity.x, tico.move_speed), "Velocidade de corrida limitada")
	check(tico.state == &"run" and tico.position.x > origin + 35.0, "Corrida e animação run")
	key(KEY_D, false)
	var stop_x := tico.position.x
	await frames(12)
	check(absf(tico.velocity.x) < 0.1 and tico.position.x - stop_x < 24.0, "Desaceleração sem deslize excessivo")
	key(KEY_A, true)
	await frames(10)
	check(tico.facing < 0.0 and tico.sprite.flip_h and tico.velocity.x < 0.0, "Direção visual acompanha a esquerda")
	release_keys()

	var short_height := await jump_height(2)
	var full_height := await jump_height(28)
	print("ALTURAS: curto=", short_height, " completo=", full_height)
	check(full_height > short_height + 45.0 and full_height < 150.0, "Altura variável: toque menor que botão mantido")
	check(tico.is_on_floor(), "Retorno ao chão após salto")
	key(KEY_SPACE, true)
	await frames(180)
	check(tico.is_on_floor(), "Manter Espaço pressionado não repete salto ao aterrissar")
	release_keys()

	await place(Vector2(160, 760))
	key(KEY_SPACE, true)
	await frames(6)
	check(tico.velocity.y < 0.0 and tico.state == &"jump", "Subida usa jump e não planar")
	key(KEY_SPACE, false)
	await frames(2)
	var before_air_jump := tico.velocity.y
	key(KEY_SPACE, true)
	await frames(1)
	check(tico.velocity.y > before_air_jump, "Novo toque no ar não cria salto duplo")
	key(KEY_SPACE, false)
	await frames(18)
	check(tico.state == &"fall", "Queda usa animação fall")
	await frames(40)

	await walk_off_edge(2)
	key(KEY_SPACE, true)
	await frames(1)
	check(tico.velocity.y < -450.0, "Coyote time aceita salto logo após sair da borda")
	await walk_off_edge(10)
	key(KEY_SPACE, true)
	await frames(1)
	check(tico.velocity.y >= 0.0, "Coyote time expira e não permite salto tardio")

	await place(Vector2(160, 700), 2)
	tico.position.y = 748.0
	tico.velocity.y = 180.0
	key(KEY_SPACE, true)
	await frames(1)
	check(tico.velocity.y >= 0.0, "Buffer não inicia salto antes de tocar o chão")
	key(KEY_SPACE, false)
	var buffered_jump := false
	for i in range(12):
		await frames(1)
		buffered_jump = buffered_jump or tico.velocity.y < -100.0
	check(buffered_jump, "Jump buffer executa comando pressionado antes da aterrissagem")
	await place(Vector2(160, 400), 3)
	key(KEY_SPACE, true)
	await frames(1)
	key(KEY_SPACE, false)
	await frames(80)
	check(tico.is_on_floor() and tico.state == &"idle", "Buffer antigo expira antes de aterrissar")

	await place(Vector2(1550, 380), 3)
	key(KEY_SPACE, true)
	await frames(20)
	check(tico.state == &"glide" and tico.velocity.y <= tico.glide_fall_speed + 0.1,
		"Planar limita queda e usa animação glide")
	var remaining: float = tico.glide_remaining
	key(KEY_SPACE, false)
	await frames(10)
	check(tico.state == &"fall" and tico.velocity.y > tico.glide_fall_speed,
		"Soltar Espaço encerra o planar")
	check(is_equal_approx(tico.glide_remaining, remaining), "Soltar no ar não recarrega a cauda")
	key(KEY_SPACE, true)
	var glide_expired := false
	for i in range(130):
		await frames(1)
		if tico.glide_remaining <= 0.0 and tico.state == &"fall":
			glide_expired = true
			break
	check(glide_expired, "Planar acaba após o tempo disponível")
	key(KEY_SPACE, false)
	await frames(45)
	check(tico.is_on_floor() and is_equal_approx(tico.glide_remaining, tico.glide_duration),
		"Cauda recarrega ao aterrissar")

	# Subir o percurso desde o chão usando os controles reais.
	await place(Vector2(240, 760))
	for step in [Vector2(430, 650), Vector2(700, 540), Vector2(980, 430), Vector2(1280, 340)]:
		key(KEY_D, true)
		key(KEY_SPACE, true)
		for i in range(95):
			await frames(1)
			if tico.position.x >= step.x:
				break
		release_keys()
		await frames(30)
		check(tico.is_on_floor() and absf(tico.position.y - step.y) < 1.0,
			"Percurso permite subir até a plataforma x=%s" % step.x)

	# Travessia real: sair da plataforma alta e alcançar a plataforma distante.
	await place(Vector2(1360, 340), 4)
	key(KEY_D, true)
	key(KEY_SPACE, true)
	var reached_landing := false
	for i in range(175):
		await frames(1)
		if tico.is_on_floor() and tico.position.x > 1700.0 and tico.position.y < 450.0:
			reached_landing = true
			break
	check(reached_landing, "Travessia longa alcança plataforma de pouso com planar")
	release_keys()
	await frames(2)
	check(tico.state == &"land", "Aterrissagem possui animação própria")

	for platform in [Vector3(430, 590, 650), Vector3(700, 480, 540), Vector3(980, 370, 430)]:
		await place(Vector2(platform.x, platform.y), 35)
		check(tico.is_on_floor() and absf(tico.position.y - platform.z) < 1.0,
			"Colisão no topo da plataforma x=%s" % platform.x)
	await place(Vector2(430, 760))
	key(KEY_SPACE, true)
	var hit_ceiling := false
	for i in range(18):
		await frames(1)
		hit_ceiling = hit_ceiling or tico.is_on_ceiling()
	check(hit_ceiling, "Parte inferior da plataforma bloqueia Tico")

	await place(Vector2(70, 760))
	key(KEY_LEFT, true)
	await frames(35)
	check(tico.is_on_wall() and tico.position.x >= 47.9, "Parede esquerda impede atravessar")
	await place(Vector2(3720, 760))
	key(KEY_RIGHT, true)
	await frames(35)
	check(tico.is_on_wall() and tico.position.x <= 3752.1, "Parede direita impede atravessar")

	await place(Vector2(2900, 760))
	camera.snap_to_target()
	await frames(3)
	var before_center := camera.get_screen_center_position()
	key(KEY_D, true)
	await frames(20)
	check(camera.global_position.x > tico.position.x + 40.0, "Câmera antecipa direção da corrida")
	check(camera.get_screen_center_position().x > before_center.x
		and camera.get_screen_center_position().x < camera.global_position.x, "Câmera acompanha com suavização")
	await place(Vector2(48, 760))
	camera.snap_to_target()
	await frames(5)
	var half_view := root.get_visible_rect().size * 0.5
	var center := camera.get_screen_center_position()
	check(center.x >= half_view.x - 1.0 and center.y <= 900.0 - half_view.y + 1.0,
		"Câmera respeita limites esquerdo e inferior")
	await place(Vector2(3752, 100))
	camera.snap_to_target()
	await frames(5)
	center = camera.get_screen_center_position()
	check(center.x <= 3800.0 - half_view.x + 1.0 and center.y >= half_view.y - 1.0,
		"Câmera respeita limites direito e superior")

	key(KEY_ESCAPE, true)
	await frames(2)
	key(KEY_ESCAPE, false)
	var paused_position := tico.position
	var paused_frame: int = tico.sprite.frame
	await frames(8)
	check(paused and tico.position.is_equal_approx(paused_position) and tico.sprite.frame == paused_frame,
		"Pausa congela física e animação")
	key(KEY_ESCAPE, true)
	await frames(2)
	key(KEY_ESCAPE, false)
	check(not paused, "Esc retoma playground")
	level.notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	await frames(2)
	check(paused, "Perder foco pausa o playground")
	level.restart()
	await frames(35)
	check(absf(tico.position.x - 160.0) < 1.0 and tico.is_on_floor(), "Recomeçar restaura o ponto inicial")
	level.set_paused(true)
	level.restart()
	await frames(2)
	check(not paused and is_equal_approx(tico.glide_remaining, tico.glide_duration), "Recomeçar funciona durante pausa")
	await place(Vector2(160, 760))
	await place(Vector2(1550, 380), 3)
	key(KEY_SPACE, true)
	await frames(2)
	check(tico.velocity.y >= 0.0, "Reposicionar no ar não preserva contato antigo com o chão")
	release_keys()
	print("RESULTADO: ", checks, " verificações, ", failures, " falhas")
	quit(0 if failures == 0 else 1)
