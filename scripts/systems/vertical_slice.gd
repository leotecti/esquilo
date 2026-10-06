extends "res://scripts/systems/prototype_level.gd"
const CHARACTER_ART = preload("res://scripts/presentation/character_art.gd")
const OBJECT_ART = preload("res://scripts/presentation/object_art.gd")
const FOREST_ART = preload("res://scripts/presentation/forest_art.gd")
const AUDIO = preload("res://scripts/presentation/slice_audio.gd")
const BURST = preload("res://scripts/presentation/leaf_burst.gd")
const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const FOREST = preload("res://assets/slice/forest.png")
var music_enabled := true
var effects_enabled := true
var pause_overlay: Control
var pause_panel: PanelContainer
var music_button: Button
var effects_button: Button
var portrait: TextureRect
var hud_panel: Panel
var background: TextureRect
var _art_ready := false
var _frame_samples: Array[float] = []
var _elapsed := 0.0
var _last_frame_usec := 0
var feedback: CanvasLayer

func _ready() -> void:
	super._ready()
	var previous_sounds := sounds
	sounds = AUDIO.new()
	sounds.process_mode = Node.PROCESS_MODE_ALWAYS
	actors.add_child(sounds)
	previous_sounds.queue_free()
	for character in [squirrel,pipo]:
		var art := CHARACTER_ART.new()
		art.name = "Illustration"
		art.level = self
		character.add_child(art)
	_build_forest()
	feedback = preload("res://scripts/presentation/polish_feedback.gd").new()
	feedback.level = self
	add_child(feedback)
	_skin_objects()
	_skin_ui()
	_art_ready = true
	_update_layout()
	_apply_audio()
	_say("Bosque das Folhas • Uma aventura entre amigos")

func _build_forest() -> void:
	$Landscape.hide()
	background = TextureRect.new()
	background.texture = FOREST
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Background.add_child(background)
	var forest := FOREST_ART.new()
	add_child(forest)
	for body in [$Geometry/SafetyFloor,$Geometry/LeftWall,$Geometry/RightWall]:
		for child in body.get_children():
			if child is Polygon2D: child.hide()
	for actor in actors.get_children():
		if actor.name == "Tunnel" or str(actor.name).begins_with("FinalStep"):
			for child in actor.get_children():
				if child is Polygon2D: child.hide()
		if actor is Polygon2D: actor.hide()
		if actor is Label:
			actor.add_theme_color_override("font_color",Color("fff2cf"))
			actor.add_theme_color_override("font_outline_color",Color("35523a"))
			actor.add_theme_constant_override("outline_size",5)

func _skin_objects() -> void:
	for actor in actors.get_children():
		var kind := ""
		if actor == secret: kind = "secret"
		elif actor == stone: kind = "stone"
		elif actor == heavy: kind = "heavy"
		elif actor == checkpoint or actor.get_meta("checkpoint_marker",false): kind = "checkpoint"
		elif actor == exit_marker: kind = "exit"
		elif actor.has_method("reset_item"): kind = actor.collectible_kind
		elif actor.has_method("reset_block"): kind = "block"
		if not kind.is_empty():
			var art := OBJECT_ART.new()
			art.kind = kind
			actor.add_child(art)

func _box(color: Color, border: Color, radius: int = 18) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(2)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 10
	box.content_margin_bottom = 10
	box.shadow_color = Color(0.1,0.18,0.12,0.22)
	box.shadow_size = 4
	box.shadow_offset = Vector2(0,3)
	return box

func _button_style(button: Button) -> void:
	button.add_theme_stylebox_override("normal",_box(Color("31543e"),Color("88a16a")))
	button.add_theme_stylebox_override("hover",_box(Color("466e49"),Color("d9ca83")))
	button.add_theme_stylebox_override("pressed",_box(Color("93612e"),Color("f3cb70")))
	button.add_theme_stylebox_override("disabled",_box(Color("6c7b67"),Color("929a79")))
	button.add_theme_stylebox_override("focus",_box(Color(0,0,0,0),Color("e7b956")))
	button.add_theme_color_override("font_color",Color("fff1ce"))
	button.add_theme_font_size_override("font_size",20)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _skin_ui() -> void:
	$Interface/HUD/Backdrop.hide()
	hud_panel = Panel.new()
	hud_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_panel.add_theme_stylebox_override("panel",_box(Color("f8efdce8"),Color("abc18a"),22))
	$Interface/HUD.add_child(hud_panel)
	$Interface/HUD.move_child(hud_panel,0)
	portrait = TextureRect.new()
	portrait.name = "Portrait"
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.material = ShaderMaterial.new()
	portrait.material.shader = preload("res://scripts/presentation/chroma_key.gdshader")
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Interface/HUD/TopBar.add_child(portrait)
	$Interface/HUD/TopBar.move_child(portrait,0)
	for button in [switch_button,pause_button,$Interface/HUD/TopBar/Restart]:
		_button_style(button)
		button.pressed.connect(func(): sounds.play_effect("interface"))
	hearts.self_modulate.a = 0
	for i in 3:
		var heart := TextureRect.new()
		heart.name = "Heart%d" % i
		heart.texture = preload("res://assets/slice/heart.svg")
		heart.position = Vector2(i*44,0)
		heart.size = Vector2(38,38)
		heart.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hearts.add_child(heart)
	for button in touch.get_children():
		button.texture_normal = preload("res://assets/slice/touch.svg")
		button.texture_pressed = preload("res://assets/slice/touch_pressed.svg")
	result_panel.add_theme_stylebox_override("panel",_box(Color("fff0d1"),Color("ac9b55"),26))
	_button_style(result_panel.get_child(0).get_child(1))
	for button in [restart_dialog.get_ok_button(),restart_dialog.get_cancel_button()]: _button_style(button)
	_build_pause()

func _build_pause() -> void:
	pause_overlay = Control.new()
	pause_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Interface/HUD.add_child(pause_overlay)
	var dim := ColorRect.new()
	dim.color = Color(0.07,0.18,0.12,0.65)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_overlay.add_child(dim)
	pause_panel = PanelContainer.new()
	pause_panel.add_theme_stylebox_override("panel",_box(Color("f9edd0"),Color("aac083"),26))
	pause_overlay.add_child(pause_panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",12)
	pause_panel.add_child(column)
	var title := Label.new()
	title.text = "Uma pausa no bosque"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size",30)
	title.add_theme_color_override("font_color",Color("31543e"))
	column.add_child(title)
	var resume := _menu_button("Continuar aventura",column)
	resume.pressed.connect(func(): set_paused(false))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",12)
	column.add_child(row)
	music_button = _menu_button("Música: ligada",row)
	effects_button = _menu_button("Efeitos: ligados",row)
	music_button.pressed.connect(toggle_music)
	effects_button.pressed.connect(toggle_effects)
	var again := _menu_button("Recomeçar",column)
	again.pressed.connect(restart)
	pause_overlay.hide()

func _menu_button(text: String, parent: Node) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(250,88)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_button_style(button)
	parent.add_child(button)
	return button

func toggle_music() -> void:
	music_enabled = not music_enabled
	_apply_audio()
	_save_progress()

func toggle_effects() -> void:
	effects_enabled = not effects_enabled
	_apply_audio()
	_save_progress()

func _apply_audio() -> void:
	if not _art_ready: return
	sounds.configure(music_enabled,effects_enabled,get_tree().paused)
	music_button.text = "Música: " + ("ligada" if music_enabled else "desligada")
	effects_button.text = "Efeitos: " + ("ligados" if effects_enabled else "desligados")

func _snapshot() -> Dictionary:
	var data := super._snapshot()
	data["settings"] = {"music":music_enabled,"effects":effects_enabled}
	return data

func _restore(data: Dictionary) -> void:
	var settings: Dictionary = data.get("settings",{})
	music_enabled = settings.get("music",true)
	effects_enabled = settings.get("effects",true)
	super._restore(data)

func _update_layout() -> void:
	super._update_layout()
	if not _art_ready: return
	var size := get_viewport_rect().size
	hud_panel.position = Vector2(16+touch.safe_insets().x,10+touch.safe_insets().y)
	hud_panel.size = Vector2(size.x-32-touch.safe_insets().x-touch.safe_insets().z,status.offset_top+34-hud_panel.position.y)
	portrait.custom_minimum_size = Vector2(72,72) if touch.touch_enabled else Vector2(48,48)
	portrait.texture = ATLAS.frame("pipo" if tico == pipo else "tico",0)
	$Interface/HUD/TopBar/Title.text = "Bosque das Folhas\n" + ("Pipo • Força" if tico == pipo else "Tico • Agilidade")
	$Interface/HUD/TopBar/Title.add_theme_font_size_override("font_size",20)
	pause_panel.size = Vector2(600,390)
	pause_panel.position = (size-pause_panel.size)/2
	background.size = size + Vector2(240,100)
	background.position = Vector2(-120,-30)
	if is_instance_valid(feedback): feedback.layout()

func set_paused(value: bool) -> void:
	super.set_paused(value)
	if not _art_ready: return
	pause_overlay.visible = get_tree().paused
	_apply_audio()

func _process(delta: float) -> void:
	super._process(delta)
	if not _art_ready: return
	_elapsed += delta
	var now := Time.get_ticks_usec()
	if _browser_test and _elapsed > 3 and not get_tree().paused and _last_frame_usec > 0:
		_frame_samples.append((now-_last_frame_usec)/1000.0)
		if _frame_samples.size()>600: _frame_samples.pop_front()
	_last_frame_usec = now
	background.position.x = -30 - clampf(camera.get_screen_center_position().x/3800,0,1)*180
	for i in 3:
		hearts.get_node("Heart%d" % i).modulate = Color.WHITE if i<tico.health else Color("737a6880")
	if completed and save_store.state == "saved": save_label.text = "Progresso salvo • Aventura concluída"

func puff(point: Vector2, color: Color, amount: int = 8) -> void:
	if not _art_ready or get_tree().paused: return
	# Limite rígido de partículas para sessões longas em aparelhos modestos.
	if get_tree().get_nodes_in_group("slice_effects").size() >= 16: return
	var effect := BURST.new()
	effect.add_to_group("slice_effects")
	effect.position = point
	effect.tint = color
	effect.count = amount
	actors.add_child(effect)

func _on_collected(item: Node2D) -> void:
	super._on_collected(item)
	puff(item.position,Color("ffd877"),10)
	if is_instance_valid(feedback): feedback.react("secret" if item.collectible_kind in ["secret","golden"] else "collect")

func _on_stomp(enemy: Node2D) -> void:
	super._on_stomp(enemy)
	puff(enemy.position,Color("cbd98f"),9)

func _on_checkpoint(marker: Node2D) -> void:
	super._on_checkpoint(marker)
	puff(marker.position+Vector2(0,-70),Color("ffe7a0"),14)
	if is_instance_valid(feedback): feedback.react("checkpoint","Ponto seguro")

func _on_exit(marker: Node2D) -> void:
	super._on_exit(marker)
	puff(marker.position+Vector2(0,-60),Color("ffd877"),18)
	if is_instance_valid(feedback): feedback.react("victory","Trilha concluída!")

func _test_details() -> Dictionary:
	var data := super._test_details()
	data["stage"] = 7
	data["music_enabled"] = music_enabled
	data["effects_enabled"] = effects_enabled
	if _art_ready:
		data["pose"] = tico.get_node("Illustration").pose
		data["push_frame"] = tico.get_node("Illustration").push_frame
		data["run_frame"] = tico.get_node("Illustration").run_frame
		data["music_playing"] = sounds.music.playing
		data["audio_paused"] = sounds.music.stream_paused
		for entry in [["music_rect",music_button],["effects_rect",effects_button]]:
			var rect: Rect2 = entry[1].get_global_rect()
			data[entry[0]] = [rect.position.x,rect.position.y,rect.size.x,rect.size.y]
		data["draw_calls"] = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
		if not _frame_samples.is_empty():
			var samples := _frame_samples.duplicate()
			samples.sort()
			data["frame_ms_p50"] = samples[int(samples.size()*.5)]
			data["frame_ms_p95"] = samples[mini(int(samples.size()*.95),samples.size()-1)]
	return data
