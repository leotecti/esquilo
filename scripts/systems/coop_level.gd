extends "res://scripts/systems/tico_minigame.gd"
const PIPO = preload("res://scenes/characters/pipo.tscn")
const PUSHABLE = preload("res://scenes/objects/pushable.tscn")
const HEAVY = preload("res://scenes/objects/heavy_block.tscn")
const SECRET = preload("res://scenes/objects/secret_nut.tscn")

var squirrel: CharacterBody2D
# A referência herdada `tico` aponta sempre para o personagem ativo.
var pipo: CharacterBody2D
var stone: CharacterBody2D
var heavy: StaticBody2D
var gate: StaticBody2D
var secret: Area2D
var gate_open: bool = false
var switch_button: Button
var _scent_announced: bool = false
var _switch_left: float = 0.0

func _ready() -> void:
	super._ready()
	squirrel = $Tico
	pipo = PIPO.instantiate()
	pipo.position = squirrel.position
	add_child(pipo)
	pipo.health_changed.connect(_health_changed)
	pipo.hurt.connect(_on_hurt)
	pipo.defeated.connect(_on_defeat)
	pipo.ability_changed.connect(_on_ability)
	_deactivate(pipo)
	switch_button = Button.new()
	switch_button.name = "Switch"
	switch_button.focus_mode = Control.FOCUS_NONE
	switch_button.custom_minimum_size = Vector2(160,44)
	switch_button.add_theme_font_size_override("font_size",20)
	switch_button.pressed.connect(switch_character)
	$Interface/HUD/TopBar.add_child(switch_button)
	$Interface/HUD/TopBar.move_child(switch_button,1)
	_update_layout()
	_say("Q ou Trocar: chame Pipo. Cada amigo tem seu talento!")

func _build_gameplay() -> void:
	for point in [Vector2(330,715),Vector2(640,715),Vector2(1250,715),Vector2(1500,726),Vector2(1650,726),Vector2(1980,715),Vector2(2510,715),Vector2(3250,715)]:
		var item = NUT.instantiate()
		item.position = point
		actors.add_child(item)
		item.collected.connect(_on_collected)
		total_nuts += 1
	stone = PUSHABLE.instantiate()
	stone.name = "Stone"
	stone.position = Vector2(850,760)
	actors.add_child(stone)
	var plate := _solid("Plate",Rect2(1070,756,100,4),Color("e2bf66"))
	plate.collision_layer = 0
	_solid("Tunnel",Rect2(1350,0,400,696),Color("80613f"))
	var leaf := Polygon2D.new()
	leaf.polygon = PackedVector2Array([Vector2(1310,610),Vector2(1330,560),Vector2(1500,530),Vector2(1690,555),Vector2(1800,610)])
	leaf.color = Color("5e8551")
	actors.add_child(leaf)
	gate = _solid("Gate",Rect2(1340,696,24,64),Color("d5b971"))
	heavy = HEAVY.instantiate()
	heavy.position = Vector2(2240,760)
	actors.add_child(heavy)
	heavy.broken.connect(_on_heavy_broken)
	secret = SECRET.instantiate()
	secret.name = "Secret"
	secret.position = Vector2(2880,718)
	actors.add_child(secret)
	secret.collected.connect(_on_collected)
	total_nuts += 1
	checkpoint = CHECKPOINT.instantiate()
	checkpoint.position = Vector2(1850,760)
	actors.add_child(checkpoint)
	checkpoint.reached.connect(_on_checkpoint)
	exit_marker = EXIT.instantiate()
	exit_marker.position = Vector2(3560,760)
	actors.add_child(exit_marker)
	exit_marker.reached.connect(_on_exit)
	for point in [Vector2(540,760),Vector2(3160,760)]:
		var slug = SLUG.instantiate()
		slug.position = point
		slug.patrol_distance = 65
		actors.add_child(slug)
		slug.stomped.connect(_on_stomp)
	_sign(Vector2(130,565),"Dois amigos, uma aventura\nTico é ágil. Pipo é forte.")
	_sign(Vector2(690,565),"Pipo: empurre a pedra\naté a marca dourada")
	_sign(Vector2(1210,485),"Tico: pule a pedra\ne passe por baixo da árvore")
	_sign(Vector2(1870,560),"Pipo: AÇÃO ou E\npara investir na parede")
	_sign(Vector2(2650,565),"Snif, snif…\nPipo encontra segredos por perto")
	_sign(Vector2(3380,575),"Juntos até a chegada!")

func _solid(node_name: String, rect: Rect2, color: Color) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.name = node_name
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = rect.position + rect.size / 2
	var collision := CollisionShape2D.new()
	collision.name = "Collision"
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	body.add_child(collision)
	var art := Polygon2D.new()
	art.polygon = PackedVector2Array([-rect.size/2,Vector2(rect.size.x,-rect.size.y)/2,rect.size/2,Vector2(-rect.size.x,rect.size.y)/2])
	art.color = color
	body.add_child(art)
	actors.add_child(body)
	return body

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_character") and not event.is_echo():
		switch_character()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("action") and tico == squirrel:
		_say("Chame Pipo com Q ou Trocar para usar a força.")
	else:
		super._unhandled_input(event)

func switch_character() -> bool:
	if not is_instance_valid(pipo) or get_tree().paused or completed or respawning or _switch_left > 0:
		return false
	if not tico.is_on_floor() or (tico == pipo and pipo.ability != "ready"):
		_say("Pouse e termine a ação antes de trocar.")
		return false
	var next: CharacterBody2D = pipo if tico == squirrel else squirrel
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = next.get_node("Collision").shape
	query.collision_mask = 1
	query.exclude = [tico.get_rid(),next.get_rid()]
	var point: Vector2 = tico.global_position
	var fits: bool = false
	# O corpo de Pipo é mais largo: uma margem curta permite trocar junto à pedra.
	for shift in [0.0, -tico.facing * 12.0, tico.facing * 12.0]:
		point = tico.global_position + Vector2(shift,0)
		query.transform = Transform2D(0,point + next.get_node("Collision").position + Vector2(0,-0.5))
		if get_world_2d().direct_space_state.intersect_shape(query).is_empty():
			fits = true
			break
	if not fits:
		_say("Pipo precisa de mais espaço. Saia da passagem para trocar.")
		return false
	_activate(next,point)
	_switch_left = 0.25
	touch.release_all()
	_say("Pipo: empurre, invista e siga seu faro!" if tico == pipo else "Tico: pule, plane e passe por lugares estreitos!")
	sounds.play_notes([523,784] if tico == pipo else [784,1047],0.07)
	return true

func _deactivate(character: CharacterBody2D) -> void:
	character.controls_enabled = false
	character.set_physics_process(false)
	character.collision_layer = 0
	character.collision_mask = 0
	character.hide()

func _activate(next: CharacterBody2D, point: Vector2) -> void:
	var shared_health: int = tico.health
	var protection: float = tico.invulnerability_left
	var direction: float = tico.facing
	_deactivate(tico)
	tico = next
	tico.reset_at(point)
	tico.health = shared_health
	tico.invulnerability_left = protection
	tico.facing = direction
	tico.collision_layer = 2
	tico.collision_mask = 1
	tico.show()
	tico.set_physics_process(true)
	camera.target = tico
	camera.snap_to_target()
	_health_changed(tico.health)
	_update_layout()

func _on_ability(phase: String) -> void:
	if phase == "prepare":
		sounds.play_notes([196,262],0.07)
	elif phase == "charge":
		sounds.play_notes([330,440],0.06)
	elif phase == "recover":
		sounds.play_notes([165],0.09)

func _on_heavy_broken(block: Node2D) -> void:
	_feedback(block.position,"Força de Pipo!",Color("d2e69b"))
	sounds.play_notes([196,392,523],0.09)
	_say("A passagem está livre! Muito bem, Pipo.")
	for i in 8:
		var chip := Polygon2D.new()
		chip.polygon = PackedVector2Array([Vector2(-5,-4),Vector2(5,-4),Vector2(4,5),Vector2(-3,4)])
		chip.color = Color("aec1a1")
		chip.position = block.position + Vector2(0,-70)
		actors.add_child(chip)
		var tween := chip.create_tween().set_parallel(true)
		tween.tween_property(chip,"position",chip.position + Vector2((i-3.5)*22,-40 + (i%3)*30),0.45)
		tween.tween_property(chip,"modulate:a",0,0.45)
		tween.chain().tween_callback(chip.queue_free)

func _process(delta: float) -> void:
	super._process(delta)
	if not is_instance_valid(pipo):
		return
	switch_button.disabled = get_tree().paused or completed or respawning
	if get_tree().paused or completed or respawning:
		return
	_switch_left = maxf(0,_switch_left - delta)
	if is_instance_valid(stone) and not gate_open and stone.position.x >= 1110:
		gate_open = true
		gate.hide()
		gate.get_node("Collision").set_deferred("disabled",true)
		_feedback(stone.position,"Caminho aberto!")
		_say("Troque para Tico, pule a pedra e passe por baixo da árvore.")
		sounds.play_notes([523,659,784])
	if not is_instance_valid(secret):
		return
	pipo.sniffing = tico == pipo and not secret.taken and pipo.position.distance_to(secret.position) < 300
	secret.scent_visible = pipo.sniffing
	secret.scent_from = pipo.position + Vector2(pipo.facing * 25,-55)
	if pipo.sniffing and not _scent_announced:
		_scent_announced = true
		_say("Snif! Siga as partículas douradas até o segredo.")
		sounds.play_notes([659,784,659],0.06)
	if pipo.sniffing and not secret.revealed and pipo.position.distance_to(secret.position) < 90:
		secret.reveal()
		_feedback(secret.position,"Segredo encontrado!")
		sounds.play_notes([784,988,1175])
	if _message_time <= 0:
		status.text = "Pipo · AÇÃO/E: investir · Faro automático" if tico == pipo else "Tico · Segure PULO para planar · Q/Trocar: Pipo"

func _update_layout() -> void:
	super._update_layout()
	$Signs.hide()
	if not is_instance_valid(switch_button):
		return
	switch_button.text = "Trocar" if touch.touch_enabled else "Trocar (Q)"
	switch_button.custom_minimum_size.y = 88 if touch.touch_enabled else 44
	$Interface/HUD/TopBar/Title.text = "Pipo · Força" if tico == pipo else "Tico · Agilidade"
	touch.set_action_caption("INVESTIR" if tico == pipo else "AÇÃO")

func _on_exit(marker: Node2D) -> void:
	super._on_exit(marker)
	result_text.text = "Muito bem, Tico e Pipo!\nJuntos até a chegada\nNozes: %d de %d" % [nuts,total_nuts]

func _respawn() -> void:
	_switch_left = 0
	if tico == pipo:
		pipo.cancel_ability()
	super._respawn()

func restart() -> void:
	if not is_instance_valid(pipo):
		super.restart()
		return
	_activate(squirrel,$PlayerSpawn.position)
	pipo.cancel_ability()
	pipo.sniffing = false
	_switch_left = 0
	_scent_announced = false
	gate_open = false
	gate.show()
	gate.get_node("Collision").set_deferred("disabled",false)
	stone.reset_puzzle()
	heavy.reset_puzzle()
	super.restart()
	_update_layout()
	_say("Dois amigos, uma aventura! Q ou Trocar para chamar Pipo.")

func _test_details() -> Dictionary:
	var details := super._test_details()
	details.merge({"character":"Pipo" if tico == pipo else "Tico", "gate_open":gate_open,
		"stone_x":stone.position.x if is_instance_valid(stone) else 850,
		"heavy_broken":is_instance_valid(heavy) and heavy.destroyed,
		"secret_revealed":is_instance_valid(secret) and secret.revealed,
		"ability":pipo.ability if is_instance_valid(pipo) else "ready",
		"grounded":tico.is_on_floor()})
	if is_instance_valid(switch_button):
		var rect := switch_button.get_global_rect()
		details["switch_rect"] = [rect.position.x,rect.position.y,rect.size.x,rect.size.y]
	return details
