extends "res://scripts/systems/world_campaign.gd"
var legacy_path := "user://world1.json"
@export_range(1,99) var initial_lives := 3
@export var extra_life_stages: Array[int] = [0,4,8,12]
const WORLD_NAMES = ["Bosque das Folhas","Rio das Pedras","Montanha das Corujas","Vila dos Castores"]
var lives_label: Label
var return_layer: CanvasLayer
var return_button: Button
var destination: OptionButton

func fresh() -> Dictionary:
	var result := super.fresh()
	result.survival = _new_survival()
	return result

func _new_survival() -> Dictionary:
	return {"lives":initial_lives,"pending_return":false,"return_stage":0,"replay":false,"pipo_unlocked":false,"claimed":[]}

func _restore_level(state: Dictionary) -> void:
	if not data.has("survival"):
		data.survival = _new_survival()
		for previous in data.levels.values():
			if previous.rescued: data.survival.pipo_unlocked = true
	for i in data.survival.claimed.size(): data.survival.claimed[i] = int(data.survival.claimed[i])
	var restored: Dictionary = (level.world_snapshot() if state.is_empty() else state).duplicate(true)
	if data.survival.pipo_unlocked: restored.rescued = true
	if data.survival.replay: restored.completed = false
	level.restore_world(restored)

func _capture_level() -> Dictionary:
	var snapshot: Dictionary = level.world_snapshot()
	if snapshot.rescued: data.survival.pipo_unlocked = true
	if level.completed: data.survival.replay = false
	# Conclusão permanente e tentativa atual são estados diferentes.
	if data.levels.get(str(data.stage),{}).get("completed",false): snapshot.completed = true
	return snapshot

func _load_stage(index: int) -> void:
	if is_instance_valid(return_layer): return_layer.queue_free()
	return_layer = null
	super._load_stage(index)
	lives_label = Label.new()
	lives_label.position = Vector2(375,0)
	lives_label.add_theme_font_size_override("font_size",26)
	lives_label.add_theme_color_override("font_color",Color("244b37"))
	level.hearts.add_child(lives_label)
	level.save_label.position.x = 515
	_refresh_lives()
	if index in extra_life_stages and index not in data.survival.claimed:
		var pickup := preload("res://scripts/objects/extra_life.gd").new()
		pickup.campaign = self
		pickup.stage_id = index
		pickup.position = Vector2(450,660)
		level.actors.add_child(pickup)
	if awaiting_return(): show_return.call_deferred()

func _refresh_lives() -> void:
	if is_instance_valid(lives_label): lives_label.text = "Vidas: %02d" % int(data.survival.lives)

func awaiting_return() -> bool:
	return data.get("survival",{}).get("pending_return",false)

func lose_life() -> void:
	if awaiting_return(): return
	data.survival.lives -= 1
	if data.survival.lives<=0:
		data.survival.pending_return = true
		data.survival.return_stage = maxi(0,(int(data.stage)/4-1)*4)
		data.survival.lives = initial_lives
		level._say("Fim das vidas. Vamos descansar e voltar ao mundo anterior.")
	else:
		level._say("Vamos tentar de novo! Vidas restantes: %d" % int(data.survival.lives))
	_refresh_lives()
	save_progress()

func claim_life(stage_id: int) -> bool:
	if awaiting_return() or stage_id!=int(data.stage) or stage_id not in extra_life_stages or stage_id in data.survival.claimed or data.survival.lives>=99: return false
	data.survival.claimed.append(stage_id)
	data.survival.lives += 1
	_refresh_lives()
	save_progress()
	level._say("Uma vida extra para os dois amigos!")
	level.sounds.play_notes([523,659,784,1047])
	return true

func show_return() -> void:
	if not awaiting_return() or is_instance_valid(return_layer): return
	get_tree().paused = true
	level.touch.set_controls_active(false)
	for action in ["move_left","move_right","jump","action","switch_character"]: Input.action_release(action)
	return_layer = CanvasLayer.new()
	return_layer.layer = 20
	return_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(return_layer)
	var shade := ColorRect.new()
	shade.color = Color(0.06,0.13,0.10,0.94)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return_layer.add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return_layer.add_child(center)
	var column := VBoxContainer.new()
	column.custom_minimum_size.x = 600
	column.add_theme_constant_override("separation",22)
	center.add_child(column)
	var title := Label.new()
	title.text = "Fim das vidas — vamos tentar de novo!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size",30)
	column.add_child(title)
	var message := Label.new()
	message.text = "Retorno ao %s\n%d vidas renovadas • Conquistas e amigos preservados" % [WORLD_NAMES[int(data.survival.return_stage)/4],initial_lives]
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(message)
	destination = OptionButton.new()
	destination.custom_minimum_size.y = 56
	column.add_child(destination)
	for index in int(data.unlocked)+1:
		destination.add_item("Fase %d-%d • %s" % [index/4+1,index%4+1,WORLD_NAMES[index/4]],index)
	destination.select(int(data.survival.return_stage))
	return_button = Button.new()
	return_button.text = "Voltar à aventura"
	return_button.custom_minimum_size.y = 62
	column.add_child(return_button)
	return_button.pressed.connect(_choose_return)
	return_button.grab_focus()

func _choose_return() -> void:
	resume_at(destination.get_selected_id())

func resume_at(index: int) -> void:
	if _changing or not awaiting_return() or index<0 or index>int(data.unlocked): return
	_changing = true
	if is_instance_valid(return_button): return_button.disabled = true
	data.survival.pending_return = false
	data.survival.replay = true
	# Guarda a tentativa no início sem apagar a conclusão e recompensas anteriores.
	if data.levels.has(str(index)): data.levels[str(index)].checkpoint = false
	_load_stage.call_deferred(index)

func advance() -> void:
	if _changing or not level.completed or data.stage>=scene_paths.size()-1: return
	save_progress()
	data.survival.replay = data.levels.get(str(int(data.stage)+1),{}).get("completed",false)
	_changing = true
	_load_stage.call_deferred(int(data.stage)+1)

func survival_details() -> Dictionary:
	var details := {"lives":data.survival.lives,"game_over":awaiting_return(),"return_stage":data.survival.return_stage,"pipo_unlocked":data.survival.pipo_unlocked}
	if is_instance_valid(return_button):
		var rect := return_button.get_global_rect()
		details.return_rect = [rect.position.x,rect.position.y,rect.size.x,rect.size.y]
	return details

func _init() -> void:
	store = preload("res://scripts/systems/expedition_save.gd").new()
	for world in range(2,5):
		for section in ["1","2","3","guardian"]:
			scene_paths.append("res://scenes/levels/world_%d_%s.tscn" % [world,section])

func _read_progress() -> Dictionary:
	var saved: Dictionary = store.read_save() if save_enabled else {}
	if not saved.is_empty(): return saved
	if save_enabled and store.state=="empty":
		var legacy = preload("res://scripts/systems/world_save.gd").new()
		legacy.path = legacy_path
		var previous: Dictionary = legacy.read_save()
		if not previous.is_empty():
			previous = previous.duplicate(true)
			if previous.finished: previous.unlocked = 4
			previous.finished = false
			return previous
	# Não substitui campanha danificada por uma cópia antiga.
	var result := fresh()
	if save_enabled and store.state=="empty":
		var prototype: Dictionary = preload("res://scripts/systems/save_manager.gd").new().read_save()
		if prototype.has("settings"): result.settings = prototype.settings.duplicate()
	return result
