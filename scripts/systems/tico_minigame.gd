extends "res://scripts/systems/tico_playground.gd"

const NUT = preload("res://scenes/objects/nut.tscn")
const BLOCK = preload("res://scenes/objects/block.tscn")
const SLUG = preload("res://scenes/enemies/slug.tscn")
const CHECKPOINT = preload("res://scenes/objects/checkpoint.tscn")
const EXIT = preload("res://scenes/objects/level_exit.tscn")
const HEARTS = preload("res://scripts/ui/health_hud.gd")
const SOUNDS = preload("res://scripts/systems/game_sounds.gd")

var nuts: int = 0
var total_nuts: int = 0
var checkpoint_position := Vector2(160,700)
var checkpoint_active: bool = false
var completed: bool = false
var respawning: bool = false
var _transition: float = 0.0
var _message: String = "Explore e siga até a árvore no fim do caminho."
var _message_time: float = 5.0
var actors: Node2D
var hearts: Control
var counter: Label
var result_panel: PanelContainer
var result_text: Label
var sounds: Node
var checkpoint: Area2D
var exit_marker: Area2D

func _ready() -> void:
	super._ready()
	actors = Node2D.new()
	actors.name = "Gameplay"
	actors.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(actors)
	sounds = Node.new()
	sounds.set_script(SOUNDS)
	actors.add_child(sounds)
	_build_hud()
	_build_gameplay()
	tico.health_changed.connect(_health_changed)
	tico.hurt.connect(_on_hurt)
	tico.defeated.connect(_on_defeat)
	$Interface/HUD/TopBar/Title.text = "Trilha das Nozes"
	_update_layout()
	_health_changed(tico.health)

func _build_gameplay() -> void:
	for point in [Vector2(330,710),Vector2(430,600),Vector2(620,710),Vector2(700,490),Vector2(980,380),Vector2(1280,290),Vector2(1510,400),Vector2(1720,410),Vector2(1930,340),Vector2(2200,710),Vector2(2660,710),Vector2(2920,710),Vector2(3200,710)]:
		var item = NUT.instantiate()
		item.position = point
		actors.add_child(item)
		item.collected.connect(_on_collected)
		total_nuts += 1
	var recovery = NUT.instantiate()
	recovery.name = "Recovery"
	recovery.healing = true
	recovery.position = Vector2(1770,720)
	actors.add_child(recovery)
	recovery.collected.connect(_on_collected)
	for i in 3:
		var block = BLOCK.instantiate()
		block.name = ["CommonBlock", "BreakableBlock", "NutBlock"][i]
		block.kind = i
		block.position = Vector2(1040 + i * 100, 615)
		actors.add_child(block)
		block.opened.connect(_on_block)
	total_nuts += 1
	for point in [Vector2(800,760),Vector2(2490,760),Vector2(3060,760)]:
		var slug = SLUG.instantiate()
		slug.position = point
		actors.add_child(slug)
		slug.stomped.connect(_on_stomp)
	checkpoint = CHECKPOINT.instantiate()
	checkpoint.position = Vector2(2020,760)
	actors.add_child(checkpoint)
	checkpoint.reached.connect(_on_checkpoint)
	exit_marker = EXIT.instantiate()
	exit_marker.position = Vector2(3560,760)
	actors.add_child(exit_marker)
	exit_marker.reached.connect(_on_exit)
	_sign(Vector2(610,655), "Pule sobre a lesma\nou passe por cima!")
	_sign(Vector2(1010,530), "Bata por baixo dos blocos")
	_sign(Vector2(1620,645), "Um coração para recuperar")
	_sign(Vector2(1930,590), "Bandeira: ponto de retorno")
	_sign(Vector2(3370,590), "Chegada!\nEntre na árvore")

func _sign(point: Vector2, text: String) -> void:
	var label := Label.new()
	label.position = point
	label.text = text
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color("355643"))
	actors.add_child(label)

func _build_hud() -> void:
	hearts = Control.new()
	hearts.set_script(HEARTS)
	hearts.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Interface/HUD.add_child(hearts)
	counter = Label.new()
	counter.position = Vector2(155,0)
	counter.add_theme_font_size_override("font_size", 26)
	counter.add_theme_color_override("font_color", Color("244b37"))
	hearts.add_child(counter)
	result_panel = PanelContainer.new()
	result_panel.visible = false
	$Interface/HUD.add_child(result_panel)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fff3d9")
	style.set_corner_radius_all(22)
	style.content_margin_left = 30
	style.content_margin_right = 30
	style.content_margin_top = 25
	style.content_margin_bottom = 25
	result_panel.add_theme_stylebox_override("panel", style)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 20)
	result_panel.add_child(column)
	result_text = Label.new()
	result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_text.add_theme_font_size_override("font_size", 30)
	result_text.add_theme_color_override("font_color", Color("244b37"))
	column.add_child(result_text)
	var again := Button.new()
	again.text = "Jogar de novo"
	again.custom_minimum_size.y = 88
	again.pressed.connect(restart)
	column.add_child(again)

func _update_layout() -> void:
	super._update_layout()
	if not is_instance_valid(hearts):
		return
	$Interface/HUD/Instructions.hide()
	hearts.position = Vector2(32 + touch.safe_insets().x, $Interface/HUD/TopBar.offset_bottom + 8)
	status.offset_top = hearts.position.y + 45
	$Interface/HUD/Backdrop.offset_bottom = status.offset_top + 36
	result_panel.size = Vector2(560,260)
	result_panel.position = (get_viewport_rect().size - result_panel.size) / 2
	touch.set_controls_active(not get_tree().paused and not completed and not respawning)
	$Signs/Walk.text = "Siga as nozes!\nExplore os dois caminhos."
	$Signs/Safe.hide()
	$Signs/End.hide()

func _process(delta: float) -> void:
	super._process(delta)
	if not is_instance_valid(hearts):
		return
	counter.text = "Nozes: %02d / %02d" % [nuts,total_nuts]
	if get_tree().paused:
		return
	_message_time = maxf(0, _message_time - delta)
	status.text = _message if _message_time > 0 else ("Bandeira ativada · Siga até a chegada" if checkpoint_active else "Explore · Colete nozes · Encontre a bandeira")
	if respawning:
		_transition += delta
		tico.sprite.rotation = sin(_transition * 12) * 0.15
		tico.sprite.modulate.a = maxf(0.2, 1.0 - _transition)
		if _transition >= 1.0:
			_respawn()
	elif completed:
		_transition += delta
		tico.sprite.position.y = -40 - absf(sin(minf(_transition, 0.8) / 0.8 * PI)) * 25
		if _transition >= 0.8:
			result_panel.show()

func _health_changed(value: int) -> void:
	hearts.health = value
	hearts.queue_redraw()

func _say(message: String) -> void:
	_message = message
	_message_time = 3.0

func _feedback(point: Vector2, text: String, color: Color = Color("fff3d9")) -> void:
	var label := Label.new()
	label.text = text
	label.position = point + Vector2(-30,-65)
	label.add_theme_font_size_override("font_size", 26)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color("355643"))
	label.add_theme_constant_override("outline_size", 5)
	actors.add_child(label)
	var tween := label.create_tween().set_parallel(true)
	tween.tween_property(label,"position:y",label.position.y - 55,0.65)
	tween.tween_property(label,"modulate:a",0.0,0.65)
	tween.chain().tween_callback(label.queue_free)

func _on_collected(item: Node2D) -> void:
	if item.healing:
		_feedback(item.position,"+1 vida" if item.life_reward else "+1 coração")
		sounds.play_notes([523,659,784])
		_say("Saúde cheia! Uma vida extra." if item.life_reward else "Um coração recuperado!")
	else:
		nuts += 1
		_feedback(item.position,"+1 noz")
		sounds.play_notes([880,1175])

func _on_block(block: Node2D, reward: bool) -> void:
	if reward:
		nuts += 1
		_feedback(block.position,"+1 noz")
		sounds.play_notes([880,1175])
	else:
		_feedback(block.position,"Folhas ao vento!",Color("bde29d"))
		sounds.play_notes([220,330],0.06)

func _on_stomp(enemy: Node2D) -> void:
	_feedback(enemy.position,"Até logo!",Color("f7dc91"))
	sounds.play_notes([392,523],0.1)

func _on_hurt() -> void:
	_say("Tudo bem! Você está protegido por um instante.")
	sounds.play_notes([262,196],0.08)

func _on_defeat() -> void:
	respawning = true
	_transition = 0
	touch.set_controls_active(false)
	touch.release_all()
	for action in ["move_left","move_right","jump","action","switch_character"]: Input.action_release(action)
	_say("Vamos tentar de novo! Voltando ao ponto seguro…")

func _respawn() -> void:
	respawning = false
	_restore_returning_player()
	for actor in actors.get_children():
		if actor.has_method("reset_enemy"):
			actor.reset_enemy()
	camera.snap_to_target()
	touch.set_controls_active(true)
	_say("De volta à bandeira!" if checkpoint_active else "Vamos de novo! Você consegue.")

func _restore_returning_player() -> void:
	tico.reset_at(checkpoint_position)
	tico.sprite.rotation = 0
	tico.sprite.modulate.a = 1
	tico.restore_health()
	tico.invulnerability_left = tico.invulnerability_duration

func _on_checkpoint(marker: Node2D) -> void:
	checkpoint_active = true
	checkpoint_position = marker.position + Vector2(0,-5)
	tico.recover(tico.max_health)
	_feedback(marker.position,"Ponto seguro!")
	_say("Bandeira ativada! Você volta para cá se precisar.")
	sounds.play_notes([523,659,784,1047])

func _on_exit(_marker: Node2D) -> void:
	completed = true
	_transition = 0
	tico.controls_enabled = false
	tico.velocity = Vector2.ZERO
	tico.sprite.play("idle")
	touch.set_controls_active(false)
	for actor in actors.get_children():
		if actor.is_in_group("enemies"):
			actor.set_physics_process(false)
	result_text.text = "Muito bem, Tico!\nTrilha concluída\nNozes: %d de %d" % [nuts,total_nuts]
	_say("Você chegou! Hora de comemorar!")
	sounds.play_notes([523,659,784,1047],0.16)

func set_paused(value: bool) -> void:
	super.set_paused(value)
	if completed or respawning:
		touch.set_controls_active(false)

func restart() -> void:
	if not is_instance_valid(actors):
		super.restart()
		return
	completed = false
	respawning = false
	nuts = 0
	checkpoint_active = false
	checkpoint_position = $PlayerSpawn.position
	result_panel.hide()
	for actor in actors.get_children():
		for method in ["reset_enemy", "reset_item", "reset_block", "reset_marker"]:
			if actor.has_method(method):
				actor.call(method)
		if actor.is_in_group("enemies"):
			actor.set_physics_process(true)
	tico.sprite.rotation = 0
	tico.sprite.position.y = -40
	tico.invulnerability_left = 0
	tico.restore_health()
	super.restart()
	_say("Uma nova aventura! Siga as nozes.")

func _test_details() -> Dictionary:
	return {"health": tico.health, "nuts": nuts, "total_nuts": total_nuts,
		"checkpoint": checkpoint_active, "completed": completed, "respawning": respawning,
		"return_position": [checkpoint_position.x,checkpoint_position.y],
		"hud_width": $Interface/HUD.size.x, "bar_width": $Interface/HUD/TopBar.size.x,
		"result": is_instance_valid(result_panel) and result_panel.visible}
