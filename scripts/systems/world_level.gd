extends "res://scripts/systems/vertical_slice.gd"
@export_range(0,3) var world_stage := 0
const TITLES = ["1-1 • Primeiros Passos","1-2 • Blocos e Segredos","1-3 • Um Novo Amigo","1-4 • Periquito do Bosque"]
var campaign: Node
var world_ready := false
var rescued := false
var terrain: Array[Rect2] = []
var drop_platforms: Array[Rect2] = []
var rescue_lock: StaticBody2D
var rescue_gate: StaticBody2D
var captive: Sprite2D
var secret_block: StaticBody2D
var guardian: Node2D
var next_button: Button
var contextual_help: Node
var phase_restart_button: Button
var phase_restart_dialog: ConfirmationDialog
var _phase_was_paused := false
var optional_area: Node2D
var main_right := 3800
var route_checkpoint := 0
var route_flags := {}
var foods := 0
var total_foods := 0
var backtrack_stone: CharacterBody2D
var backtrack_gate: StaticBody2D
var backtrack_reward: Area2D
var backtrack_open := false
var backtrack_plate_x := 0.0
var backtrack_event_id := ""
const FOOD = preload("res://scenes/objects/food.tscn")
const GOLDEN_NUT = preload("res://scenes/objects/golden_nut.tscn")

func _ready() -> void:
	save_enabled = false
	rescued = world_stage == 3
	super._ready()
	$FollowCamera.limit_right = main_right
	next_button = result_panel.get_child(0).get_child(1)
	next_button.pressed.disconnect(restart)
	next_button.pressed.connect(_continue_world)
	next_button.text = "Próxima fase" if world_stage<2 else ("Encontrar o Guardião" if world_stage==2 else "Jogar novamente")
	start_pending_narrative.call_deferred()
	if world_stage==3 and is_instance_valid(campaign) and campaign.scene_paths.size()>4:
		next_button.text = "Seguir para o Rio"
	if world_stage==2:
		captive = Sprite2D.new()
		captive.texture = ATLAS.frame("pipo",0)
		captive.scale = Vector2.ONE * (76.0/captive.texture.get_height())
		captive.position = Vector2(610,718)
		captive.material = ShaderMaterial.new()
		captive.material.shader = preload("res://scripts/presentation/chroma_key.gdshader")
		actors.add_child(captive)
		var vines = preload("res://scripts/presentation/rescue_art.gd").new()
		vines.level = self
		actors.add_child(vines)
	world_ready = true
	if is_instance_valid(campaign) and campaign.has_method("restart_stage"):
		_build_phase_restart()
	_update_layout()
	var messages := ["As nozes sumiram! Siga a trilha e descubra o que aconteceu.","Uma pista entre os blocos… Explore os caminhos do bosque.","Pipo está preso! Pule sob o bloco rachado para soltá-lo.","O Periquito está assustado. Observe suas asas e espere o pouso."]
	_say(messages[world_stage])
	_message_time = 7

func _build_gameplay() -> void:
	if world_stage == 2:
		super._build_gameplay()
		# O primeiro encontro substitui a lesma antes da pedra.
		for actor in actors.get_children():
			if actor.has_method("reset_enemy") and actor.position.x<700:
				actor.position.x = 2550
				actor.origin = actor.position
		_spider(Vector2(2050,445),285)
		rescue_lock = _block(Vector2(490,610),1,"RescueLock")
		rescue_gate = _solid("Vines",Rect2(695,450,32,310),Color("5c7949"))
		for child in rescue_gate.get_children():
			if child is Polygon2D: child.hide()
		_sign(Vector2(375,485),"Pule sob o bloco rachado\npara libertar Pipo")
		preload("res://scripts/systems/new_friend_layout.gd").build(self)
	else:
		_build_solo_or_arena()
	if world_stage in [0,1,2,3] and is_instance_valid(campaign) and campaign.has_method("progress_summary"):
		var area_scripts := [preload("res://scripts/systems/optional_area.gd"),preload("res://scripts/systems/blocks_secrets_area.gd"),preload("res://scripts/systems/friend_cave_area.gd"),preload("res://scripts/systems/waterfall_grotto_area.gd")]
		optional_area = area_scripts[world_stage].new()
		optional_area.level = self
		optional_area.z_index = -2
		add_child(optional_area)
		optional_area.build()
	_build_backtracking_secret()
	for actor in actors.get_children():
		if actor.has_method("reset_item") and is_instance_valid(campaign) and campaign.has_method("survival_details"): actor.campaign = campaign
		if actor.has_method("reset_item") or actor.has_method("reset_block"):
			if not actor.has_meta("save_id"): actor.set_meta("save_id","%d:%d" % [actor.position.x,actor.position.y])

func _build_backtracking_secret() -> void:
	if world_stage>1 or not is_instance_valid(campaign): return
	var survival: Dictionary = campaign.data.get("survival",{})
	# O segredo pertence à revisita: não antecipa Pipo nem altera a primeira passagem.
	if not bool(survival.get("pipo_unlocked",false)) or not bool(survival.get("replay",false)): return
	var origin := Vector2(14350,660) if world_stage==0 else Vector2(2130,660)
	var width := 900.0 if world_stage==0 else 540.0
	var stone_offset := 105.0 if world_stage==0 else 55.0
	var plate_offset := 315.0 if world_stage==0 else 185.0
	var gate_offset := 500.0 if world_stage==0 else 310.0
	var tunnel_width := 390.0 if world_stage==0 else 220.0
	var reward_offset := 775.0 if world_stage==0 else 465.0
	backtrack_event_id = "backtrack_cache_%d_open" % world_stage
	backtrack_plate_x = origin.x+plate_offset+40
	if world_stage==0:
		_platform(Rect2(origin.x,origin.y,width,24))
		# Em 1-1, a copa baixa desenhada pela árvore cobre esta colisão.
		var roof := _solid("BacktrackRoof",Rect2(origin.x+gate_offset,origin.y-126,tunnel_width,62),Color("46633f"))
		for child in roof.get_children():
			if child is Polygon2D: child.hide()
	else:
		# Em 1-2 não há copa que justifique um teto oculto. Duas lajes visíveis
		# deixam uma abertura de 80 px para chegar aos inimigos e alimentos da
		# rota inferior, além de eliminar o apoio invisível sobre a passagem.
		_platform(Rect2(origin.x,origin.y,300,24))
		_platform(Rect2(origin.x+380,origin.y,width-380,24))
	backtrack_stone = PUSHABLE.instantiate()
	backtrack_stone.name = "BacktrackStone"
	backtrack_stone.position = origin+Vector2(stone_offset,0)
	backtrack_stone.max_travel = 290 if world_stage==0 else 190
	actors.add_child(backtrack_stone)
	var plate := _solid("BacktrackPlate",Rect2(origin.x+plate_offset,origin.y-4,80,4),Color("e4c86e"))
	plate.collision_layer = 0
	backtrack_gate = _solid("BacktrackGate",Rect2(origin.x+gate_offset,origin.y-64,24,64),Color("8a6a42"))
	_golden_nut(origin+Vector2(reward_offset,-31),"retorno_%02d" % (world_stage+1))
	backtrack_reward = actors.get_child(actors.get_child_count()-1)
	backtrack_reward.set_meta("save_id","golden:retorno_%02d" % (world_stage+1))
	_sign(origin+Vector2(55,-145),"Pipo move a pedra • Tico explora")
	var events: Array = campaign.data.story.get("events",[])
	if backtrack_event_id in events:
		backtrack_stone.position.x = backtrack_plate_x
		_open_backtracking_secret(false)
	var collected: Array = campaign.data.collectibles.golden_nuts.get(str(int(campaign.data.stage)),[])
	if backtrack_reward.reward_id in collected:
		backtrack_reward.taken = true
		backtrack_reward.hide()
		backtrack_reward.get_node("Collision").set_deferred("disabled",true)

func _open_backtracking_secret(announce := true) -> void:
	if backtrack_open or not is_instance_valid(backtrack_gate): return
	backtrack_open = true
	backtrack_gate.hide()
	backtrack_gate.get_node("Collision").set_deferred("disabled",true)
	if not announce: return
	_feedback(backtrack_stone.position,"Passagem de Tico aberta!",Color("ffe39a"))
	_say("Muito bem, Pipo! Agora Tico pode entrar na passagem.")
	sounds.play_notes([523,659,784],.08)
	if is_instance_valid(campaign): campaign.record_story_event(backtrack_event_id)

func _build_solo_or_arena() -> void:
	if world_stage==0:
		for rect in [Rect2(650,690,350,70),Rect2(1000,620,240,140),Rect2(1500,690,200,70),Rect2(2650,690,240,70),Rect2(2890,620,260,140),Rect2(3150,550,580,210)]: _platform(rect)
		for point in [Vector2(330,716),Vector2(500,716),Vector2(720,646),Vector2(1080,576),Vector2(1550,646),Vector2(1830,715),Vector2(2180,715),Vector2(2720,646),Vector2(2950,576),Vector2(3350,506)]: _nut(point)
		_slug(Vector2(1900,760),65)
		_slug(Vector2(2460,760),55)
		_markers(Vector2(2230,760),Vector2(3570,550))
		if is_instance_valid(campaign) and campaign.has_method("progress_summary"):
			preload("res://scripts/systems/first_steps_layout.gd").build(self)
		_sign(Vector2(330,580),"Siga as nozes")
		_sign(Vector2(560,535),"Pule • Segure para planar")
		_sign(Vector2(1760,570),"Pule sobre a lesma")
	elif world_stage==1:
		for rect in [Rect2(1160,690,300,70),Rect2(1460,620,220,140),Rect2(1910,650,200,110),Rect2(2700,690,230,70),Rect2(2930,620,270,140),Rect2(3200,550,530,210)]: _platform(rect)
		for point in [Vector2(330,715),Vector2(550,715),Vector2(1050,715),Vector2(1250,646),Vector2(1540,576),Vector2(2000,606),Vector2(2350,715),Vector2(2790,646),Vector2(3000,576),Vector2(3370,506)]: _nut(point)
		for i in 3: _block(Vector2(480+i*95,610),i,"TeachingBlock%d" % i)
		_block(Vector2(950,610),2,"NutBlock2")
		secret_block = _block(Vector2(1770,610),1,"SecretBlock")
		secret = SECRET.instantiate()
		secret.position = Vector2(1770,715)
		actors.add_child(secret)
		secret.collected.connect(_on_collected)
		total_nuts += 1
		_beetle(Vector2(1040,760),90)
		var hedgehog = preload("res://scripts/enemies/hedgehog.gd").new()
		hedgehog.name = "Hedgehog"
		hedgehog.level = self
		hedgehog.position = Vector2(2490,760)
		actors.add_child(hedgehog)
		_block(Vector2(2790,540),2,"FinalNutBlock")
		_markers(Vector2(2180,760),Vector2(3570,550))
		_sign(Vector2(360,485),"Bata por baixo dos blocos")
		_sign(Vector2(1610,480),"Uma trilha escondida…")
		_sign(Vector2(2300,535),"Espinhos! Passe por cima")
		if is_instance_valid(campaign) and campaign.has_method("progress_summary"):
			preload("res://scripts/systems/blocks_secrets_layout.gd").build(self)
	else:
		for point in [Vector2(380,715),Vector2(720,715),Vector2(1100,715),Vector2(1600,715)]: _nut(point)
		_markers(Vector2(25100,760),Vector2(37780,760))
		preload("res://scripts/systems/guardian_route_layout.gd").build(self)

func _platform(rect: Rect2) -> void:
	terrain.append(rect)
	var body := _solid("WorldPlatform%d" % terrain.size(),rect,Color("759257"))
	for child in body.get_children():
		if child is Polygon2D: child.hide()

func _drop_platform(rect: Rect2) -> void:
	# Ponte de mão única: preserva a superfície superior e libera o espaço abaixo.
	var bridge := Rect2(rect.position,Vector2(rect.size.x,24))
	terrain.append(bridge)
	drop_platforms.append(bridge)
	var body := _solid("DropPlatform%d" % drop_platforms.size(),bridge,Color("759257"))
	body.set_meta("drop_through",true)
	body.set_meta("drop_release_y",bridge.position.y+54.0)
	var shape: CollisionShape2D = body.get_node("Collision")
	shape.one_way_collision = true
	shape.one_way_collision_margin = 12.0
	for child in body.get_children():
		if child is Polygon2D: child.hide()

func _nut(point: Vector2, healing := false) -> void:
	var item = NUT.instantiate()
	item.position = point
	item.healing = healing
	item.collectible_kind = "heart" if healing else "nut"
	if is_instance_valid(campaign) and campaign.has_method("survival_details"): item.campaign = campaign
	actors.add_child(item)
	item.collected.connect(_on_collected)
	if not healing: total_nuts += 1

func _food(point: Vector2, kind: int, value := 1) -> void:
	var item = FOOD.instantiate()
	item.position = point
	item.food_kind = kind
	item.food_value = value
	item.campaign = campaign
	actors.add_child(item)
	item.collected.connect(_on_collected)
	total_foods += value

func _golden_nut(point: Vector2, reward_id: String) -> void:
	var item = GOLDEN_NUT.instantiate()
	item.position = point
	item.reward_id = reward_id
	item.campaign = campaign
	actors.add_child(item)
	item.collected.connect(_on_collected)

func _block(point: Vector2, kind: int, node_name: String) -> StaticBody2D:
	var block = BLOCK.instantiate()
	block.position = point
	block.kind = kind
	block.name = node_name
	actors.add_child(block)
	block.opened.connect(_on_block)
	if kind==2: total_nuts += 1
	return block

func _slug(point: Vector2, distance: float) -> Node2D:
	var slug = SLUG.instantiate()
	slug.position = point
	slug.patrol_distance = distance
	actors.add_child(slug)
	slug.stomped.connect(_on_stomp)
	return slug

func _beetle(point: Vector2, distance: float = 110.0) -> Node2D:
	var beetle = preload("res://scripts/enemies/beetle.gd").new()
	beetle.position = point
	beetle.level = self
	beetle.patrol_distance = distance
	actors.add_child(beetle)
	beetle.stomped.connect(_on_stomp)
	return beetle

func _spider(point: Vector2, travel: float = 105.0) -> Node2D:
	var spider = preload("res://scripts/enemies/spider.gd").new()
	spider.position = point
	spider.level = self
	spider.travel = travel
	actors.add_child(spider)
	spider.stomped.connect(_on_stomp)
	return spider

func _markers(flag: Vector2, finish: Vector2) -> void:
	checkpoint = CHECKPOINT.instantiate()
	checkpoint.position = flag
	actors.add_child(checkpoint)
	checkpoint.reached.connect(_on_checkpoint)
	exit_marker = EXIT.instantiate()
	exit_marker.position = finish
	actors.add_child(exit_marker)
	exit_marker.reached.connect(_on_exit)

func _sign(point: Vector2, text: String) -> void:
	# As pistas desta campanha não usam as coordenadas fixas do protótipo.
	if world_stage==2:
		if int(point.x)==580: return
		var hints := {130:"Encontre Pipo",690:"Pipo • Empurre",1210:"Tico • Passagem",1870:"Pipo • INVESTIR",2650:"Snif, snif…",3380:"Até a árvore"}
		text = hints.get(int(point.x),text)
		if int(point.x)==690: point = Vector2(790,520)
	var label := Label.new()
	label.position = point
	label.text = text
	label.add_theme_font_size_override("font_size",22)
	actors.add_child(label)
	if is_instance_valid(campaign) and campaign.has_method("mark_hint_seen"):
		label.set_meta("context_hint",text)
		label.hide()

func _build_forest() -> void:
	super._build_forest()
	var base_forest: Node2D
	for child in get_children():
		if child.get_script()==FOREST_ART:
			base_forest = child
			child.coop_details = world_stage==2
			child.platforms = terrain
			child.drop_platforms = drop_platforms
			child.draw_base = true
			child.clip_start = -1000.0
			child.clip_end = 4000.0
			child.queue_redraw()
	# Cada trecho estático possui limites próprios, permitindo descarte pela câmera.
	if is_instance_valid(base_forest) and main_right>4000:
		var chunk_start := 4000
		while chunk_start<mini(main_right,int(FOREST_ART.CAVE_VISUAL_START)):
			var chunk = FOREST_ART.new()
			chunk.name = "ForestChunk%d" % chunk_start
			chunk.draw_base = false
			chunk.coop_details = false
			chunk.clip_start = float(chunk_start)
			chunk.clip_end = float(mini(chunk_start+1800,main_right))
			chunk.platforms = terrain
			chunk.drop_platforms = drop_platforms
			add_child(chunk)
			chunk_start += 1800

func switch_character() -> bool:
	if is_instance_valid(optional_area) and optional_area.transitioning: return false
	if not rescued:
		_say("Encontre e liberte Pipo na fase 1-3.")
		return false
	return super.switch_character()

func _update_layout() -> void:
	super._update_layout()
	if not world_ready: return
	switch_button.visible = rescued
	$Interface/HUD/TopBar/Title.text = TITLES[world_stage]+"\n"+("Pipo • Força" if tico==pipo else "Tico • Agilidade")
	if is_instance_valid(contextual_help): contextual_help.layout()

func _say(message: String) -> void:
	super._say(message)
	if is_instance_valid(contextual_help): contextual_help.notify(message)

func _process(delta: float) -> void:
	super._process(delta)
	if not world_ready: return
	if is_instance_valid(backtrack_stone) and not backtrack_open and backtrack_stone.position.x>=backtrack_plate_x:
		_open_backtracking_secret()
	if not rescued:
		switch_button.hide()
		if _message_time<=0 and not get_tree().paused:
			status.text = TITLES[world_stage]+" • Siga as nozes"
	if is_instance_valid(guardian) and guardian.health>0:
		exit_marker.activated = false

func _on_block(block: Node2D, reward: bool) -> void:
	super._on_block(block,reward)
	if block==rescue_lock and not rescued:
		_release_pipo()
		_say("Pipo agora faz parte da equipe! Troque para usar a força dele.")
		_message_time = 6
		start_pending_narrative.call_deferred()
	elif block==secret_block:
		secret.reveal()
		_say("Você encontrou uma noz escondida!")
	_save_progress()

func _on_collected(item: Node2D) -> void:
	if item.collectible_kind=="food":
		foods += item.food_value
		_feedback(item.position,"+%d alimento%s" % [item.food_value,"s" if item.food_value>1 else ""])
		sounds.play_notes([659,784,988],.06)
		puff(item.position,Color("f0b96e"),8)
		_save_progress()
		return
	if item.collectible_kind=="golden":
		_feedback(item.position,"Noz Dourada!",Color("ffe39a"))
		sounds.play_notes([784,988,1319],.09)
		puff(item.position,Color("ffe08a"),14)
		_save_progress()
		return
	super._on_collected(item)

func _on_checkpoint(marker: Node2D) -> void:
	var index := int(marker.get_meta("route_checkpoint",0))
	if index<route_checkpoint: return
	route_checkpoint = index
	super._on_checkpoint(marker)

func _release_pipo() -> void:
	rescued = true
	rescue_gate.hide()
	rescue_gate.get_node("Collision").set_deferred("disabled",true)
	if is_instance_valid(captive): captive.hide()
	_update_layout()

func start_pending_narrative() -> void:
	if world_stage!=2 or not is_instance_valid(campaign) or campaign.map_is_open(): return
	var events: Array = campaign.data.story.events
	var sequence = preload("res://scripts/systems/pipo_sequence.gd")
	if not rescued and "pipo_first_meeting" not in events:
		campaign.play_narrative("pipo_first_meeting",sequence.first_meeting())
	elif rescued and "pipo_first_meeting" in events and "pipo_joins_team" not in events:
		campaign.play_narrative("pipo_joins_team",sequence.joins_team())

func _on_guardian_calmed() -> void:
	_say("A trilha até o rio está livre. Vamos, amigos!")
	_message_time = 5
	_save_progress()
	_start_guardian_exit_run.call_deferred()

func _start_guardian_exit_run() -> void:
	if completed or not is_instance_valid(exit_marker) or not is_instance_valid(tico): return
	exit_marker.activated = true
	if not tico.auto_run_finished.is_connected(_finish_guardian_exit_run):
		tico.auto_run_finished.connect(_finish_guardian_exit_run,CONNECT_ONE_SHOT)
	tico.start_auto_run(exit_marker.position.x)

func _finish_guardian_exit_run() -> void:
	if not completed and is_instance_valid(exit_marker): _on_exit(exit_marker)

func _on_exit(marker: Node2D) -> void:
	if (world_stage==2 and not rescued) or (is_instance_valid(guardian) and guardian.health>0):
		marker.activated = false
		_say("Ajude o Periquito antes de seguir." if world_stage==3 else "Pipo ainda precisa de ajuda!")
		return
	super._on_exit(marker)
	result_text.text = ("Mundo 1 concluído!\nO Bosque das Folhas está em paz.\nTico e Pipo seguem juntos até o rio." if world_stage==3 else TITLES[world_stage]+"\nTrilha concluída!")+"\nNozes: %d de %d" % [nuts,total_nuts]
	_save_progress()

func _continue_world() -> void:
	if not is_instance_valid(campaign): return
	if campaign.data.stage>=campaign.scene_paths.size()-1: restart()
	else: campaign.advance()

func new_adventure() -> void:
	if is_instance_valid(campaign):
		restart_dialog.hide()
		campaign.new_adventure()

func _save_progress() -> void:
	if world_ready and is_instance_valid(campaign): campaign.save_progress()

func _on_defeat() -> void:
	if respawning: return
	if is_instance_valid(feedback): feedback.react("defeat","Tente novamente")
	sounds.play_effect("defeat")
	super._on_defeat()
	if is_instance_valid(campaign) and campaign.has_method("lose_life"):
		campaign.lose_life()

func _on_hurt() -> void:
	if is_instance_valid(feedback): feedback.react("hurt")
	super._on_hurt()

func _respawn() -> void:
	if is_instance_valid(campaign) and campaign.has_method("awaiting_return") and campaign.awaiting_return():
		respawning = false
		campaign.show_return()
		return
	super._respawn()
	if is_instance_valid(optional_area): optional_area.restore_player()

func set_paused(value: bool) -> void:
	if is_instance_valid(campaign) and campaign.has_method("map_is_open") and campaign.map_is_open(): return
	if is_instance_valid(campaign) and campaign.has_method("awaiting_return") and campaign.awaiting_return(): return
	if is_instance_valid(phase_restart_dialog) and phase_restart_dialog.visible and not value: return
	super.set_paused(value)
	if is_instance_valid(phase_restart_button): phase_restart_button.disabled = respawning

func _build_phase_restart() -> void:
	var column := pause_panel.get_child(0)
	var adventure := column.get_child(column.get_child_count()-1)
	column.remove_child(adventure)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",12)
	column.add_child(row)
	phase_restart_button = _menu_button("Reiniciar fase",row)
	phase_restart_button.pressed.connect(request_phase_restart)
	adventure.text = "Nova aventura"
	row.add_child(adventure)
	phase_restart_dialog = ConfirmationDialog.new()
	phase_restart_dialog.title = "Reiniciar esta fase?"
	phase_restart_dialog.dialog_text = "Voltar ao início da fase com a saúde completa?\nA bandeira será desativada. Vidas, itens coletados\ne caminhos liberados serão mantidos."
	phase_restart_dialog.ok_button_text = "Reiniciar fase"
	phase_restart_dialog.cancel_button_text = "Cancelar"
	for button in [phase_restart_dialog.get_ok_button(),phase_restart_dialog.get_cancel_button()]:
		button.custom_minimum_size = Vector2(220,88)
		_button_style(button)
	phase_restart_dialog.confirmed.connect(func():
		phase_restart_dialog.hide()
		campaign.restart_stage())
	phase_restart_dialog.canceled.connect(func(): set_paused(_phase_was_paused))
	add_child(phase_restart_dialog)

func request_phase_restart() -> void:
	if respawning or not is_instance_valid(phase_restart_dialog) or campaign.awaiting_return(): return
	_phase_was_paused = get_tree().paused
	set_paused(true)
	phase_restart_dialog.popup_centered(Vector2i(620,260))

func world_snapshot() -> Dictionary:
	var items: Array = []
	var blocks: Array = []
	for actor in actors.get_children():
		if not actor.has_meta("save_id"): continue
		if actor.has_method("reset_item") and actor.taken: items.append(actor.get_meta("save_id"))
		if actor.has_method("reset_block") and actor.used: blocks.append(actor.get_meta("save_id"))
	var snapshot := {"character":"Pipo" if tico==pipo else "Tico","checkpoint":checkpoint_active,"completed":completed,"rescued":rescued,
		"items":items,"blocks":blocks,"stone":clampf(stone.position.x,850,1190) if is_instance_valid(stone) else 850,
		"gate":gate_open,"heavy":is_instance_valid(heavy) and heavy.destroyed,"secret":is_instance_valid(secret) and secret.revealed,
		"boss_done":is_instance_valid(guardian) and guardian.health==0}
	if is_instance_valid(optional_area): snapshot.optional_area = optional_area.snapshot()
	if not route_flags.is_empty(): snapshot.route_checkpoint = route_checkpoint if checkpoint_active else 0
	return snapshot

func restore_world(data: Dictionary) -> void:
	rescued = data.rescued
	checkpoint_active = data.checkpoint
	checkpoint.activated = checkpoint_active
	checkpoint.queue_redraw()
	checkpoint_position = checkpoint.position+Vector2(0,-5) if checkpoint_active else $PlayerSpawn.position
	route_checkpoint = int(data.get("route_checkpoint",0)) if checkpoint_active and not route_flags.is_empty() else 0
	if route_flags.has(route_checkpoint): checkpoint_position = route_flags[route_checkpoint].position+Vector2(0,-5)
	for index in route_flags:
		route_flags[index].activated = index<=route_checkpoint
		route_flags[index].queue_redraw()
	if world_stage==2:
		if rescued: _release_pipo()
		gate_open = data.gate
		gate.visible = not gate_open
		gate.get_node("Collision").set_deferred("disabled",gate_open)
		stone.position.x = data.stone
		stone.force_update_transform()
		heavy.destroyed = data.heavy
		heavy.visible = not heavy.destroyed
		heavy.get_node("Collision").set_deferred("disabled",heavy.destroyed)
	if is_instance_valid(secret): secret.revealed = data.secret
	if is_instance_valid(guardian) and data.boss_done:
		guardian.health = 0
		guardian.phase = "vanished"
		guardian.hide()
		guardian.queue_redraw()
	nuts = 0
	foods = 0
	var replaying: bool = is_instance_valid(campaign) and campaign.data.has("survival") and bool(campaign.data.survival.get("replay",false))
	for actor in actors.get_children():
		if not actor.has_meta("save_id"): continue
		var id: String = actor.get_meta("save_id")
		if actor.has_method("reset_item") and id in data.items:
			if replaying and actor.collectible_kind=="food": continue
			actor.taken = true
			actor.hide()
			if actor.collectible_kind=="nut": nuts += 1
			elif actor.collectible_kind=="food": foods += actor.food_value
		elif actor.has_method("reset_block") and id in data.blocks and actor.kind>0:
			if replaying and actor.kind==2 and str(actor.name).begins_with("SupplyBlock"): continue
			actor.used = true
			if actor.kind==1:
				actor.hide()
				actor.get_node("Collision").set_deferred("disabled",true)
			else: nuts += 1
	_activate(pipo if data.character=="Pipo" and rescued else squirrel,checkpoint_position)
	_restore_returning_player()
	resumed = true
	if data.completed:
		tico.reset_at(exit_marker.position)
		exit_marker.activated = true
		_on_exit(exit_marker)
	if is_instance_valid(optional_area): optional_area.restore(data.get("optional_area",{}))
	_update_layout()

func _test_details() -> Dictionary:
	var data := super._test_details()
	if is_instance_valid(optional_area):
		data.merge({"optional_active":optional_area.active,"optional_checkpoint":optional_area.checkpoint,"optional_transition":optional_area.transitioning,
			"optional_entry_x":optional_area.ENTRY.x,"optional_left":optional_area.LEFT_EDGE if world_stage in [1,2] else optional_area.RIGHT_EDGE-4000})
	data["main_right"] = main_right
	data["phase_restart_confirmation"] = is_instance_valid(phase_restart_dialog) and phase_restart_dialog.visible
	if is_instance_valid(phase_restart_button):
		var phase_rect := phase_restart_button.get_global_rect()
		data["phase_restart_rect"] = [phase_rect.position.x,phase_rect.position.y,phase_rect.size.x,phase_rect.size.y]
	if is_instance_valid(phase_restart_dialog) and phase_restart_dialog.visible:
		for entry in [["phase_confirm_rect",phase_restart_dialog.get_ok_button()],["phase_cancel_rect",phase_restart_dialog.get_cancel_button()]]:
			var rect: Rect2 = entry[1].get_global_rect()
			var point := rect.position+Vector2(phase_restart_dialog.position)
			data[entry[0]] = [point.x,point.y,rect.size.x,rect.size.y]
	data.merge({"stage":8,"world_stage":world_stage,"rescued":rescued,"world_title":TITLES[world_stage]},true)
	data.merge({"backtrack_available":is_instance_valid(backtrack_stone),"backtrack_open":backtrack_open,
		"backtrack_stone_x":backtrack_stone.position.x if is_instance_valid(backtrack_stone) else 0.0,
		"backtrack_reward_taken":backtrack_reward.taken if is_instance_valid(backtrack_reward) else false})
	var restart_rect: Rect2 = $Interface/HUD/TopBar/Restart.get_global_rect()
	data["restart_rect"] = [restart_rect.position.x,restart_rect.position.y,restart_rect.size.x,restart_rect.size.y]
	if is_instance_valid(campaign):
		data["world_finished"] = campaign.data.finished
		if campaign.has_method("play_narrative") and is_instance_valid(campaign.narrative):
			var story_details: Dictionary = campaign.narrative.details()
			for key in story_details: data["narrative_"+key] = story_details[key]
		if campaign.scene_paths.size()>4: data["stage"] = 9
		data["campaign_stage"] = campaign.data.stage
		data["save_state"] = campaign.store.state
		if campaign.has_method("survival_details"): data.merge(campaign.survival_details())
	if is_instance_valid(guardian):
		data["boss_health"] = guardian.health
		data["boss_phase"] = guardian.phase
	if is_instance_valid(next_button):
		var rect := next_button.get_global_rect()
		data["next_rect"] = [rect.position.x,rect.position.y,rect.size.x,rect.size.y]
	if is_instance_valid(contextual_help): data.merge(contextual_help.details(),true)
	return data
