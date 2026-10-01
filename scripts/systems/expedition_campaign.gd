extends "res://scripts/systems/world_campaign.gd"
var legacy_path := "user://world1.json"
@export_range(1,99) var initial_lives := 3
@export var extra_life_stages: Array[int] = [0,4,8,12]
const WORLD_NAMES = ["Bosque das Folhas","Rio das Pedras","Montanha das Corujas","Vila dos Castores"]
var lives_label: Label
var return_layer: CanvasLayer
var return_button: Button
@export var start_on_map := true
var world_map: Control
var map_button: Button
var _map_after_load := false

func _ready() -> void:
	super._ready()
	if start_on_map: show_map()

func map_is_open() -> bool:
	return is_instance_valid(world_map)

func show_map() -> void:
	if _changing or map_is_open() or not is_instance_valid(level): return
	if level.respawning and not awaiting_return(): return
	save_progress()
	get_tree().paused = true
	level._apply_audio()
	level.touch.release_all()
	level.touch.set_controls_active(false)
	for action in ["move_left","move_right","jump","action","switch_character"]: Input.action_release(action)
	level.get_node("Interface").hide()
	level.hide()
	return_layer = CanvasLayer.new()
	return_layer.layer = 25
	return_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(return_layer)
	world_map = preload("res://scripts/ui/world_map.gd").new()
	world_map.campaign = self
	return_layer.add_child(world_map)
	return_button = world_map.primary if awaiting_return() else null

func _remove_map() -> void:
	if is_instance_valid(return_layer):
		remove_child(return_layer)
		return_layer.queue_free()
	return_layer = null
	world_map = null
	return_button = null

func close_map() -> void:
	if not map_is_open() or awaiting_return() or _map_portrait(): return
	_remove_map()
	level.show()
	level.get_node("Interface").show()
	level.set_paused(false)

func enter_from_map(index: int) -> void:
	if not map_is_open() or _changing or index<0 or index>int(data.unlocked) or _map_portrait(): return
	if awaiting_return():
		resume_at(index)
		return
	if index==int(data.stage) and not level.completed:
		close_map()
		return
	_changing = true
	data.survival.replay = data.levels.get(str(index),{}).get("completed",false)
	if data.survival.replay: data.levels[str(index)].checkpoint = false
	_load_stage.call_deferred(index)

func _map_portrait() -> bool:
	# O aviso HTML muda antes de a Godot receber o novo tamanho do canvas.
	if OS.has_feature("web") and level.touch.touch_enabled:
		return bool(JavaScriptBridge.eval("window.innerHeight > window.innerWidth"))
	return level.touch.is_portrait()

func new_adventure() -> void:
	_map_after_load = start_on_map
	super.new_adventure()

func fresh() -> Dictionary:
	var result := super.fresh()
	result.survival = _new_survival()
	result.tutorials = {}
	result.context_hints_seen = []
	for key in preload("res://scripts/ui/contextual_help.gd").KEYS: result.tutorials[key] = false
	return store.migrate(result)

func _new_survival() -> Dictionary:
	return {"lives":initial_lives,"pending_return":false,"return_stage":0,"replay":false,"pipo_unlocked":false,"claimed":[]}

func _prepare_save() -> void:
	store.sync_story(data)

## Consulta derivada: evita cópias divergentes de desbloqueios e conclusões no save.
func progress_summary() -> Dictionary:
	var unlocked: Array = []
	var completed: Array = []
	var stages := {}
	for index in scene_paths.size():
		var id := str(index)
		var snapshot: Dictionary = data.levels.get(id,{})
		var done: bool = snapshot.get("completed",false)
		if index<=int(data.unlocked): unlocked.append(index)
		if done: completed.append(index)
		stages[id] = {"available":index<=int(data.unlocked),"current":index==int(data.stage),"completed":done,
			"items":snapshot.get("items",[]).duplicate(),"blocks":snapshot.get("blocks",[]).duplicate(),
			"secret":snapshot.get("secret",false),"golden_nuts":data.collectibles.golden_nuts.get(id,[]).duplicate()}
	return {"current":int(data.stage),"unlocked":unlocked,"completed":completed,"levels":stages,
		"characters":["Tico","Pipo"] if data.survival.pipo_unlocked else ["Tico"],
		"story":data.story.duplicate(true),"tutorials":data.tutorials.duplicate(true),"settings":data.settings.duplicate(true)}

## IDs estáveis por fase. A criação dos objetos e das recompensas pertence às etapas de conteúdo.
func record_golden_nut(id: String) -> bool:
	if not store.valid_id(id): return false
	var stage_id := str(int(data.stage))
	var collected: Array = data.collectibles.golden_nuts.get(stage_id,[])
	if id in collected or collected.size()>=64: return false
	collected.append(id)
	data.collectibles.golden_nuts[stage_id] = collected
	save_progress()
	return true

func record_story_event(id: String) -> bool:
	if not store.valid_id(id) or id in data.story.events or data.story.events.size()>=200: return false
	data.story.events.append(id)
	save_progress()
	return true

func set_village_flag(id: String, value: bool) -> bool:
	if not store.valid_id(id): return false
	if not data.story.village.has(id) and data.story.village.size()>=64: return false
	if data.story.village.get(id)==value: return false
	data.story.village[id] = value
	save_progress()
	return true

func _restore_level(state: Dictionary) -> void:
	if not data.has("tutorials"): data.tutorials = {}
	if not data.has("context_hints_seen"): data.context_hints_seen = []
	for key in preload("res://scripts/ui/contextual_help.gd").KEYS:
		if not data.tutorials.has(key): data.tutorials[key] = false
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
	_remove_map()
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
	level.contextual_help = preload("res://scripts/ui/contextual_help.gd").new()
	level.contextual_help.level = level
	level.add_child(level.contextual_help)
	map_button = level._menu_button("Mapa da jornada",level.pause_panel.get_child(0))
	map_button.pressed.connect(show_map)
	var result_map: Button = level._menu_button("Mapa da jornada",level.result_panel.get_child(0))
	result_map.pressed.connect(show_map)
	level._update_layout()
	if awaiting_return(): show_return.call_deferred()
	elif _map_after_load:
		_map_after_load = false
		show_map()

func mark_hint_seen(id: String) -> void:
	if id in preload("res://scripts/ui/contextual_help.gd").KEYS:
		data.tutorials[id] = true
	elif id not in data.context_hints_seen:
		data.context_hints_seen.append(id)
	save_progress()

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
	if awaiting_return(): show_map()

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

func restart_stage() -> void:
	if _changing or awaiting_return() or level.respawning: return
	_changing = true
	_restart_stage.call_deferred()

func _restart_stage() -> void:
	save_progress()
	# Recomeça a tentativa, mantendo o registro permanente da fase.
	data.levels[str(int(data.stage))].checkpoint = false
	data.survival.replay = true
	_load_stage(int(data.stage))

func survival_details() -> Dictionary:
	var details := {"lives":data.survival.lives,"game_over":awaiting_return(),"return_stage":data.survival.return_stage,"pipo_unlocked":data.survival.pipo_unlocked}
	details.map_open = map_is_open()
	if map_is_open(): details.merge(world_map.details())
	if is_instance_valid(map_button):
		var r := map_button.get_global_rect()
		details.map_menu_rect = [r.position.x,r.position.y,r.size.x,r.size.y]
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
			return store.migrate(previous)
	# Não substitui campanha danificada por uma cópia antiga.
	var result := fresh()
	if save_enabled and store.state=="empty":
		var prototype: Dictionary = preload("res://scripts/systems/save_manager.gd").new().read_save()
		if prototype.has("settings"): result.settings = prototype.settings.duplicate()
	return result
