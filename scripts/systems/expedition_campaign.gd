extends "res://scripts/systems/world_campaign.gd"
const BALANCE = preload("res://scripts/systems/game_balance.gd")
var legacy_path := "user://world1.json"
@export_range(1,99) var initial_lives := BALANCE.INITIAL_LIVES
@export var extra_life_stages: Array[int] = [0,4,8,12]
const WORLD_NAMES = ["Bosque das Folhas","Rio das Pedras","Montanha das Corujas","Vila dos Castores"]
var lives_label: Label
var nut_progress: Label
const NUTS_PER_LIFE := BALANCE.NUTS_PER_LIFE
var return_layer: CanvasLayer
var return_button: Button
@export var start_on_map := true
var world_map: Control
var map_button: Button
var _map_after_load := false
var _unlocked_stage := -1
var narrative: CanvasLayer
var _opening_after_load := false
var _map_after_narrative := false

func save_progress() -> void:
	var previous := int(data.get("unlocked",0))
	super.save_progress()
	if int(data.get("unlocked",0))>previous:
		_unlocked_stage = int(data.unlocked)
	if is_instance_valid(level) and level.completed:
		_present_result.call_deferred()

func _present_result() -> void:
	if not is_instance_valid(level) or not level.completed: return
	var snapshot: Dictionary = data.levels.get(str(int(data.stage)),{})
	var golden: Array = data.collectibles.golden_nuts.get(str(int(data.stage)),[])
	var title: String = preload("res://scripts/ui/world_map.gd").NAMES[int(data.stage)]
	var message := "Trilha concluída!"
	if data.finished and int(data.stage)==scene_paths.size()-1: message = "Todas as trilhas desta aventura concluídas!"
	level.result_text.add_theme_font_size_override("font_size",25)
	level.result_text.text = "%s\n%s\n\nNozes: %d / %d   •   Vidas: %d\nAlimentos: %d / %d   •   Nozes Douradas: %d\n%s" % [title,message,level.nuts,level.total_nuts,int(data.survival.lives),level.foods,level.total_foods,golden.size(),"Segredo encontrado!" if snapshot.get("secret",false) else "Você pode voltar para explorar mais."]
	level.result_panel.custom_minimum_size = Vector2(700,360)
	level.next_button.text = "Voltar ao mapa"
	if save_enabled and store.state!="saved":
		level.result_text.text += "\nProgresso nesta sessão • Salvamento indisponível"

func _ready() -> void:
	super._ready()
	narrative = preload("res://scripts/systems/narrative_director.gd").new()
	narrative.campaign = self
	add_child(narrative)
	narrative.sequence_finished.connect(_on_narrative_finished)
	if start_on_map:
		if _should_play_opening(): _play_opening.call_deferred()
		else: show_map()

func _should_play_opening() -> bool:
	return "opening_complete" not in data.story.events and int(data.stage)==0 and int(data.unlocked)==0

func _play_opening() -> void:
	if not play_narrative("opening_complete",preload("res://scripts/systems/opening_sequence.gd").steps()):
		if start_on_map: show_map()

func _on_narrative_finished(id: String, _skipped: bool) -> void:
	if id=="opening_complete" and start_on_map: _show_map_after_narrative.call_deferred()
	elif id.begins_with("valda_after_") and _map_after_narrative:
		_map_after_narrative = false
		_show_map_after_narrative.call_deferred()

func _show_map_after_narrative() -> void:
	# Aguarda o toque/clique que encerrou a última fala ser liberado antes de
	# criar os botões do mapa; assim a mesma entrada não fecha o mapa em seguida.
	await get_tree().create_timer(0.18,true,false,true).timeout
	show_map()

## Ponto único para fases e eventos futuros iniciarem cenas descritas por dados.
func play_narrative(id: String, steps: Array, replay := false) -> bool:
	if map_is_open() or awaiting_return() or not is_instance_valid(narrative): return false
	return narrative.play(id,steps,replay)

func map_is_open() -> bool:
	return is_instance_valid(world_map)

func show_map() -> void:
	if _changing or map_is_open() or not is_instance_valid(level): return
	if is_instance_valid(level.optional_area) and level.optional_area.transitioning: return
	if level.respawning and not awaiting_return(): return
	save_progress()
	get_tree().paused = true
	level._apply_audio()
	level.touch.release_all()
	level.touch.set_controls_active(false)
	for action in ["move_left","move_right","move_down","jump","action","switch_character"]: Input.action_release(action)
	level.get_node("Interface").hide()
	level.hide()
	return_layer = CanvasLayer.new()
	return_layer.layer = 25
	return_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(return_layer)
	world_map = preload("res://scripts/ui/world_map.gd").new()
	world_map.campaign = self
	return_layer.add_child(world_map)
	if level.completed and not awaiting_return():
		var target := mini(int(data.stage)+1,scene_paths.size()-1)
		world_map.focus_stage(target)
		if _unlocked_stage>=0:
			world_map.celebrate_unlock(_unlocked_stage)
			_unlocked_stage = -1
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
	if level.has_method("start_pending_narrative"):
		level.start_pending_narrative.call_deferred()

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
	if data.survival.replay:
		data.levels[str(index)].checkpoint = false
		data.levels[str(index)].items = []
		data.levels[str(index)].blocks = []
	_load_stage.call_deferred(index)

func _map_portrait() -> bool:
	# O aviso HTML muda antes de a Godot receber o novo tamanho do canvas.
	if OS.has_feature("web") and level.touch.touch_enabled:
		return bool(JavaScriptBridge.eval("window.innerHeight > window.innerWidth"))
	return level.touch.is_portrait()

func new_adventure() -> void:
	_unlocked_stage = -1
	_opening_after_load = start_on_map
	_map_after_load = false
	super.new_adventure()

func fresh() -> Dictionary:
	var result := super.fresh()
	result.survival = _new_survival()
	result.tutorials = {}
	result.context_hints_seen = []
	for key in preload("res://scripts/ui/contextual_help.gd").KEYS: result.tutorials[key] = false
	result = store.migrate(result)
	# Uma aventura realmente nova deve assistir ou pular a abertura da E11.
	result.story.events.erase("opening_complete")
	return result

func _new_survival() -> Dictionary:
	return {"lives":initial_lives,"nut_total":0,"food_total":0,"pending_return":false,"return_stage":0,"replay":false,"pipo_unlocked":false,"claimed":[]}

func _prepare_save() -> void:
	_sync_village_flags()
	store.sync_story(data)

func village_progress() -> Dictionary:
	var completed := 0
	for snapshot in data.levels.values():
		if snapshot.get("completed",false): completed += 1
	var food := int(data.survival.get("food_total",0))
	var state := 0
	if completed>=16 or data.get("finished",false): state = 3
	elif completed>=8 or food>=BALANCE.VILLAGE_FOOD_THRESHOLDS[1]: state = 2
	elif completed>=3 or food>=BALANCE.VILLAGE_FOOD_THRESHOLDS[0]: state = 1
	return {"state":state,"food":food,"completed":completed,"final":state==3}

func _sync_village_flags() -> void:
	if not data.has("story") or not data.story.has("village"): return
	var state := int(village_progress().state)
	for i in 4: data.story.village["state_%d" % i] = i==state

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
		"story":data.story.duplicate(true),"village":village_progress(),
		"tutorials":data.tutorials.duplicate(true),"settings":data.settings.duplicate(true)}

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
	if not data.survival.has("nut_total"): data.survival.nut_total = 0
	if not data.survival.has("food_total"): data.survival.food_total = 0
	for i in data.survival.claimed.size(): data.survival.claimed[i] = int(data.survival.claimed[i])
	var restored: Dictionary = (level.world_snapshot() if state.is_empty() else state).duplicate(true)
	if data.survival.pipo_unlocked: restored.rescued = true
	if data.survival.replay:
		restored.completed = false
		if restored.has("optional_area"): restored.optional_area = {"active":false,"checkpoint":false}
	level.restore_world(restored)

func _capture_level() -> Dictionary:
	var snapshot: Dictionary = level.world_snapshot()
	var previous: Dictionary = data.levels.get(str(data.stage),{})
	# Recompensas repetíveis continuam visíveis no replay, mas seus IDs históricos
	# permanecem no save para impedir novo crédito permanente.
	if data.survival.replay:
		for key in ["items","blocks"]:
			for id in previous.get(key,[]):
				if id not in snapshot[key]: snapshot[key].append(id)
	var earned := 0
	var food_earned := 0
	var heart_lives := 0
	var golden_found := false
	for actor in level.actors.get_children():
		if not actor.has_meta("save_id"): continue
		var id: String = actor.get_meta("save_id")
		if actor.has_method("reset_item") and actor.taken and actor.collectible_kind=="heart" and actor.life_reward and id not in previous.get("items",[]): heart_lives += 1
		if actor.has_method("reset_item") and actor.taken and actor.collectible_kind=="nut" and id not in previous.get("items",[]): earned += 1
		elif actor.has_method("reset_item") and actor.taken and actor.collectible_kind=="food" and id not in previous.get("items",[]): food_earned += actor.food_value
		elif actor.has_method("reset_item") and actor.taken and actor.collectible_kind=="golden" and id not in previous.get("items",[]):
			var stage_id := str(int(data.stage))
			var golden: Array = data.collectibles.golden_nuts.get(stage_id,[])
			if actor.reward_id not in golden and golden.size()<64:
				golden.append(actor.reward_id)
				data.collectibles.golden_nuts[stage_id] = golden
				golden_found = true
		elif actor.has_method("reset_block") and actor.used and actor.kind==2 and id not in previous.get("blocks",[]): earned += 1
	var old_total := int(data.survival.get("nut_total",0))
	var new_total := old_total+earned
	data.survival.nut_total = new_total
	data.survival.food_total = int(data.survival.get("food_total",0))+food_earned
	var bonus := new_total/NUTS_PER_LIFE-old_total/NUTS_PER_LIFE
	data.survival.lives = mini(99,int(data.survival.lives)+bonus+heart_lives)
	if bonus>0:
		level._say.call_deferred("100 nozes! Uma vida extra para a aventura.")
	elif golden_found:
		level._say.call_deferred("Noz Dourada encontrada! Um tesouro da floresta.")
	_refresh_lives()
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
	nut_progress = Label.new()
	nut_progress.position = Vector2(0,30)
	nut_progress.add_theme_font_size_override("font_size",15)
	nut_progress.add_theme_color_override("font_color",Color("355b43"))
	level.counter.add_child(nut_progress)
	level.save_label.position.x = 515
	_refresh_lives()
	if index in extra_life_stages and index not in data.survival.claimed:
		var life_cache := preload("res://scripts/objects/life_cache.gd").new()
		life_cache.name = "LifeCache"
		life_cache.campaign = self
		life_cache.stage_id = index
		life_cache.position = Vector2(450,660)
		level.actors.add_child(life_cache)
	level.contextual_help = preload("res://scripts/ui/contextual_help.gd").new()
	level.contextual_help.level = level
	level.add_child(level.contextual_help)
	map_button = level._menu_button("Mapa da jornada",level.pause_panel.get_child(0))
	map_button.pressed.connect(show_map)
	level.next_button.pressed.disconnect(level._continue_world)
	level.next_button.pressed.connect(advance)
	level.next_button.text = "Voltar ao mapa"
	level._update_layout()
	if _opening_after_load:
		_opening_after_load = false
		_play_opening.call_deferred()
	elif awaiting_return(): show_return.call_deferred()
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
	if is_instance_valid(nut_progress): nut_progress.text = "Vida: %d / %d  •  Comida: %d" % [int(data.survival.get("nut_total",0))%NUTS_PER_LIFE,NUTS_PER_LIFE,int(data.survival.get("food_total",0))]

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
		level.sounds.play_effect("game_over")
		if is_instance_valid(level.feedback): level.feedback.react("defeat","Hora de descansar")
	else:
		level._say("Vamos tentar de novo! Vidas restantes: %d" % int(data.survival.lives))
	_refresh_lives()
	save_progress()

func claim_life(stage_id: int, reward_id := "") -> bool:
	if awaiting_return() or stage_id!=int(data.stage) or data.survival.lives>=BALANCE.MAX_LIVES: return false
	if reward_id.is_empty():
		if stage_id not in extra_life_stages or stage_id in data.survival.claimed: return false
		data.survival.claimed.append(stage_id)
	else:
		var area_lives := {0:"copa_life",1:"galeria_12_life"}
		if area_lives.get(stage_id,"")!=reward_id or reward_id in data.story.events or data.story.events.size()>=200: return false
		data.story.events.append(reward_id)
	data.survival.lives += 1
	_refresh_lives()
	save_progress()
	level._say("Uma vida extra para os dois amigos!")
	level.sounds.play_effect("extra_life")
	level.puff(level.tico.position+Vector2(0,-45),Color("ffe788"),18)
	if is_instance_valid(level.feedback): level.feedback.react("life","+1 vida")
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
	if _changing or not level.completed: return
	var stage := int(data.stage)
	if start_on_map and stage in [3,7,11,15]:
		var sequence = preload("res://scripts/systems/valda_progression.gd")
		var id: String = sequence.event_id(stage)
		if id not in data.story.events:
			_map_after_narrative = true
			if play_narrative(id,sequence.steps(stage)): return
			_map_after_narrative = false
	show_map()

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
	var details := {"lives":data.survival.lives,"food_total":data.survival.get("food_total",0),"game_over":awaiting_return(),"return_stage":data.survival.return_stage,"pipo_unlocked":data.survival.pipo_unlocked}
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
