extends "res://scripts/systems/coop_level.gd"
const SAVE = preload("res://scripts/systems/save_manager.gd")
var save_store = SAVE.new()
var save_enabled := true
var save_label: Label
var restart_dialog: ConfirmationDialog
var _loaded := false
var _last_save := ""
var _save_clock := 0.0
var _was_paused := false
var resumed := false

func _build_gameplay() -> void:
	super._build_gameplay()
	# A bandeira fica depois da cooperação; a chegada exige subir as plataformas.
	checkpoint.position = Vector2(3020,760)
	exit_marker.position = Vector2(3710,550)
	for i in 3:
		var block = BLOCK.instantiate()
		block.kind = i
		block.position = Vector2(620 + i * 70,610)
		actors.add_child(block)
		block.opened.connect(_on_block)
	total_nuts += 1
	for i in 3:
		var x := 3260 + i * 160
		var y := 690 - i * 70
		_solid("FinalStep%d" % i,Rect2(x,y,180,760-y),Color("77985d"))
		var item = NUT.instantiate()
		item.position = Vector2(x+(30 if i == 2 else 80),y-42)
		actors.add_child(item)
		item.collected.connect(_on_collected)
		total_nuts += 1
	var recovery = NUT.instantiate()
	recovery.healing = true
	recovery.position = Vector2(2950,718)
	actors.add_child(recovery)
	recovery.collected.connect(_on_collected)
	# Identidade independente dos nomes automáticos de nós da Godot.
	for actor in actors.get_children():
		if actor.has_method("reset_item") or actor.has_method("reset_block"):
			actor.set_meta("save_id", "%d:%d" % [actor.position.x,actor.position.y])
	_sign(Vector2(580,490),"Pule")
	_sign(Vector2(2970,560),"Bandeira")

func _sign(point: Vector2, text: String) -> void:
	# Pistas curtas: os objetos e as nozes indicam o caminho.
	var hints := {130:"Siga as nozes",690:"Pipo • Pedra",1210:"Tico • Passagem",1870:"Pipo • INVESTIR",2650:"Snif, snif…",3380:"Até a árvore"}
	if int(point.x) == 690:
		point.y = 530
	elif int(point.x) == 3380:
		point.y = 410
	super._sign(point,hints.get(int(point.x),text))

func _ready() -> void:
	super._ready()
	save_label = Label.new()
	save_label.position = Vector2(380,4)
	save_label.add_theme_font_size_override("font_size",18)
	save_label.add_theme_color_override("font_color",Color("355643"))
	hearts.add_child(save_label)
	restart_dialog = ConfirmationDialog.new()
	restart_dialog.title = "Nova aventura"
	restart_dialog.dialog_text = "Recomeçar e substituir o progresso salvo?"
	restart_dialog.ok_button_text = "Recomeçar"
	restart_dialog.cancel_button_text = "Continuar aventura"
	restart_dialog.get_ok_button().custom_minimum_size = Vector2(160,88)
	restart_dialog.get_cancel_button().custom_minimum_size = Vector2(240,88)
	restart_dialog.confirmed.connect(new_adventure)
	restart_dialog.canceled.connect(func(): set_paused(_was_paused))
	add_child(restart_dialog)
	if save_enabled:
		var data: Dictionary = save_store.read_save()
		if not data.is_empty():
			_restore(data)
	_loaded = true
	_save_progress()
	_say("Aventura retomada no ponto seguro!" if resumed else "Siga as nozes até a árvore!")

func _snapshot() -> Dictionary:
	var items: Array = []
	var blocks: Array = []
	for actor in actors.get_children():
		if actor.has_meta("save_id"):
			if actor.has_method("reset_item") and actor.taken:
				items.append(actor.get_meta("save_id"))
			elif actor.has_method("reset_block") and actor.used:
				blocks.append(actor.get_meta("save_id"))
	return {"save_version":SAVE.VERSION,"level":"prototype_1",
		"character":"Pipo" if tico == pipo else "Tico", "items":items,"blocks":blocks,
		"stone":clampf(stone.position.x,850,1190),"gate":gate_open,"heavy":heavy.destroyed,
		"secret":secret.revealed,"checkpoint":checkpoint_active,"completed":completed}

func _restore(data: Dictionary) -> void:
	gate_open = data.gate
	gate.visible = not gate_open
	gate.get_node("Collision").set_deferred("disabled",gate_open)
	stone.position.x = data.stone
	stone.force_update_transform()
	heavy.destroyed = data.heavy
	heavy.visible = not heavy.destroyed
	heavy.get_node("Collision").set_deferred("disabled",heavy.destroyed)
	secret.revealed = data.secret
	checkpoint_active = data.checkpoint
	checkpoint.activated = checkpoint_active
	checkpoint.queue_redraw()
	checkpoint_position = checkpoint.position + Vector2(0,-5) if checkpoint_active else $PlayerSpawn.position
	nuts = 0
	for actor in actors.get_children():
		if not actor.has_meta("save_id"):
			continue
		var id: String = actor.get_meta("save_id")
		if actor.has_method("reset_item") and id in data.items:
			actor.taken = true
			actor.hide()
			if not actor.healing:
				nuts += 1
		elif actor.has_method("reset_block") and id in data.blocks and actor.kind > 0:
			actor.used = true
			if actor.kind == 1:
				actor.hide()
				actor.get_node("Collision").set_deferred("disabled",true)
			else:
				nuts += 1
			actor.queue_redraw()
	_activate(pipo if data.character == "Pipo" else squirrel,checkpoint_position)
	tico.restore_health()
	resumed = true
	if data.completed:
		tico.reset_at(exit_marker.position)
		camera.snap_to_target()
		exit_marker.activated = true
		_on_exit(exit_marker)

func _save_progress() -> void:
	if not _loaded or not save_enabled:
		return
	var data := _snapshot()
	var encoded := JSON.stringify(data)
	if encoded != _last_save and save_store.write_save(data):
		_last_save = encoded
	save_label.text = "Progresso salvo • Retorno na bandeira" if checkpoint_active else "Progresso salvo • Retorno no início"
	if save_store.locked:
		save_label.text = "Progresso não reconhecido • Recomeçar cria outro"
	elif save_store.state == "unavailable":
		save_label.text = "Não foi possível salvar neste dispositivo"

func _process(delta: float) -> void:
	var was_open := gate_open
	var was_revealed: bool = is_instance_valid(secret) and secret.revealed
	super._process(delta)
	if was_open != gate_open or (is_instance_valid(secret) and was_revealed != secret.revealed):
		_save_progress()
	_save_clock += delta
	if _save_clock >= 0.5:
		_save_clock = 0
		_save_progress()

func switch_character() -> bool:
	var changed := super.switch_character()
	if changed:
		_save_progress()
	return changed

func _on_collected(item: Node2D) -> void:
	super._on_collected(item)
	_save_progress()

func _on_block(block: Node2D, reward: bool) -> void:
	super._on_block(block,reward)
	_save_progress()

func _on_checkpoint(marker: Node2D) -> void:
	super._on_checkpoint(marker)
	_save_progress()

func _on_heavy_broken(block: Node2D) -> void:
	super._on_heavy_broken(block)
	_save_progress()

func _on_exit(marker: Node2D) -> void:
	super._on_exit(marker)
	_save_progress()

func set_paused(value: bool) -> void:
	if is_instance_valid(restart_dialog) and restart_dialog.visible and not value:
		return
	super.set_paused(value)
	if value:
		_save_progress()

func restart() -> void:
	if not _loaded:
		super.restart()
		return
	_was_paused = get_tree().paused
	set_paused(true)
	restart_dialog.popup_centered(Vector2i(540,240))

func new_adventure() -> void:
	restart_dialog.hide()
	_loaded = false
	super.restart()
	save_store.locked = false
	_last_save = ""
	resumed = false
	_loaded = true
	_save_progress()

func _test_details() -> Dictionary:
	var details := super._test_details()
	details.merge({"stage":6,"resumed":resumed,"save_state":save_store.state,
		"restart_confirmation":is_instance_valid(restart_dialog) and restart_dialog.visible})
	if is_instance_valid(restart_dialog) and restart_dialog.visible:
		for entry in [["confirm_rect",restart_dialog.get_ok_button()],["cancel_rect",restart_dialog.get_cancel_button()]]:
			var rect: Rect2 = entry[1].get_global_rect()
			var point := rect.position + Vector2(restart_dialog.position)
			details[entry[0]] = [point.x,point.y,rect.size.x,rect.size.y]
	return details
