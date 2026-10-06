extends CanvasLayer
## Executa sequências narrativas descritas por dados, sem acoplar o conteúdo às fases.
signal animation_requested(actor_id: String, animation_id: String)
signal sequence_finished(sequence_id: String, skipped: bool)

const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
const CINEMATIC_TICO = preload("res://assets/narrative/tico_cinematic.png")
var campaign: Node
var sequence_id := ""
var steps: Array = []
var step_index := -1
var active := false
var _skipped := false
var _previous_paused := false
var _interface_was_visible := true
var backdrop: ColorRect
var scene_image: TextureRect
var story_actor: TextureRect
var story_companion: TextureRect
var scene_title: Label
var story_panel: PanelContainer
var portrait: TextureRect
var speaker: Label
var dialogue: Label
var continue_button: Button
var skip_button: Button
var _actor_motion: Dictionary = {}
var _motion_actor: TextureRect
var _actor_elapsed := 0.0
var _text_tween: Tween
var _scene_motion: Tween
var _scene_fade: Tween
var _cinematic_frames: Array[Texture2D] = []

func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_interface()
	_build_cinematic_frames()
	hide()
	get_viewport().size_changed.connect(_layout)

func _process(delta: float) -> void:
	if _actor_motion.is_empty() or not active: return
	_actor_elapsed += delta
	var duration: float = maxf(float(_actor_motion.get("duration",1.0)),0.01)
	var progress := clampf(_actor_elapsed/duration,0.0,1.0)
	var eased := progress*progress*(3.0-2.0*progress)
	var viewport_size := get_viewport().get_visible_rect().size
	var from := _actor_screen_point(_actor_motion.get("from",Vector2.ZERO),viewport_size)
	var to := _actor_screen_point(_actor_motion.get("to",Vector2.ONE),viewport_size)
	var moving_actor := _motion_actor if is_instance_valid(_motion_actor) else story_actor
	moving_actor.position = from.lerp(to,eased)-moving_actor.size*Vector2(0.5,1.0)
	moving_actor.position.y -= sin(progress*PI)*float(_actor_motion.get("arc",0.0))
	var pose := str(_actor_motion.get("pose","run"))
	if moving_actor==story_actor and pose=="run":
		story_actor.texture = _cinematic_frames[1]
		story_actor.position.y -= absf(sin(progress*PI*5.0))*5.0
	elif moving_actor==story_actor and pose=="gesture":
		story_actor.texture = _cinematic_frames[3]
		story_actor.position.y -= sin(progress*PI*2.0)*4.0
	elif moving_actor==story_actor:
		story_actor.texture = _cinematic_frames[2] if progress<0.72 else _cinematic_frames[0]
	else:
		story_companion.texture = ATLAS.frame("pipo",6 if pose in ["push","charge"] else (1 if pose=="run" else 0))
		story_companion.position.y -= absf(sin(progress*PI*4.0))*3.0
	if progress>=1.0: _actor_motion.clear()

func play(id: String, content: Array, replay := false) -> bool:
	if active or content.is_empty() or not _valid_id(id): return false
	if not replay and is_instance_valid(campaign) and id in campaign.data.story.events: return false
	sequence_id = id
	steps = content.duplicate(true)
	step_index = -1
	_skipped = false
	active = true
	_actor_motion.clear()
	_motion_actor = null
	story_actor.hide()
	story_companion.hide()
	_previous_paused = get_tree().paused
	if is_instance_valid(campaign.level):
		_interface_was_visible = campaign.level.get_node("Interface").visible
		campaign.level.touch.release_all()
		campaign.level.touch.set_controls_active(false)
		campaign.level.get_node("Interface").hide()
	for action in ["move_left","move_right","move_down","jump","action","switch_character"]: Input.action_release(action)
	get_tree().paused = true
	show()
	_layout()
	_advance()
	return true

func _advance() -> void:
	if not active: return
	step_index += 1
	if step_index >= steps.size():
		_finish(false)
		return
	var step: Variant = steps[step_index]
	if not step is Dictionary:
		_advance()
		return
	match str(step.get("type","dialogue")):
		"scene":
			_apply_scene(step)
			_advance()
		"actors":
			_apply_actors(step)
			_advance()
		"dialogue": _show_dialogue(step)
		"camera": _move_camera(step)
		"transition": _transition(step)
		"animation":
			animation_requested.emit(str(step.get("actor","")),str(step.get("animation","")))
			_start_actor_animation(step)
			_wait_then_advance(float(step.get("duration",1.0)))
		"event":
			if is_instance_valid(campaign): campaign.record_story_event(str(step.get("id","")))
			_advance()
		_: _advance()

func _move_camera(step: Dictionary) -> void:
	if not scene_image.visible:
		_advance()
		return
	if is_instance_valid(_scene_motion): _scene_motion.kill()
	var viewport_size := get_viewport().get_visible_rect().size
	var focus: Vector2 = step.get("focus",Vector2(0.5,0.5))
	scene_image.pivot_offset = focus*viewport_size
	var target := Vector2.ONE*clampf(float(step.get("zoom",1.04)),1.0,1.16)
	var duration := clampf(float(step.get("duration",0.8)),0.15,2.0)
	_scene_motion = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_scene_motion.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_scene_motion.tween_property(scene_image,"scale",target,duration)
	_scene_motion.tween_callback(_advance)

func _apply_scene(step: Dictionary) -> void:
	scene_title.text = str(step.get("title",""))
	scene_title.visible = not scene_title.text.is_empty()
	backdrop.color = Color(str(step.get("color","173d2fee")))
	var image: Variant = step.get("background")
	if is_instance_valid(_scene_motion): _scene_motion.kill()
	if is_instance_valid(_scene_fade): _scene_fade.kill()
	scene_image.texture = image if image is Texture2D else null
	scene_image.visible = scene_image.texture != null
	if scene_image.visible:
		scene_image.pivot_offset = get_viewport().get_visible_rect().size*0.5
		scene_image.scale = Vector2(1.035,1.035)
		scene_image.modulate.a = 0.0
		_scene_fade = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		_scene_fade.tween_property(scene_image,"modulate:a",1.0,0.55)
		_scene_motion = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		_scene_motion.tween_property(scene_image,"scale",Vector2.ONE,7.0)
	if step.has("actor_position"):
		_place_actor(step.get("actor_position"),str(step.get("actor_pose","idle")))
	elif bool(step.get("hide_actor",false)): story_actor.hide()
	if step.has("companion_position"):
		_place_companion(step.get("companion_position"),int(step.get("companion_pose",0)))
	elif bool(step.get("hide_companion",false)): story_companion.hide()

func _apply_actors(step: Dictionary) -> void:
	if step.has("tico_position"): _place_actor(step.get("tico_position"),str(step.get("tico_pose","idle")))
	elif bool(step.get("hide_tico",false)): story_actor.hide()
	if step.has("pipo_position"): _place_companion(step.get("pipo_position"),int(step.get("pipo_pose",0)))
	elif bool(step.get("hide_pipo",false)): story_companion.hide()

func _show_dialogue(step: Dictionary) -> void:
	var who := str(step.get("speaker","Narrador"))
	speaker.text = who
	dialogue.text = str(step.get("text",""))
	dialogue.visible_ratio = 0.0
	_set_portrait(str(step.get("portrait",who.to_lower())))
	continue_button.text = "Continuar"
	continue_button.disabled = false
	continue_button.grab_focus()
	if is_instance_valid(_text_tween): _text_tween.kill()
	_text_tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_text_tween.tween_property(dialogue,"visible_ratio",1.0,clampf(dialogue.text.length()*0.018,0.35,0.9))

func _on_continue() -> void:
	if is_instance_valid(_text_tween) and _text_tween.is_running():
		_text_tween.kill()
		dialogue.visible_ratio = 1.0
		return
	_advance()

func _place_actor(normalized_position: Vector2, pose: String) -> void:
	story_actor.show()
	story_actor.texture = _cinematic_frames[0 if pose=="idle" else 2]
	var viewport_size := get_viewport().get_visible_rect().size
	story_actor.position = _actor_screen_point(normalized_position,viewport_size)-story_actor.size*Vector2(0.5,1.0)

func _place_companion(normalized_position: Vector2, pose: int) -> void:
	story_companion.show()
	story_companion.texture = ATLAS.frame("pipo",clampi(pose,0,11))
	var viewport_size := get_viewport().get_visible_rect().size
	story_companion.position = _actor_screen_point(normalized_position,viewport_size)-story_companion.size*Vector2(0.5,1.0)

func _actor_screen_point(normalized_position: Vector2, viewport_size: Vector2) -> Vector2:
	var point := normalized_position*viewport_size
	point.y = minf(point.y,(story_panel.anchor_top-0.018)*viewport_size.y)
	return point

func _start_actor_animation(step: Dictionary) -> void:
	_motion_actor = story_companion if str(step.get("actor","tico"))=="pipo" else story_actor
	_motion_actor.show()
	_actor_elapsed = 0.0
	_actor_motion = {"from":step.get("from",Vector2(0.08,0.66)),"to":step.get("to",Vector2(0.48,0.66)),"arc":float(step.get("arc",0.0)),"duration":float(step.get("duration",1.0)),"pose":str(step.get("pose","run"))}

func _transition(step: Dictionary) -> void:
	continue_button.disabled = true
	var veil := ColorRect.new()
	veil.color = Color(str(step.get("color","fff3d9")))
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.modulate.a = 0
	$Root.add_child(veil)
	var duration := clampf(float(step.get("duration",0.45)),0.05,2.0)
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(veil,"modulate:a",1.0,duration*0.5)
	tween.tween_property(veil,"modulate:a",0.0,duration*0.5)
	tween.tween_callback(veil.queue_free)
	tween.tween_callback(_advance)

func _wait_then_advance(duration: float) -> void:
	continue_button.disabled = true
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_interval(clampf(duration,0.0,2.0))
	tween.tween_callback(_advance)

func _finish(skipped: bool) -> void:
	if not active: return
	active = false
	_skipped = skipped
	hide()
	if is_instance_valid(campaign):
		campaign.record_story_event(sequence_id)
		if is_instance_valid(campaign.level):
			campaign.level.get_node("Interface").visible = _interface_was_visible
			campaign.level.touch.set_controls_active(not _previous_paused)
	get_tree().paused = _previous_paused
	sequence_finished.emit(sequence_id,skipped)
	sequence_id = ""
	steps.clear()

func _set_portrait(id: String) -> void:
	portrait.visible = id in ["tico","pipo"]
	if portrait.visible:
		portrait.texture = _cinematic_frames[0] if id=="tico" else ATLAS.frame(id,0)

func _build_cinematic_frames() -> void:
	_cinematic_frames.clear()
	var frame_width := CINEMATIC_TICO.get_width()/4.0
	for index in 4:
		var frame := AtlasTexture.new()
		frame.atlas = CINEMATIC_TICO
		frame.region = Rect2(frame_width*index,0,frame_width,CINEMATIC_TICO.get_height())
		_cinematic_frames.append(frame)

func _valid_id(id: String) -> bool:
	return is_instance_valid(campaign) and campaign.store.valid_id(id)

func _build_interface() -> void:
	var root := Control.new()
	root.name = "Root"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	backdrop = ColorRect.new()
	backdrop.color = Color("173d2fee")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(backdrop)
	scene_image = TextureRect.new()
	scene_image.name = "SceneImage"
	scene_image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scene_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	scene_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(scene_image)
	story_actor = TextureRect.new()
	story_actor.name = "StoryActor"
	story_actor.custom_minimum_size = Vector2(285,285)
	story_actor.size = Vector2(285,285)
	story_actor.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	story_actor.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	story_actor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	story_actor.hide()
	root.add_child(story_actor)
	story_companion = TextureRect.new()
	story_companion.name = "StoryCompanion"
	story_companion.custom_minimum_size = Vector2(250,250)
	story_companion.size = Vector2(250,250)
	story_companion.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	story_companion.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	story_companion.material = ShaderMaterial.new()
	story_companion.material.shader = preload("res://scripts/presentation/chroma_key.gdshader")
	story_companion.mouse_filter = Control.MOUSE_FILTER_IGNORE
	story_companion.hide()
	root.add_child(story_companion)
	story_panel = PanelContainer.new()
	story_panel.name = "StoryPanel"
	story_panel.anchor_left = 0.08
	story_panel.anchor_top = 0.50
	story_panel.anchor_right = 0.92
	story_panel.anchor_bottom = 0.92
	story_panel.add_theme_stylebox_override("panel",_box(Color("fff3d9f5"),Color("aec68b")))
	root.add_child(story_panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",4)
	story_panel.add_child(column)
	scene_title = Label.new()
	scene_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	scene_title.add_theme_font_size_override("font_size",20)
	scene_title.add_theme_color_override("font_color",Color("31543e"))
	column.add_child(scene_title)
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation",10)
	column.add_child(row)
	portrait = TextureRect.new()
	portrait.custom_minimum_size = Vector2(68,68)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.material = ShaderMaterial.new()
	portrait.material.shader = preload("res://scripts/presentation/chroma_key.gdshader")
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(portrait)
	var text_column := VBoxContainer.new()
	text_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_column)
	speaker = Label.new()
	speaker.add_theme_font_size_override("font_size",17)
	speaker.add_theme_color_override("font_color",Color("7d512e"))
	text_column.add_child(speaker)
	dialogue = Label.new()
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue.add_theme_font_size_override("font_size",20)
	dialogue.add_theme_color_override("font_color",Color("244b37"))
	text_column.add_child(dialogue)
	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation",12)
	column.add_child(buttons)
	skip_button = _button("Pular cena")
	skip_button.pressed.connect(func(): _finish(true))
	buttons.add_child(skip_button)
	continue_button = _button("Continuar")
	continue_button.pressed.connect(_on_continue)
	buttons.add_child(continue_button)

func _button(text_value: String) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(150,48)
	button.add_theme_font_size_override("font_size",17)
	button.add_theme_color_override("font_color",Color("fff1ce"))
	button.add_theme_stylebox_override("normal",_box(Color("31543e"),Color("88a16a"),14))
	button.add_theme_stylebox_override("pressed",_box(Color("93612e"),Color("f3cb70"),14))
	button.add_theme_stylebox_override("focus",_box(Color("466e49"),Color("e7b956"),14))
	return button

func _box(color: Color, border: Color, radius := 20) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _layout() -> void:
	if not is_instance_valid(continue_button): return
	var touch_mode: bool = is_instance_valid(campaign) and is_instance_valid(campaign.level) and bool(campaign.level.touch.touch_enabled)
	var height := 58.0 if touch_mode else 48.0
	story_panel.anchor_left = 0.035 if touch_mode else 0.06
	story_panel.anchor_right = 0.965 if touch_mode else 0.94
	story_panel.anchor_top = 0.68 if touch_mode else 0.72
	story_panel.anchor_bottom = 0.98 if touch_mode else 0.95
	continue_button.custom_minimum_size.y = height
	skip_button.custom_minimum_size.y = height
	var actor_edge := 180.0 if touch_mode else 285.0
	story_actor.custom_minimum_size = Vector2(actor_edge,actor_edge)
	story_actor.size = Vector2(actor_edge,actor_edge)
	var companion_edge := 170.0 if touch_mode else 250.0
	story_companion.custom_minimum_size = Vector2(companion_edge,companion_edge)
	story_companion.size = Vector2(companion_edge,companion_edge)

func details() -> Dictionary:
	var result := {"active":active,"sequence":sequence_id,"step":step_index,
		"title":scene_title.text if active else "","speaker":speaker.text if active else "",
		"text":dialogue.text if active else "","scene_visible":scene_image.visible if active else false,
		"scene_alpha":scene_image.modulate.a if active else 0.0}
	if active:
		for entry in [["continue_rect",continue_button],["skip_rect",skip_button]]:
			var rect: Rect2 = entry[1].get_global_rect()
			result[entry[0]] = [rect.position.x,rect.position.y,rect.size.x,rect.size.y]
	return result
