extends SceneTree
## Integração: cena real, teclado, física e pausa. Executar com --script.

var failures: int = 0
var probe: CharacterBody2D
var level: Node2D


func _initialize() -> void:
	call_deferred("run")


func check(condition: bool, message: String) -> void:
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


func place(point: Vector2) -> void:
	probe.position = point
	probe.velocity = Vector2.ZERO


func run() -> void:
	var main := load("res://scenes/levels/test_level.tscn").instantiate() as Node2D
	root.add_child(main)
	current_scene = main
	level = main
	probe = level.get_node("TestProbe")
	await frames(50)
	check(probe.is_on_floor() and absf(probe.position.y - 618.0) < 1.0,
		"Gravidade e colisão com o chão no ponto inicial")
	var initial_x := probe.position.x
	key(KEY_D, true)
	await frames(15)
	key(KEY_D, false)
	check(probe.position.x > initial_x + 40, "D move para a direita")
	key(KEY_A, true)
	await frames(15)
	key(KEY_A, false)
	check(absf(probe.position.x - initial_x) < 8, "A move para a esquerda")
	key(KEY_SPACE, true)
	await frames(8)
	key(KEY_SPACE, false)
	check(probe.position.y < 580, "Espaço inicia salto quando apoiado")
	await frames(65)
	check(probe.is_on_floor(), "Aterrissagem após salto")
	key(KEY_LEFT, true)
	await frames(60)
	key(KEY_LEFT, false)
	check(probe.is_on_wall() and probe.position.x >= 47.9,
		"Seta esquerda: parede impede atravessamento")
	place(Vector2(1150, 600))
	key(KEY_RIGHT, true)
	await frames(40)
	key(KEY_RIGHT, false)
	check(probe.is_on_wall() and probe.position.x <= 1232.1,
		"Seta direita: parede impede atravessamento")
	for platform in [Vector3(390, 450, 516), Vector3(650, 340, 406), Vector3(910, 230, 296)]:
		place(Vector2(platform.x, platform.y))
		await frames(40)
		check(probe.is_on_floor() and absf(probe.position.y - platform.z) < 1.0,
			"Colisão com topo da plataforma em x=%s" % platform.x)
	place(Vector2(390, 618))
	await frames(3)
	key(KEY_SPACE, true)
	var hit_ceiling := false
	for i in range(15):
		await frames(1)
		hit_ceiling = hit_ceiling or probe.is_on_ceiling()
	key(KEY_SPACE, false)
	check(hit_ceiling, "Parte inferior da plataforma bloqueia o salto")
	key(KEY_E, true)
	await frames(2)
	key(KEY_E, false)
	check(level.last_command == "E / action", "E chega à ação reservada")
	key(KEY_Q, true)
	await frames(2)
	key(KEY_Q, false)
	check(level.last_command == "Q / switch_character", "Q chega à troca reservada")
	key(KEY_ESCAPE, true)
	await frames(2)
	key(KEY_ESCAPE, false)
	check(paused, "Esc pausa")
	var paused_position := probe.position
	key(KEY_D, true)
	await frames(10)
	key(KEY_D, false)
	check(probe.position.is_equal_approx(paused_position), "Corpo permanece imóvel durante pausa")
	key(KEY_ESCAPE, true)
	await frames(2)
	key(KEY_ESCAPE, false)
	check(not paused, "Esc retoma execução")
	print("RESULTADO: ", failures, " falhas")
	quit(0 if failures == 0 else 1)
