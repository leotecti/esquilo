extends CanvasLayer
## Executa sequências narrativas descritas por dados, sem acoplar o conteúdo às fases.
signal animation_requested(actor_id: String, animation_id: String)
signal sequence_finished(sequence_id: String, skipped: bool)

const ATLAS = preload("res://scripts/presentation/atlas_library.gd")
var campaign: Node
var sequence_id := ""
var steps: Array = []
var step_index := -1
var active := false
var _skipped := false
var _previous_paused := false
var _interface_was_visible := true
var backdrop: ColorRect
var scene_title: Label
var portrait: TextureRect
var speaker: Label
var dialogue: Label
var continue_button: Button
var skip_button: Button

func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_interface()
	hide()
	get_viewport().size_changed.connect(_layout)

func play(id: String, content: Array, replay := false) -> bool:
	if active or content.is_empty() or not _valid_id(id): return false
	if not replay and is_instance_valid(campaign) and id in campaign.data.story.events: return false
	sequence_id = id
	steps = content.duplicate(true)
	step_index = -1
	_skipped = false
	active = true
	_previous_paused = get_tree().paused
	if is_instance_valid(campaign.level):
		_interface_was_visible = campaign.level.get_node("Interface").visible
		campaign.level.touch.release_all()
		campaign.level.touch.set_controls_active(false)
		campaign.level.get_node("Interface").hide()
	for action in ["move_left","move_right","jump","action","switch_character"]: Input.action_release(action)
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
		"dialogue": _show_dialogue(step)
		"transition": _transition(step)
		"animation":
			animation_requested.emit(str(step.get("actor","")),str(step.get("animation","")))
			_wait_then_advance(float(step.get("duration",0.35)))
		"event":
			if is_instance_valid(campaign): campaign.record_story_event(str(step.get("id","")))
			_advance()
		_: _advance()

func _apply_scene(step: Dictionary) -> void:
	scene_title.text = str(step.get("title",""))
	scene_title.visible = not scene_title.text.is_empty()
	backdrop.color = Color(str(step.get("color","173d2fee")))

func _show_dialogue(step: Dictionary) -> void:
	var who := str(step.get("speaker","Narrador"))
	speaker.text = who
	dialogue.text = str(step.get("text",""))
	_set_portrait(str(step.get("portrait",who.to_lower())))
	continue_button.text = "Continuar"
	continue_button.disabled = false
	continue_button.grab_focus()

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
		portrait.texture = ATLAS.frame(id,0)

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
	var panel := PanelContainer.new()
	panel.name = "StoryPanel"
	panel.anchor_left = 0.08
	panel.anchor_top = 0.50
	panel.anchor_right = 0.92
	panel.anchor_bottom = 0.92
	panel.add_theme_stylebox_override("panel",_box(Color("fff3d9f5"),Color("aec68b")))
	root.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",10)
	panel.add_child(column)
	scene_title = Label.new()
	scene_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	scene_title.add_theme_font_size_override("font_size",24)
	scene_title.add_theme_color_override("font_color",Color("31543e"))
	column.add_child(scene_title)
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation",18)
	column.add_child(row)
	portrait = TextureRect.new()
	portrait.custom_minimum_size = Vector2(120,120)
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
	speaker.add_theme_font_size_override("font_size",22)
	speaker.add_theme_color_override("font_color",Color("7d512e"))
	text_column.add_child(speaker)
	dialogue = Label.new()
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue.add_theme_font_size_override("font_size",25)
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
	continue_button.pressed.connect(_advance)
	buttons.add_child(continue_button)

func _button(text_value: String) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(190,64)
	button.add_theme_font_size_override("font_size",20)
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
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	return style

func _layout() -> void:
	if not is_instance_valid(continue_button): return
	var touch_mode: bool = is_instance_valid(campaign) and is_instance_valid(campaign.level) and bool(campaign.level.touch.touch_enabled)
	var height := 88.0 if touch_mode else 64.0
	continue_button.custom_minimum_size.y = height
	skip_button.custom_minimum_size.y = height

func details() -> Dictionary:
	return {"active":active,"sequence":sequence_id,"step":step_index,
		"speaker":speaker.text if active else "","text":dialogue.text if active else ""}
